#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-go.sh — Snyk scan for Go modules under the repo root.

set -e

if [ ! -f "go.mod" ]; then
  echo "go: no go.mod found, skipping"
  exit 0
fi

echo "go: scanning"
snyk test --severity-threshold=high --json \
  | tee snyk-results/snyk-go.json >/dev/null