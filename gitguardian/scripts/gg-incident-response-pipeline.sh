#!/usr/bin/env bash
# gg-incident-response-pipeline.sh
#
# Scan a Git repository with GitGuardian ggshield, parse the JSON
# findings, and alert (print / webhook) when secrets are detected.
#
# Usage: ./gg-incident-response-pipeline.sh [repo_path]
#
# Environment variables:
#   GG_TOKEN       - GitGuardian API token for authenticated scans
#   ALERT_WEBHOOK  - Optional HTTP(S) endpoint to POST findings JSON to
#   FAIL_ON        - Minimum severity that fails: low, medium, high (default: high)
#   COMMIT_RANGE   - Git revision range to scan, e.g. HEAD~5..HEAD (default: HEAD)

REPO_PATH="${1:-.}"
FAIL_ON="${FAIL_ON:-high}"
RANGE="${COMMIT_RANGE:-HEAD}"

# Dependency checks. A missing jq produces a cryptic silent parse failure
# downstream, so surface it explicitly up front.
if ! command -v ggshield &>/dev/null; then
  echo "ERROR: ggshield is not installed or not in PATH" >&2
  exit 2
fi
if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required for JSON parsing" >&2
  exit 2
fi

json_payload=$(ggshield secret scan commit-range "$RANGE" \
  --repo "$REPO_PATH" --json 2>/dev/null)
scan_rc=$?

if [[ -z "$json_payload" ]]; then
  echo "WARNING: ggshield produced no JSON output (exit code: $scan_rc)" >&2
  [[ "$scan_rc" -ne 0 ]] && exit "$scan_rc"
  exit 3
fi

if ! echo "$json_payload" | jq empty 2>/dev/null; then
  echo "ERROR: ggshield output is not valid JSON" >&2
  exit 3
fi

# ggshield returns either a raw array or an object with a secrets_scan array.
# Normalize so the rest of the script can treat it uniformly.
normalized=$(echo "$json_payload" | \
  jq 'if type=="array" then . else .secrets_scan // [] end')
total=$(echo "$normalized" | jq 'length')

if [[ "$total" -eq 0 ]]; then
  echo "No secrets detected in $RANGE."
  exit 0
fi

echo "=== GitGuardian Incident Report ==="
echo "Repo       : $REPO_PATH"
echo "Range      : $RANGE"
echo "Findings   : $total"
echo ""

echo "$normalized" | jq -r '.[] |
  "\(.filename):\(.line | tostring) [\(.severity // "unknown")] \(.breaker // .type // "unknown type")"'

# Severity-based pipeline gating.
severity_order="low medium high critical"
fail_index=$(echo "$severity_order" | tr ' ' '\n' \
  | grep -n -x "$FAIL_ON" | head -n1 | cut -d: -f1)
[[ -z "$fail_index" ]] && fail_index=3

exceeds=0
for i in $(seq 0 $(( total - 1 ))); do
  raw_sev=$(echo "$normalized" | jq --argjson i "$i" '.[$i].severity // "low"')
  idx=$(echo "$severity_order" | tr ' ' '\n' \
    | grep -n -x "$raw_sev" | head -n1 | cut -d: -f1)
  [[ -z "$idx" ]] && idx=1
  if [[ "$idx" -ge "$fail_index" ]]; then
    exceeds=1
    break
  fi
done

if [[ "$exceeds" -gt 0 ]]; then
  echo ""
  echo "ERROR: One or more findings meet the $FAIL_ON severity threshold." >&2

  if [[ -n "${ALERT_WEBHOOK:-}" ]]; then
    body=$(echo "$normalized" | jq --arg repo "$REPO_PATH" \
      --arg range "$RANGE" '{repo: $repo, range: $range, findings: .}')
    curl -s -X POST -H "Content-Type: application/json" \
      -d "$body" "$ALERT_WEBHOOK" >/dev/null
    curl_rc=$?
    if [[ "$curl_rc" -ne 0 ]]; then
      echo "WARNING: Webhook POST failed with exit $curl_rc" >&2
    fi
  fi

  exit 1
fi

echo ""
echo "All findings are below the $FAIL_ON threshold. Continuing pipeline."
exit 0
