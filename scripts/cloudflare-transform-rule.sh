#!/usr/bin/env bash
#
# Provisions the zone-level Cloudflare Rules this site relies on:
#
#   1. URL Rewrite (http_request_transform phase): a request to `/` carrying
#      `Accept: text/markdown` is rewritten to `/llms.txt`, the LLM-friendly
#      Markdown build. This replaces the old Vercel Build Output API route.
#
#   2. Redirect (http_request_dynamic_redirect phase): www.clig.dev/<path> is
#      301-redirected to https://clig.dev/<path> so the apex stays canonical.
#
# Wrangler cannot manage Transform/Redirect Rules, so this talks to the
# Cloudflare Rulesets API directly.
#
# Idempotent: re-running updates each rule in place (matched by description)
# and leaves any other rules in those phases untouched.
#
# Requirements:
#   - curl, jq               (`brew install jq`)
#   - CLOUDFLARE_API_TOKEN    A token scoped to the clig.dev zone with:
#                               Zone > Transform Rules > Edit
#                               Zone > Single Redirect > Edit
#                               Zone > Zone            > Read
#
# Usage:
#   CLOUDFLARE_API_TOKEN=... ./scripts/cloudflare-transform-rule.sh

set -euo pipefail

ZONE_NAME="${ZONE_NAME:-clig.dev}"
API="https://api.cloudflare.com/client/v4"

: "${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN to a token with Transform Rules + Single Redirect edit access}"
command -v jq >/dev/null || { echo "jq is required (brew install jq)" >&2; exit 1; }

cf() {
  curl -sS -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
           -H "Content-Type: application/json" "$@"
}

# apply_rule <phase> <description> <rule-json>
# Upserts <rule-json> into the zone entry point ruleset for <phase>, matching
# any existing rule by <description>. Other rules in the phase are preserved.
apply_rule() {
  local phase="$1" desc="$2" desired="$3"
  local resp http_code body existing rules

  resp=$(cf -w '\n%{http_code}' "${API}/zones/${zone_id}/rulesets/phases/${phase}/entrypoint")
  http_code=$(printf '%s\n' "$resp" | tail -n1)
  body=$(printf '%s\n' "$resp" | sed '$d')
  case "$http_code" in
    200) existing=$(printf '%s' "$body" | jq '.result.rules // []') ;;
    404) existing='[]' ;;  # no rules in this phase yet
    *)   echo "Failed to read ${phase} ruleset (HTTP ${http_code}): ${body}" >&2; exit 1 ;;
  esac

  rules=$(jq -n --argjson existing "$existing" --argjson desired "$desired" --arg desc "$desc" '
    def writable:
      { action, description, expression, enabled }
      + (if has("id") then {id} else {} end)
      + (if has("action_parameters") then {action_parameters} else {} end);
    ($existing | map(select(.description != $desc) | writable)) + [$desired]')

  echo "→ ${phase}: applying \"${desc}\" ($(printf '%s' "$rules" | jq length) rule(s) total)"
  cf -X PUT "${API}/zones/${zone_id}/rulesets/phases/${phase}/entrypoint" \
     --data "$(jq -n --argjson rules "$rules" '{rules: $rules}')" \
  | jq -r 'if .success then "  ✓ ruleset \(.result.id) updated"
           else (.errors | tostring | halt_error(1)) end'
}

echo "→ Looking up zone ${ZONE_NAME}"
zone_id=$(cf "${API}/zones?name=${ZONE_NAME}" | jq -r '
  if .success then (.result[0].id // "") else (.errors | tostring | halt_error(1)) end')
[ -n "$zone_id" ] || { echo "Zone ${ZONE_NAME} not found for this API token." >&2; exit 1; }
echo "  zone id: ${zone_id}"

# 1. Rewrite / to /llms.txt for clients that ask for Markdown.
rewrite_desc="clig.dev: rewrite / to /llms.txt for Accept: text/markdown"
apply_rule http_request_transform "$rewrite_desc" "$(jq -n \
  --arg desc "$rewrite_desc" \
  --arg expr 'http.request.uri.path eq "/" and any(http.request.headers["accept"][*] contains "text/markdown")' \
  '{
     action: "rewrite",
     description: $desc,
     expression: $expr,
     enabled: true,
     action_parameters: { uri: { path: { value: "/llms.txt" } } }
   }')"

# 2. Redirect www.clig.dev to the apex, preserving path and query string.
redirect_desc="clig.dev: redirect www to apex"
apply_rule http_request_dynamic_redirect "$redirect_desc" "$(jq -n \
  --arg desc "$redirect_desc" \
  --arg expr 'http.host eq "www.clig.dev"' \
  --arg target 'concat("https://clig.dev", http.request.uri.path)' \
  '{
     action: "redirect",
     description: $desc,
     expression: $expr,
     enabled: true,
     action_parameters: {
       from_value: {
         status_code: 301,
         target_url: { expression: $target },
         preserve_query_string: true
       }
     }
   }')"

echo
echo "Verify:"
echo "  curl -sI -H 'Accept: text/markdown' https://${ZONE_NAME}/ | grep -i content-type"
echo "    → expect: content-type: text/markdown; charset=utf-8"
echo "  curl -sI https://www.${ZONE_NAME}/ | grep -iE 'http/|location'"
echo "    → expect: HTTP 301 with location: https://${ZONE_NAME}/"
