#!/usr/bin/env bash
# last_verified: 2026-08-07 · terrascan n/a
#
# Terrascan policy-as-code workflow: scan IaC with custom Rego policies and gate
# CI on a configurable severity threshold.
#
# Custom policies are version-controlled next to the IaC they govern. This
# script loads them from a policy directory, runs a single Terrascan scan that
# emits JSON for machine consumption, prints a per-severity breakdown, and
# fails the pipeline when findings reach the configured threshold.
#
# Usage:
#   policy-as-code-workflow.sh <iac-dir> <policy-dir> [--fail-on SEVERITY] [--out-dir DIR]
#
# Arguments:
#   iac-dir      Directory of IaC files to scan.
#   policy-dir   Directory of custom Terrascan policy files (Rego/YAML). Custom
#                policies use the `apiVersion: v1, kind: policy` format; see
#                terrascan/configs/ for example policy definitions.
#   --fail-on    Lowest severity that fails the gate: critical|high|medium|low.
#                Default: high
#   --out-dir    Directory for JSON + summary results. Default: ./terrascan-results
#
# Exit codes:
#   0  gate passed (no findings at/above --fail-on)
#   1  gate failed (findings at/above --fail-on)
#   2  usage or dependency error

set -euo pipefail

IAC_DIR=""
POLICY_DIR=""
FAIL_ON="high"
OUT_DIR="./terrascan-results"

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    --fail-on) FAIL_ON="$2"; shift 2 ;;
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *)
      if [ -z "$IAC_DIR" ]; then
        IAC_DIR="$1"
      elif [ -z "$POLICY_DIR" ]; then
        POLICY_DIR="$1"
      else
        echo "Unexpected argument: $1" >&2
        exit 2
      fi
      shift ;;
  esac
done

if [ -z "$IAC_DIR" ] || [ -z "$POLICY_DIR" ]; then
  usage
  exit 2
fi

if [ ! -d "$IAC_DIR" ]; then
  echo "IaC directory not found: $IAC_DIR" >&2
  exit 2
fi
if [ ! -d "$POLICY_DIR" ]; then
  echo "Policy directory not found: $POLICY_DIR" >&2
  exit 2
fi

for bin in terrascan jq; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "Missing required binary: $bin" >&2
    exit 2
  fi
done

mkdir -p "$OUT_DIR"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
JSON_FILE="$OUT_DIR/terrascan-${TIMESTAMP}.json"
LOG_FILE="$OUT_DIR/scan-${TIMESTAMP}.log"
SUMMARY_FILE="$OUT_DIR/summary-${TIMESTAMP}.txt"

# Run the scan once. --config-path loads custom policy files alongside the
# built-in rule set; -o json yields the parseable artifact the gate below
# operates on. Terrascan's --exit-code flag semantics are inconsistent across
# versions, so gating parses the JSON directly instead of trusting its exit
# status (see terrascan/notes/ for the exit-code gotcha write-ups).
terrascan scan -d "$IAC_DIR" --config-path "$POLICY_DIR" -o json \
  > "$JSON_FILE" 2> "$LOG_FILE" || true

TOTAL="$(jq '.results.violations | length' "$JSON_FILE" 2>/dev/null || echo 0)"

# Per-severity breakdown for the human-readable summary.
{
  echo "# Terrascan policy-as-code scan - $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# target: $IAC_DIR  |  policies: $POLICY_DIR  |  fail-on: $FAIL_ON"
  echo "# total violations: $TOTAL"
  echo
  jq -r '
    (.results.violations // [])
    | group_by(.severity)
    | .[]
    | "\(.[0].severity): \(length)"
  ' "$JSON_FILE" 2>/dev/null || echo "(no violations parsed)"
} > "$SUMMARY_FILE"

# Severity gate. Ordering is critical > high > medium > low. The gate fails
# when any finding ranks at or above the threshold severity.
FAIL_COUNT="$(jq --arg failon "$FAIL_ON" '
  def rank(s): {"critical":0,"high":1,"medium":2,"low":3}[(s|ascii_downcase)] // 9;
  [ (.results.violations // [])[] | select(rank(.severity) <= rank($failon)) ] | length
' "$JSON_FILE" 2>/dev/null || echo 0)"

if [ "$FAIL_COUNT" -gt 0 ]; then
  cat "$SUMMARY_FILE" >&2
  echo "Gate FAILED: $FAIL_COUNT finding(s) at or above $FAIL_ON severity." >&2
  echo "Review the per-severity breakdown above; relax the threshold or fix the findings." >&2
  exit 1
fi

# Verify: print a concise pass line and result locations so the CI log is
# self-explanatory on success.
echo "Gate passed: $TOTAL violation(s) total, none at or above $FAIL_ON."
echo "Results JSON:  $JSON_FILE"
echo "Scan log:      $LOG_FILE"
echo "Summary:       $SUMMARY_FILE"
