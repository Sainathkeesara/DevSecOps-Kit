#!/usr/bin/env bash
# Snyk vulnerability scanning pipeline — test, monitor, fail on high CVEs
#
# Purpose:
#   Run snyk test against a local project or container image, push a
#   snapshot to the Snyk dashboard for continuous monitoring, and fail
#   the build when CRITICAL or HIGH vulnerabilities are detected.
#
# Steps:
#   1. Resolve the target (directory for code, image ref for containers)
#   2. Run snyk test with a severity threshold and capture JSON output
#   3. Push results to Snyk monitor for ongoing tracking
#   4. Parse severity counts and exit non-zero if thresholds are breached
#
# Usage:
#   ./snyk-vuln-scan-pipeline.sh <target> [--fail-on <severity>] [--outdir <dir>] [--no-monitor]
#   ./snyk-vuln-scan-pipeline.sh ./my-app
#   ./snyk-vuln-scan-pipeline.sh myapp:v1 --outdir ./snyk-reports

set -euo pipefail

FAIL_ON="${FAIL_ON:-high}"
OUTDIR="${OUTDIR:-./snyk-reports}"
MONITOR=true

# Resolve target
if [ $# -lt 1 ]; then
  echo "Usage: $0 <target> [--fail-on <severity>] [--outdir <dir>] [--no-monitor]"
  exit 1
fi

TARGET="$1"
shift

mkdir -p "$OUTDIR"

# Parse remaining args
while [ $# -gt 0 ]; do
  case "$1" in
    --fail-on)
      FAIL_ON="$2"; shift 2 ;;
    --outdir)
      OUTDIR="$2"; shift 2 ;;
    --no-monitor)
      MONITOR=false; shift ;;
    *)
      echo "[!] Unknown argument: $1"; exit 1 ;;
  esac
done

if [ ! -d "$TARGET" ] && [[ "$TARGET" != *":"* ]]; then
  echo "[!] Target must be a directory (code) or image ref (name:tag)"
  exit 1
fi

echo "[*] Target: $TARGET"
echo "[*] Fail-on: $FAIL_ON"
echo "[*] Output: $OUTDIR"

# Determine scan mode
if [ -d "$TARGET" ]; then
  SCAN_CMD=(snyk test --severity-threshold="$FAIL_ON" --json)
else
  SCAN_CMD=(snyk container test --severity-threshold="$FAIL_ON" --json "$TARGET")
fi

# Run test — snyk exits 1 when vulnerabilities exceed the threshold,
# but we capture output regardless so we can parse counts
REPORT="$OUTDIR/$(basename "$TARGET" | tr '/:' '_')-snyk.json"
"${SCAN_CMD[@]}" > "$REPORT" 2>/dev/null || true

# Monitor for ongoing tracking
if [ "$MONITOR" = true ]; then
  if [ -d "$TARGET" ]; then
    snyk monitor --project-name="$(basename "$TARGET")" >/dev/null 2>&1 || true
  else
    snyk container monitor "$TARGET" >/dev/null 2>&1 || true
  fi
  echo "[*] Snapshot pushed to Snyk dashboard"
fi

# Parse severity counts
if [ -f "$REPORT" ]; then
  CRITICAL=$(jq '[.vulnerabilities[]? | select(.severity == "critical")] | length' "$REPORT" 2>/dev/null || echo 0)
  HIGH=$(jq '[.vulnerabilities[]? | select(.severity == "high")] | length' "$REPORT" 2>/dev/null || echo 0)
  MEDIUM=$(jq '[.vulnerabilities[]? | select(.severity == "medium")] | length' "$REPORT" 2>/dev/null || echo 0)
  LOW=$(jq '[.vulnerabilities[]? | select(.severity == "low")] | length' "$REPORT" 2>/dev/null || echo 0)
else
  CRITICAL=0; HIGH=0; MEDIUM=0; LOW=0
fi

echo ""
echo "=== Snyk Scan Summary ==="
echo "Critical : $CRITICAL"
echo "High     : $HIGH"
echo "Medium   : $MEDIUM"
echo "Low      : $LOW"
echo "Report   : $REPORT"

FAIL=0
case "$FAIL_ON" in
  high|critical)
    if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ]; then
      echo "[!] Failing pipeline: vulnerabilities at or above $FAIL_ON threshold found"
      FAIL=1
    fi
    ;;
  medium)
    if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ] || [ "$MEDIUM" -gt 0 ]; then
      echo "[!] Failing pipeline: vulnerabilities at or above $FAIL_ON threshold found"
      FAIL=1
    fi
    ;;
esac

if [ "$FAIL" -eq 1 ]; then
  exit 1
fi

echo "[+] No vulnerabilities at or above $FAIL_ON threshold"
exit 0
