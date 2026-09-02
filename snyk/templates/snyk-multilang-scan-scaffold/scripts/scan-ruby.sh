#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-ruby.sh — Snyk scan for Ruby (Bundler) projects under the repo root.

set -e

if [ ! -f "Gemfile" ]; then
  echo "ruby: no Gemfile found, skipping"
  exit 0
fi

echo "ruby: scanning"
snyk test --severity-threshold=high --json \
  | tee snyk-results/snyk-ruby.json >/dev/null