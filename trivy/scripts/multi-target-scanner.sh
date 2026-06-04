#!/bin/sh
# Multi-target Trivy scanner: images, filesystems, and Git repos
#
# Purpose:
#   Run Trivy scans across multiple target types in a single invocation.
#   Accepts a list of targets with type prefixes (image:, fs:, repo:)
#   and produces per-target SARIF + JSON reports in one output directory.
#
# When to use:
#   - CI pipelines that need to scan both the built image and the repo
#   - Pre-release verification across all artifacts
#   - Batch scanning after a dependency update
#
# Prerequisites:
#   - trivy (>= 0.45)
#   - jq
#
# Usage:
#   ./multi-target-scanner.sh image:alpine:latest fs:./src repo:https://github.com/org/repo
#   ./multi-target-scanner.sh --severity HIGH,CRITICAL --outdir ./reports image:myapp:v1 fs:.

set -u

SEVERITY="CRITICAL,HIGH"
OUTDIR="./trivy-multi-reports"
TARGETS=""

while [ $# -gt 0 ]; do
  case "$1" in
    --severity)
      SEVERITY="$2"; shift 2 ;;
    --outdir)
      OUTDIR="$2"; shift 2 ;;
    -*)
      echo "[!] Unknown option: $1"
      exit 1
      ;;
    *)
      TARGETS="$TARGETS $1"; shift ;;
  esac
done

if [ -z "$TARGETS" ]; then
  echo "[!] No targets specified"
  echo "Usage: $0 [--severity S] [--outdir D] <target>..."
  echo "  Targets:  image:<name>   — container image"
  echo "            fs:<path>      — filesystem path"
  echo "            repo:<url>     — Git repository"
  exit 1
fi

if ! command -v trivy >/dev/null 2>&1; then
  echo "[!] trivy not found — install from https://trivy.dev"
  exit 1
fi

mkdir -p "$OUTDIR"

TOTAL_SCANNED=0
TOTAL_FAILED=0
SUMMARY_FILE="$OUTDIR/aggregated-summary.txt"

scan_target() {
  TYPE="$1"
  VALUE="$2"
  SAFE_NAME=$(echo "${TYPE}_${VALUE}" | tr '/:.' '___' | tr -d '[:space:]')
  SARIF_FILE="$OUTDIR/${SAFE_NAME}.sarif"
  JSON_FILE="$OUTDIR/${SAFE_NAME}.json"

  echo "[*] Scanning $TYPE:$VALUE ..."

  case "$TYPE" in
    image)
      trivy image "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format sarif \
        --ignore-unfixed \
        --quiet \
        --output "$SARIF_FILE" 2>/dev/null
      trivy image "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format json \
        --ignore-unfixed \
        --quiet \
        --output "$JSON_FILE" 2>/dev/null
      ;;
    fs)
      trivy fs "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format sarif \
        --ignore-unfixed \
        --quiet \
        --output "$SARIF_FILE" 2>/dev/null
      trivy fs "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format json \
        --ignore-unfixed \
        --quiet \
        --output "$JSON_FILE" 2>/dev/null
      ;;
    repo)
      trivy repo "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format sarif \
        --ignore-unfixed \
        --quiet \
        --output "$SARIF_FILE" 2>/dev/null
      trivy repo "$VALUE" \
        --severity "$SEVERITY" \
        --scanners vuln,secret,misconfig \
        --format json \
        --ignore-unfixed \
        --quiet \
        --output "$JSON_FILE" 2>/dev/null
      ;;
    *)
      echo "  [!] Unknown target type: $TYPE (use image:, fs:, or repo:)"
      return 1
      ;;
  esac

  if [ ! -f "$SARIF_FILE" ] || [ ! -f "$JSON_FILE" ]; then
    echo "  [!] Scan produced no output for $TYPE:$VALUE"
    return 1
  fi

  CRIT_COUNT=$(jq '[.Results[]? | .Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$JSON_FILE" 2>/dev/null || echo 0)
  HIGH_COUNT=$(jq '[.Results[]? | .Vulnerabilities[]? | select(.Severity == "HIGH")] | length' "$JSON_FILE" 2>/dev/null || echo 0)

  echo "  -> CRITICAL: $CRIT_COUNT, HIGH: $HIGH_COUNT  (SARIF: $SARIF_FILE)"
  return 0
}

echo "=== Trivy Multi-Target Scanner ==="
echo "Severity filter : $SEVERITY"
echo "Output dir      : $OUTDIR"
echo ""

for TARGET in $TARGETS; do
  TYPE="${TARGET%%:*}"
  VALUE="${TARGET#*:}"

  if [ "$TYPE" = "$VALUE" ] || [ -z "$VALUE" ]; then
    echo "[!] Invalid target format: $TARGET (use type:value)"
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    continue
  fi

  TOTAL_SCANNED=$((TOTAL_SCANNED + 1))
  if ! scan_target "$TYPE" "$VALUE"; then
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
  fi
  echo ""
done

{
  echo "=== Trivy Multi-Target Scan Summary ==="
  echo "Date      : $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Severity  : $SEVERITY"
  echo "---"
  echo "Targets scanned : $TOTAL_SCANNED"
  echo "Targets failed  : $TOTAL_FAILED"
  echo "---"
  echo "Reports in: $OUTDIR/"
} > "$SUMMARY_FILE"

cat "$SUMMARY_FILE"

if [ "$TOTAL_FAILED" -gt 0 ]; then
  echo "[!] $TOTAL_FAILED target(s) failed"
  exit 1
fi

echo "[+] All targets scanned successfully"
exit 0
