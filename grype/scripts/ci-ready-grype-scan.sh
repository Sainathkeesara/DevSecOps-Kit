#!/usr/bin/env bash
# Purpose: CI-ready Grype scanning wrapper with configurable severity thresholds
# Usage: ./ci-ready-grype-scan.sh <image> [--fail-on <severity>] [--format <table|json>]
# Defaults: --fail-on high --format json

set -euo pipefail

IMAGE="${1:?Usage: $0 <image> [--fail-on <severity>] [--format <table|json>]}"
FAIL_ON="${FAIL_ON:-high}"
FORMAT="${FORMAT:-json}"
OUTDIR="${OUTDIR:-./grype-output}"

mkdir -p "$OUTDIR"

echo "[*] Scanning $IMAGE with Grype (fail-on: $FAIL_ON)..."

# Run Grype scan - exit code 0 if no issues meet threshold
grype "$IMAGE" \
  --fail-on "$FAIL_ON" \
  --output "$FORMAT" > "$OUTDIR/scan-results.$FORMAT"

EXIT_CODE=$?

# For JSON format, produce a formatted summary
if [ "$FORMAT" = "json" ]; then
  echo "[*] Formatting summary..."
  jq -r '.Matches[]? | "\(.Vulnerability.Severity) - \(.Package.Name): \(.Vulnerability.Description)"' "$OUTDIR/scan-results.json" 2>/dev/null > "$OUTDIR/summary.txt" || true
  
  # Count by severity for reporting
  CRITICAL=$(jq '[.Matches[]? | select(.Vulnerability.Severity == "Critical")] | length' "$OUTDIR/scan-results.json" 2>/dev/null || echo 0)
  HIGH=$(jq '[.Matches[]? | select(.Vulnerability.Severity == "High")] | length' "$OUTDIR/scan-results.json" 2>/dev/null || echo 0)
  
  echo "[*] Found: $CRITICAL Critical, $HIGH High vulnerabilities"
fi

if [ $EXIT_CODE -ne 0 ]; then
  echo "[!] Vulnerabilities at or above $FAIL_ON threshold detected"
  echo "[*] Full report: $OUTDIR/scan-results.$FORMAT"
  exit $EXIT_CODE
fi

echo "[+] No vulnerabilities at or above $FAIL_ON threshold"
echo "[*] Report saved: $OUTDIR/scan-results.$FORMAT"