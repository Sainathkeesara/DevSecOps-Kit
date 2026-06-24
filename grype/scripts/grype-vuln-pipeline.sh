#!/usr/bin/env bash
# Grype vulnerability scanning pipeline with SARIF output
#
# Purpose:
#   Scan container images for vulnerabilities and produce SARIF output
#   for CI integration (GitHub Code Scanning, Azure DevOps, etc.).
#   Exits non-zero when CRITICAL or HIGH vulnerabilities are found.
#
# When to use:
#   - CI/CD pipeline stage for container image security gates
#   - Pre-push or pre-merge validation of built images
#   - GitHub Actions workflows requiring vulnerability reports
#
# Prerequisites:
#   - grype (>= 0.67.0 for full sarif support)
#   - jq (JSON parsing for summary generation)
#
# Usage:
#   ./grype-vuln-pipeline.sh <image> [--fail-on <severity>] [--format <json|sarif>]
#   ./grype-vuln-pipeline.sh myapp:v1 --fail-on critical --format sarif
#
# References:
#   - https://github.com/anchore/grype
#   - https://docs.github.com/en/code-security/code-scanning/automatically-scanning

set -euo pipefail

# ---- defaults ----
IMAGE=""
FAIL_ON="${FAIL_ON:-high}"
FORMAT="${FORMAT:-sarif}"
OUTDIR="${OUTDIR:-./grype-pipeline-reports}"

# ---- arg parsing ----
while [ $# -gt 0 ]; do
  case "$1" in
    --fail-on)
      FAIL_ON="$2"; shift 2 ;;
    --format)
      FORMAT="$2"; shift 2 ;;
    --outdir)
      OUTDIR="$2"; shift 2 ;;
    *)
      if [ -z "$IMAGE" ]; then
        IMAGE="$1"; shift
      else
        echo "[!] Unexpected argument: $1" >&2
        exit 1
      fi
      ;;
  esac
done

if [ -z "$IMAGE" ]; then
  echo "[!] No image specified" >&2
  echo "Usage: $0 <image> [--fail-on <severity>] [--format <json|sarif>] [--outdir <dir>]" >&2
  exit 1
fi

# ---- validation ----
if ! command -v grype >/dev/null 2>&1; then
  echo "[!] grype not found — install from https://github.com/anchore/grype" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[!] jq not found — install for JSON summary generation" >&2
  exit 1
fi

case "$FAIL_ON" in
  negligible|low|medium|high|critical) ;;
  *)
    echo "[!] FAIL_ON must be one of: negligible, low, medium, high, critical" >&2
    exit 1
    ;;
esac

case "$FORMAT" in
  json|sarif|table) ;;
  *)
    echo "[!] FORMAT must be one of: json, sarif, table" >&2
    exit 1
    ;;
esac

# ---- setup ----
mkdir -p "$OUTDIR"
SAFE_NAME=$(echo "$IMAGE" | tr '/:@' '__')
REPORT_FILE="$OUTDIR/${SAFE_NAME}.${FORMAT}"

echo "[*] Grype vulnerability pipeline: $IMAGE"
echo "[*] Fail-on: $FAIL_ON, Format: $FORMAT"
echo "[*] Output: $REPORT_FILE"
echo ""

# ---- scan ----
echo "[*] Scanning $IMAGE for vulnerabilities..."
GRYPE_EXIT=0

# Note: --only-fixed focuses on vulnerabilities with available fixes.
# Remove it if you want all vulnerabilities regardless of fix status.
if ! grype "$IMAGE" \
  --fail-on "$FAIL_ON" \
  --output "$FORMAT" > "$REPORT_FILE" 2>&1; then
  GRYPE_EXIT=$?
fi

# ---- sarif summary (if applicable) ----
if [ "$FORMAT" = "sarif" ]; then
  echo "[*] Converting SARIF to summary..."
  TOTAL_RESULTS=$(jq '.runs[0].results | length' "$REPORT_FILE" 2>/dev/null || echo 0)
  CRITICAL=$(jq '[.runs[0].results[]? | select(.level == "error" or .properties?.severity == "critical")] | length' "$REPORT_FILE" 2>/dev/null || echo 0)
  HIGH=$(jq '[.runs[0].results[]? | select(.level == "warning" or .properties?.severity == "high")] | length' "$REPORT_FILE" 2>/dev/null || echo 0)
  echo "[*] Found: $CRITICAL critical, $HIGH high, $TOTAL_RESULTS total findings"
fi

if [ "$FORMAT" = "json" ]; then
  echo "[*] Generating JSON summary..."
  jq -r '.matches[]? | "\(.vulnerability.severity) - \(.package.name): \(.vulnerability.id)"' "$REPORT_FILE" 2>/dev/null | head -20 || true
fi

# ---- verify ----
echo ""
echo "[*] Verifying results..."

if [ "$GRYPE_EXIT" -ne 0 ]; then
  echo "[!] Vulnerabilities detected at or above $FAIL_ON threshold"
  echo "[*] Report: $REPORT_FILE"
  echo "[*] For SARIF: use 'jq' or upload to CI platform"
  exit "$GRYPE_EXIT"
fi

echo "[+] No vulnerabilities at or above $FAIL_ON threshold"
echo "[*] Report saved: $REPORT_FILE"
echo "[*] Integrate with CI by uploading $REPORT_FILE as a SARIF artifact"
exit 0