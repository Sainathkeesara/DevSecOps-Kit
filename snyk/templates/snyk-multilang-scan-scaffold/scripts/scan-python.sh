#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-python.sh — Snyk scan for Python projects under the repo root.

set -e

if ! ls requirements.txt Pipfile pyproject.toml >/dev/null 2>&1; then
  echo "python: no manifest found, skipping"
  exit 0
fi

echo "python: scanning"
snyk test --severity-threshold=high --json \
  | tee snyk-results/snyk-python.json >/dev/null