#!/usr/bin/env bash
# Build the site for Cloudflare Workers Builds.
#
# `wrangler deploy` runs this (via [build].command in wrangler.toml) before
# uploading ./public as the Worker's static assets. Hugo is installed here,
# rather than relied on from the build image, so the build is pinned and
# self-contained. The extended build is required for the Sass pipeline in
# layouts/_default/baseof.html.
set -euo pipefail

HUGO_VERSION="0.160.1"
hugo_url="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"

echo "Installing Hugo ${HUGO_VERSION} (extended)..."
curl -fsSL "$hugo_url" | tar -xz -C /tmp hugo

/tmp/hugo version
/tmp/hugo
