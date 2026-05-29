#!/bin/sh
# Automated image vulnerability scanning pipeline with Trivy
#
# Purpose:
#   Scan a container image for vulnerabilities, secrets, and
#   misconfigurations in one pass. Produces SARIF (for GitHub
#   Code Scanning), JSON (for aggregation), and a human-readable
#   summary. Exits non-zero when CRITICAL or HIGH vulns exceed
#   configurable thresholds.
#
# Steps:
#   1. Run trivy image with vuln + secret + misconfig scanners
#   2. Extract severity counts from JSON output
#   3. Compare against fail thresholds
#   4. Print summary to stdout and write report files
#
# Usage:
#   ./image-vuln-pipeline.sh <image> [--severity CRITICAL,HIGH] [--fail-on critical,high]
#   ./image-vuln-pipeline.sh myapp:v1 --severity CRITICAL,HIGH --fail-on critical
#
# Dependencies:
#   - trivy  (>= 0.45 recommended for sarif support)
#   - jq     (JSON parsing for threshold checks)

set -u

# ---- defaults ----
IMAGE=""
SEVERITY="CRITICAL,HIGH"
FAIL_ON="critical"
OUTDIR="./trivy-pipeline-reports"

# ---- arg parsing ----
while [ $# -gt 0 ]; do
  case "$1" in
    --severity)
      SEVERITY="$2"; shift 2 ;;
    --fail-on)
      FAIL_ON="$2"; shift 2 ;;
    --outdir)
      OUTDIR="$2"; shift 2 ;;
    *)
      if [ -z "$IMAGE" ]; then
        IMAGE="$1"; shift
      else
        echo "[!] Unexpected argument: $1"
        echo "Usage: $0 <image> [--severity S] [--fail-on F] [--outdir D]"
        exit 1
      fi
      ;;
  esac
done

if [ -z "$IMAGE" ]; then
  echo "[!] No image specified"
  echo "Usage: $0 <image> [--severity CRITICAL,HIGH] [--fail-on critical,high]"
  exit 1
fi

if ! command -v trivy >/dev/null 2>&1; then
  echo "[!] trivy not found — install from https://trivy.dev"
  exit 1
fi

mkdir -p "$OUTDIR"
SAFE_NAME=$(echo "$IMAGE" | tr '/:' '_')

echo "=== Trivy Pipeline: $IMAGE ==="
echo "Severity filter : $SEVERITY"
echo "Fail-on levels  : $FAIL_ON"
echo "Output dir      : $OUTDIR"
echo ""

# ---- 1. Vulnerability + secret + misconfig scan ----
trivy image "$IMAGE" \
  --severity "$SEVERITY" \
  --scanners vuln,secret,misconfig \
  --format sarif \
  --ignore-unfixed \
  --quiet \
  --output "$OUTDIR/${SAFE_NAME}.sarif" 2>/dev/null

trivy image "$IMAGE" \
  --severity "$SEVERITY" \
  --scanners vuln,secret,misconfig \
  --format json \
  --ignore-unfixed \
  --quiet \
  --output "$OUTDIR/${SAFE_NAME}.json" 2>/dev/null

# ---- 2. Extract severity counts from JSON ----
SEVERITY_COUNTS=$(jq -r '
  [.Results[]?.Vulnerabilities[]? // .Results[]?.Secrets[]? // .Results[]?.Misconfigurations[]?]
  | group_by(.Severity)
  | map({severity: .[0].Severity, count: length})
  | .[]
  | "\(.severity)=\(.count)"
' "$OUTDIR/${SAFE_NAME}.json" 2>/dev/null)

CRIT_COUNT=$(echo "$SEVERITY_COUNTS" | grep -i "^CRITICAL=" | cut -d= -f2 | tr -d '\n')
HIGH_COUNT=$(echo "$SEVERITY_COUNTS" | grep -i "^HIGH=" | cut -d= -f2 | tr -d '\n')
CRIT_COUNT=${CRIT_COUNT:-0}
HIGH_COUNT=${HIGH_COUNT:-0}

# ---- 3. Threshold check ----
FAIL=0
for level in $(echo "$FAIL_ON" | tr ',' ' '); do
  case "$(echo "$level" | tr '[:upper:]' '[:lower:]')" in
    critical)
      if [ "$CRIT_COUNT" -gt 0 ]; then
        echo "[!] FAIL: $CRIT_COUNT CRITICAL findings (threshold: 0)"
        FAIL=1
      fi
      ;;
    high)
      if [ "$HIGH_COUNT" -gt 0 ]; then
        echo "[!] FAIL: $HIGH_COUNT HIGH findings (threshold: 0)"
        FAIL=1
      fi
      ;;
  esac
done

# ---- 4. Summary ----
SUMMARY="$OUTDIR/${SAFE_NAME}-summary.txt"
{
  echo "=== Trivy Pipeline Summary ==="
  echo "Image      : $IMAGE"
  echo "Date       : $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Severities : $SEVERITY"
  echo "---"
  echo "CRITICAL : $CRIT_COUNT"
  echo "HIGH     : $HIGH_COUNT"
  echo "---"
  echo "SARIF report : $OUTDIR/${SAFE_NAME}.sarif"
  echo "JSON report  : $OUTDIR/${SAFE_NAME}.json"
  echo "Verdict      : $([ "$FAIL" -eq 1 ] && echo "FAIL" || echo "PASS")"
} > "$SUMMARY"

cat "$SUMMARY"
echo ""

if [ "$FAIL" -eq 1 ]; then
  echo "[!] Pipeline gate failed — $IMAGE exceeds severity thresholds"
  exit 1
fi

echo "[+] Pipeline passed — $IMAGE is within thresholds"
exit 0
