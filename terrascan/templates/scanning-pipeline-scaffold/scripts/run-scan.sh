#!/usr/bin/env bash
# last_verified: 2026-08-09 · terrascan n/a
#
# Terrascan scanning pipeline scaffold runner.
# Accepts a directory of IaC files, loads custom policies from the
# policies/ folder in this scaffold, runs a scan, and prints a
# per-severity breakdown of violations.
#
# Usage:
#   run-scan.sh <iac-dir> [policy-dir]
#
# Arguments:
#   iac-dir      Directory of IaC files to scan. Default: ./
#   policy-dir   Directory of custom policies. Default: ./policies

set -euo pipefail

IAC_DIR="${1:-./}"
POLICY_DIR="${2:-./policies}"
OUT_DIR="./terrascan-results"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
JSON_FILE="$OUT_DIR/terrascan-${TIMESTAMP}.json"
SUMMARY_FILE="$OUT_DIR/summary-${TIMESTAMP}.txt"

if [ ! -d "$IAC_DIR" ]; then
  echo "IaC directory not found: $IAC_DIR" >&2
  exit 2
fi

for bin in terrascan jq; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "Missing required binary: $bin" >&2
    exit 2
  fi
done

mkdir -p "$OUT_DIR"

# Run the scan once. --config-path loads custom policy files alongside
# the built-in rule set; -o json yields the parseable artifact below.
terrascan scan -d "$IAC_DIR" --config-path "$POLICY_DIR" -o json \
  > "$JSON_FILE" 2> "$OUT_DIR/scan-${TIMESTAMP}.log" || true

TOTAL="$(jq '.results.violations | length' "$JSON_FILE" 2>/dev/null || echo 0)"

{
  echo "# Terrascan scan - $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# target: $IAC_DIR  |  policies: $POLICY_DIR"
  echo "# total violations: $TOTAL"
  echo
  jq -r '
    (.results.violations // [])
    | group_by(.severity)
    | .[]
    | "\(.[0].severity): \(length)"
  ' "$JSON_FILE" 2>/dev/null || echo "(no violations parsed)"
} > "$SUMMARY_FILE"

cat "$SUMMARY_FILE"
echo
echo "Results JSON:  $JSON_FILE"
echo "Scan log:      $OUT_DIR/scan-${TIMESTAMP}.log"
echo "Summary:       $SUMMARY_FILE"
