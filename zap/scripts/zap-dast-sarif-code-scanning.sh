#!/usr/bin/env bash
# Purpose: Run a ZAP DAST scan, convert results to SARIF, and upload to
#          GitHub Code Scanning. Designed for CI pipeline use.
# Usage: ./zap-dast-sarif-code-scanning.sh <target_url> [output_dir]

set -euo pipefail

TARGET_URL="${1:?Usage: $0 <target_url> [output_dir]}"
OUTDIR="${2:-./zap-sarif-results}"
ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"
ZAP_PORT="${ZAP_PORT:-8090}"
CONTAINER_NAME="${ZAP_CONTAINER_NAME:-zap-sarif-worker}"
POLL_SECONDS="${POLL_SECONDS:-5}"
FAIL_ON="${FAIL_ON:-high}"
API_KEY="${ZAP_API_KEY:-$(openssl rand -hex 16 2>/dev/null || date +%s)}"

REQUIRED_CMDS=("docker" "curl" "jq")
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[!] $cmd is required but not found in PATH"
    exit 1
  fi
done

mkdir -p "$OUTDIR"

cleanup() {
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

zap_get() {
  local endpoint="$1"
  shift
  local args=()
  for pair in "$@"; do
    args+=(--data-urlencode "${pair%%=*}=${pair#*=}")
  done
  args+=(--data-urlencode "apikey=$API_KEY")
  curl -fsS --get "http://127.0.0.1:${ZAP_PORT}/JSON/${endpoint}/" "${args[@]}"
}

wait_for_zap() {
  local attempt=0
  while [ "$attempt" -lt 30 ]; do
    if zap_get core/view/version >/dev/null 2>&1; then
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 2
  done
  echo "[!] ZAP API did not become ready"
  docker logs "$CONTAINER_NAME" 2>&1 || true
  exit 1
}

poll_scan() {
  local label="$1" endpoint="$2" scan_id="$3" status
  while true; do
    status=$(zap_get "${endpoint}/status" "scanId=$scan_id" | jq -r '.status // empty')
    if [ -z "$status" ] || ! [[ "$status" =~ ^[0-9]+$ ]]; then
      echo "[!] Unexpected ${label} status: ${status}"
      exit 1
    fi
    echo "[*] ${label}: ${status}%"
    [ "$status" = "100" ] && return 0
    sleep "$POLL_SECONDS"
  done
}

# Convert ZAP alerts JSON to SARIF 2.1.0 format
alerts_to_sarif() {
  local input_file="$1" output_file="$2"
  jq -r '
    .alerts // [] | if length == 0 then
      { "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
        "version": "2.1.0",
        "runs": [ { "tool": { "driver": { "name": "OWASP ZAP", "version": "DAST" } },
                    "results": [] } ] }
    else
      { "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
        "version": "2.1.0",
        "runs": [ { "tool": { "driver": { "name": "OWASP ZAP", "version": "DAST" } },
                    "results": [ .[] | { "ruleId": .alertRef // .id // .name,
                                         "level": (if .risk == "High" then "error"
                                                   elif .risk == "Medium" then "warning"
                                                   else "note" end),
                                         "message": { "text": (.name + ": " + (.description // "") ) },
                                         "locations": [ { "physicalLocation": {
                                           "artifactLocation": { "uri": .url // "unknown" } } } ] } ] } ] }
    end
  ' "$input_file" > "$output_file"
  echo "[*] SARIF report written to $output_file"
}

echo "=== ZAP DAST → SARIF → Code Scanning ==="
echo "Target  : $TARGET_URL"
echo "Output  : $OUTDIR"
echo ""

echo "[*] Starting ZAP daemon..."
docker run -d --name "$CONTAINER_NAME" \
  -p "${ZAP_PORT}:8090" \
  "$ZAP_IMAGE" \
  zap.sh -daemon -host 0.0.0.0 -port 8090 \
  -config "api.key=$API_KEY" \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true >/dev/null

wait_for_zap

echo "[*] Spider scan..."
SPIDER_ID=$(zap_get spider/action/scan "url=$TARGET_URL" "recurse=true" | jq -r '.scan // empty')
[ -z "$SPIDER_ID" ] && { echo "[!] Failed to start spider scan"; exit 1; }
poll_scan "spider" "spider/view" "$SPIDER_ID"

echo "[*] Active scan..."
SCAN_ID=$(zap_get ascan/action/scan "url=$TARGET_URL" "recurse=true" | jq -r '.scan // empty')
[ -z "$SCAN_ID" ] && { echo "[!] Failed to start active scan"; exit 1; }
poll_scan "active scan" "ascan/view" "$SCAN_ID"

echo "[*] Fetching alerts..."
zap_get core/view/alerts "baseurl=$TARGET_URL" > "$OUTDIR/zap-alerts.json"

echo "[*] Converting to SARIF..."
alerts_to_sarif "$OUTDIR/zap-alerts.json" "$OUTDIR/zap-results.sarif"

# Summary
HIGH=$(jq '[.alerts[]? | select(.risk == "High")] | length' "$OUTDIR/zap-alerts.json")
MEDIUM=$(jq '[.alerts[]? | select(.risk == "Medium")] | length' "$OUTDIR/zap-alerts.json")
LOW=$(jq '[.alerts[]? | select(.risk == "Low")] | length' "$OUTDIR/zap-alerts.json")
INFO=$(jq '[.alerts[]? | select(.risk == "Informational")] | length' "$OUTDIR/zap-alerts.json")

cat > "$OUTDIR/summary.txt" <<EOF
=== ZAP DAST SARIF Summary ===
Target  : $TARGET_URL
High    : $HIGH
Medium  : $MEDIUM
Low     : $LOW
Info    : $INFO
SARIF   : $OUTDIR/zap-results.sarif
EOF

cat "$OUTDIR/summary.txt"

# Upload to GitHub Code Scanning if GITHUB_TOKEN is set
if [ -n "${GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  echo "[*] Uploading SARIF to GitHub Code Scanning..."
  gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/${GITHUB_REPOSITORY}/code-scanning/sarifs" \
    -f "commit_sha=${GITHUB_SHA}" \
    -f "ref=${GITHUB_REF}" \
    -f "sarif=$(base64 -w0 < "$OUTDIR/zap-results.sarif")" \
    --silent && echo "[+] SARIF uploaded successfully" || echo "[!] SARIF upload failed"
else
  echo "[*] Skipping Code Scanning upload (GITHUB_TOKEN/gh not configured)"
  echo "    Upload the SARIF manually or via github/codeql-action/upload-sarif"
fi

# Evaluate threshold
case "${FAIL_ON,,}" in
  high|critical)   [ "$HIGH" -gt 0 ] && exit 2 ;;
  medium)          [ "$((MEDIUM + HIGH))" -gt 0 ] && exit 2 ;;
  low)             [ "$((LOW + MEDIUM + HIGH))" -gt 0 ] && exit 2 ;;
  never|none)      ;;
  *)               echo "[!] Unknown FAIL_ON value: $FAIL_ON"; exit 1 ;;
esac

echo "[+] Scan passed threshold (FAIL_ON=$FAIL_ON)"
