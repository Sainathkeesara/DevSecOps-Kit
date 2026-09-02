#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-node.sh — Snyk scan for Node.js projects under the repo root.

set -e

if [ ! -f "package.json" ]; then
  echo "node: no package.json found, skipping"
  exit 0
fi

echo "node: scanning"
snyk test --all-projects --severity-threshold=high --json \
  | tee snyk-results/snyk-node.json >/dev/null