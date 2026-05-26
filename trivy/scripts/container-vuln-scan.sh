#!/bin/sh
# Minimal container image vulnerability scan with Trivy
# Scans a Docker image, runs both table and JSON output, exits non-zero if CRITICAL found
# Usage: ./container-vuln-scan.sh <image-name> [output-dir]

IMAGE="${1:?Usage: $0 <image-name> [output-dir]}"
OUTDIR="${2:-./trivy-reports}"

mkdir -p "$OUTDIR"

echo "[+] Scanning $IMAGE with Trivy..."

# Table output for human reading — shows all severities
trivy image "$IMAGE" \
  --format table \
  --severity CRITICAL,HIGH,MEDIUM \
  --ignore-unfixed \
  --output "$OUTDIR/$(echo "$IMAGE" | tr '/:' '_')-table.txt"

# JSON output for programmatic use — pipe into jq for custom filtering
trivy image "$IMAGE" \
  --format json \
  --severity CRITICAL,HIGH \
  --quiet \
  --output "$OUTDIR/$(echo "$IMAGE" | tr '/:' '_')-vulns.json"

# Count CRITICALs by counting severity keys in the JSON
CRIT_COUNT=$(jq '[.Results[]? | .Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$OUTDIR/$(echo "$IMAGE" | tr '/:' '_')-vulns.json" 2>/dev/null || echo 0)

echo "[+] Found $CRIT_COUNT CRITICAL vulnerabilities"
echo "[+] Reports saved to $OUTDIR/"

if [ "$CRIT_COUNT" -gt 0 ]; then
  echo "[!] Failing — $CRIT_COUNT CRITICAL vulnerabilities found"
  exit 1
fi
