#!/usr/bin/env bash
# last_verified: 2026-08-19 · GitGuardian ggshield
#
# Merge per-repo ggshield JSON reports into a single summary.
# Handles both raw array and wrapped `secrets_scan` object shapes.
#
# Usage: ./aggregate-report.sh <reports-dir>
#
# Output: JSON object with total findings, severity breakdown, and
# per-repo counts.

set -euo pipefail

REPORTS_DIR="${1:-reports}"

if [[ ! -d "$REPORTS_DIR" ]]; then
  echo "ERROR: reports directory not found: $REPORTS_DIR" >&2
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required" >&2
  exit 2
fi

normalize() {
  jq 'if type=="array" then . else .secrets_scan // [] end'
}

all_findings=$(find "$REPORTS_DIR" -name '*.json' -print 2>/dev/null | \
  while IFS= read -r f; do
    if [[ -s "$f" ]]; then
      normalize < "$f" 2>/dev/null || echo '[]'
    fi
  done | jq -s 'add')

total=$(echo "$all_findings" | jq 'length')

by_severity=$(echo "$all_findings" | jq '
  group_by(.severity // "unknown") |
  map({(.[0].severity // "unknown"): length}) |
  add // {}
')

by_repo=$(echo "$all_findings" | jq '
  group_by(.filename // "unknown") |
  map({(.[0].filename // "unknown"): length}) |
  add // {}
')

jq -n \
  --argjson total "$total" \
  --argjson by_severity "$by_severity" \
  --argjson by_repo "$by_repo" \
  '{total: $total, by_severity: $by_severity, by_repo: $by_repo}'
