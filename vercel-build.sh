#!/bin/bash
# Post-build step for Vercel: packages Hugo output using the Build Output API.
# We use this instead of vercel.json routes because Build Output API routes
# run before static file serving, which lets us content-negotiate on /
# (vercel.json rewrites run after, so index.html always wins).
set -e

# Copy Hugo's output into the Build Output API structure
mkdir -p .vercel/output/static
cp -r public/* .vercel/output/static/

# Define routes that run before static file serving
cat > .vercel/output/config.json << 'EOF'
{
  "version": 3,
  "routes": [
    {
      "src": "^/$",
      "has": [{ "type": "header", "key": "accept", "value": "text/markdown" }],
      "dest": "/llms.txt",
      "headers": { "Content-Type": "text/markdown; charset=utf-8" }
    },
    {
      "src": "^/llms\\.txt$",
      "headers": { "Content-Type": "text/markdown; charset=utf-8" },
      "continue": true
    }
  ]
}
EOF
