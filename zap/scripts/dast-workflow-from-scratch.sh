#!/usr/bin/env bash
# Purpose: Run a ZAP DAST workflow from spider discovery through active scanning and reporting.
# Usage: ./dast-workflow-from-scratch.sh <target_url> [api_key]

set -euo pipefail

TARGET_URL="${1:?Usage: $0 <target_url> [api_key]}"
API_KEY="${2:-${ZAP_API_KEY:-$(openssl rand -hex 16 2>/dev/null || printf '%s' "$(date +%s)-local")}}"
ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"
ZAP_HOST="${ZAP_HOST:-127.0.0.1}"
ZAP_PORT="${ZAP_PORT:-8090}"
OUTDIR="${OUTDIR:-./zap-reports}"
FAIL_ON="${FAIL_ON:-high}"
POLL_SECONDS="${POLL_SECONDS:-5}"
CONTAINER_NAME="${ZAP_CONTAINER_NAME:-zap-dast-worker}"

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] docker is required to start the ZAP daemon"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "[!] curl is required for the ZAP REST API"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[!] jq is required to parse ZAP JSON output"
  exit 1
fi

mkdir -p "$OUTDIR"

cleanup() {
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

zap_get() {
  local endpoint="$1"
  shift

  local args=()
  local pair key value
  for pair in "$@"; do
    key="${pair%%=*}"
    value="${pair#*=}"
    args+=(--data-urlencode "$key=$value")
  done
  args+=(--data-urlencode "apikey=$API_KEY")

  curl -fsS --get "http://${ZAP_HOST}:${ZAP_PORT}/JSON/${endpoint}/" "${args[@]}"
}

zap_report() {
  local endpoint="$1"
  local output_file="$2"

  curl -fsS --get "http://${ZAP_HOST}:${ZAP_PORT}/OTHER/${endpoint}/" \
    --data-urlencode "apikey=$API_KEY" \
    -o "$output_file"
}

wait_for_zap() {
  local attempt=0
  while [ "$attempt" -lt 30 ]; do
    attempt=$((attempt + 1))
    if zap_get core/view/version >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done

  echo "[!] ZAP API did not become ready on ${ZAP_HOST}:${ZAP_PORT}"
  docker logs "$CONTAINER_NAME" >&2 || true
  exit 1
}

poll_scan() {
  local label="$1"
  local view_endpoint="$2"
  local scan_id="$3"
  local status

  while true; do
    status=$(zap_get "${view_endpoint}/status" "scanId=$scan_id" | jq -r '.status // "0"')

    case "$status" in
      ''|*[!0-9]*)
        echo "[!] Unexpected ${label} status from ZAP: ${status}"
        exit 1
        ;;
    esac

    echo "[*] ${label} progress: ${status}%"
    if [ "$status" = "100" ]; then
      return 0
    fi

    sleep "$POLL_SECONDS"
  done
}

count_risk() {
  local risk="$1"
  jq "[.alerts[]? | select(.risk == \"${risk}\")] | length" "$OUTDIR/zap-alerts.json"
}

threshold_failed() {
  local high medium low informational total

  high=$(count_risk "High")
  medium=$(count_risk "Medium")
  low=$(count_risk "Low")
  informational=$(count_risk "Informational")
  total=$((high + medium + low + informational))

  case "${FAIL_ON,,}" in
    never|none)
      return 1
      ;;
    informational)
      [ "$total" -gt 0 ]
      return
      ;;
    low)
      [ $((low + medium + high)) -gt 0 ]
      return
      ;;
    medium)
      [ $((medium + high)) -gt 0 ]
      return
      ;;
    high|critical)
      [ "$high" -gt 0 ]
      return
      ;;
    *)
      echo "[!] Unknown FAIL_ON value: $FAIL_ON"
      exit 1
      ;;
  esac
}

echo "=== ZAP DAST Workflow ==="
echo "Target        : $TARGET_URL"
echo "API key       : ${API_KEY:0:4}..."
echo "Image         : $ZAP_IMAGE"
echo "Reports       : $OUTDIR"
echo "Fail threshold: $FAIL_ON"
echo ""

echo "[*] Starting ZAP daemon in Docker..."
docker run -d --name "$CONTAINER_NAME" \
  -p "${ZAP_PORT}:8090" \
  "$ZAP_IMAGE" \
  zap.sh -daemon -host 0.0.0.0 -port 8090 \
  -config "api.key=$API_KEY" \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true >/dev/null

wait_for_zap

echo "[*] Starting spider scan..."
SPIDER_ID=$(zap_get spider/action/scan \
  "url=$TARGET_URL" \
  "recurse=true" \
  "maxChildren=0" \
  "subtreeOnly=false" | jq -r '.scan // empty')

if [ -z "$SPIDER_ID" ]; then
  echo "[!] ZAP did not return a spider scan ID"
  exit 1
fi
poll_scan "spider" "spider/view" "$SPIDER_ID"

echo "[*] Starting active scan..."
SCAN_ID=$(zap_get ascan/action/scan \
  "url=$TARGET_URL" \
  "recurse=true" \
  "scanPolicyName=" | jq -r '.scan // empty')

if [ -z "$SCAN_ID" ]; then
  echo "[!] ZAP did not return an active scan ID"
  exit 1
fi
poll_scan "active scan" "ascan/view" "$SCAN_ID"

echo "[*] Writing reports..."
zap_report core/other/htmlreport "$OUTDIR/zap-report.html"
zap_get core/view/alerts "baseurl=$TARGET_URL" > "$OUTDIR/zap-alerts.json"

HIGH_COUNT=$(count_risk "High")
MEDIUM_COUNT=$(count_risk "Medium")
LOW_COUNT=$(count_risk "Low")
INFO_COUNT=$(count_risk "Informational")
TOTAL_COUNT=$((HIGH_COUNT + MEDIUM_COUNT + LOW_COUNT + INFO_COUNT))

cat > "$OUTDIR/zap-summary.txt" <<EOF
=== ZAP DAST Summary ===
Target        : $TARGET_URL
Threshold     : $FAIL_ON
Total alerts  : $TOTAL_COUNT
High          : $HIGH_COUNT
Medium        : $MEDIUM_COUNT
Low           : $LOW_COUNT
Informational : $INFO_COUNT
HTML report   : $OUTDIR/zap-report.html
JSON alerts   : $OUTDIR/zap-alerts.json
EOF

cat "$OUTDIR/zap-summary.txt"

if threshold_failed; then
  echo "[!] Findings at or above $FAIL_ON threshold detected"
  exit 2
fi

echo "[+] No findings at or above $FAIL_ON threshold"
