#!/usr/bin/env bash
#
# Provisions the Cloudflare URL Rewrite Transform Rule that content-negotiates
# the homepage: a request to `/` carrying `Accept: text/markdown` is rewritten
# to `/llms.txt` (the LLM-friendly Markdown build). Every other request to `/`
# gets the normal HTML page.
#
# This is the Cloudflare equivalent of the old Vercel Build Output API route
# that lived in vercel-build.sh. Wrangler cannot manage Transform Rules, so
# this talks to the Cloudflare Rulesets API directly.
#
# Idempotent: re-running updates the rule in place (matched by description) and
# leaves any other Transform Rules in the zone untouched.
#
# Requirements:
#   - curl, jq               (`brew install jq`)
#   - CLOUDFLARE_API_TOKEN    A token scoped to the clig.dev zone with:
#                               Zone > Transform Rules > Edit
#                               Zone > Zone            > Read
#
# Usage:
#   CLOUDFLARE_API_TOKEN=... ./scripts/cloudflare-transform-rule.sh

set -euo pipefail

ZONE_NAME="${ZONE_NAME:-clig.dev}"
API="https://api.cloudflare.com/client/v4"
PHASE="http_request_transform"

RULE_DESCRIPTION="clig.dev: rewrite / to /llms.txt for Accept: text/markdown"
RULE_EXPRESSION='http.request.uri.path eq "/" and any(http.request.headers["accept"][*] contains "text/markdown")'
REWRITE_PATH="/llms.txt"

: "${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN to a token with Transform Rules edit access}"
command -v jq >/dev/null || { echo "jq is required (brew install jq)" >&2; exit 1; }

cf() {
  curl -sS -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
           -H "Content-Type: application/json" "$@"
}

echo "→ Looking up zone ${ZONE_NAME}"
zone_id=$(cf "${API}/zones?name=${ZONE_NAME}" | jq -r '
  if .success then (.result[0].id // "") else (.errors | tostring | halt_error(1)) end')
[ -n "$zone_id" ] || { echo "Zone ${ZONE_NAME} not found for this API token." >&2; exit 1; }
echo "  zone id: ${zone_id}"

# The rule we want to exist.
desired=$(jq -n \
  --arg desc "$RULE_DESCRIPTION" \
  --arg expr "$RULE_EXPRESSION" \
  --arg path "$REWRITE_PATH" \
  '{
     action: "rewrite",
     description: $desc,
     expression: $expr,
     enabled: true,
     action_parameters: { uri: { path: { value: $path } } }
   }')

# Read the current rules in the URL-rewrite phase. The phase entry point may
# not exist yet — a 404 just means the zone has no Transform Rules at all.
echo "→ Reading existing ${PHASE} rules"
resp=$(cf -w '\n%{http_code}' "${API}/zones/${zone_id}/rulesets/phases/${PHASE}/entrypoint")
http_code=$(printf '%s\n' "$resp" | tail -n1)
body=$(printf '%s\n' "$resp" | sed '$d')
case "$http_code" in
  200) existing=$(printf '%s' "$body" | jq '.result.rules // []') ;;
  404) existing='[]' ;;
  *)   echo "Failed to read ruleset (HTTP ${http_code}): ${body}" >&2; exit 1 ;;
esac

# Keep every other rule verbatim (writable fields only), replace ours, append
# it if it is not there yet.
rules=$(jq -n \
  --argjson existing "$existing" \
  --argjson desired "$desired" \
  --arg desc "$RULE_DESCRIPTION" '
    def writable:
      { action, description, expression, enabled }
      + (if has("id") then {id} else {} end)
      + (if has("action_parameters") then {action_parameters} else {} end);
    ($existing | map(select(.description != $desc) | writable)) + [$desired]')

echo "→ Applying ruleset ($(printf '%s' "$rules" | jq length) rule(s) total)"
cf -X PUT "${API}/zones/${zone_id}/rulesets/phases/${PHASE}/entrypoint" \
   --data "$(jq -n --argjson rules "$rules" '{rules: $rules}')" \
| jq -r '
  if .success
  then "✓ Done — ruleset \(.result.id) now has \(.result.rules | length) rule(s)."
  else (.errors | tostring | halt_error(1)) end'

echo
echo "Verify once DNS points clig.dev at Cloudflare Pages:"
echo "  curl -sI -H 'Accept: text/markdown' https://${ZONE_NAME}/ | grep -i content-type"
echo "  → expect: content-type: text/markdown; charset=utf-8"
