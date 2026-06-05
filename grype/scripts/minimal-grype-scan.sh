#!/usr/bin/env bash
# Minimal Grype scan: vulnerability analysis of a local container image
# Level L2 — still learning, so I'm keeping this small and focused
# Usage: ./minimal-grype-scan.sh <image-name> [output-dir]

IMAGE="${1:?Usage: $0 <image-name> [output-dir]}"
OUTDIR="${2:-./grype-reports}"

mkdir -p "$OUTDIR"

echo "[+] Scanning $IMAGE with Grype..."
# Using table format first because it's easy to read when I'm learning what the output looks like
grype "$IMAGE" \
  --only-fixed \
  --fail-on high \
  --output table \
  --file "$OUTDIR/${IMAGE//[\/:]/_}-table.txt"

# Also save JSON so I can parse it later for custom filtering or CI gating
# I tried piping to jq filters here because the docs show table by default but I needed machine-readable output
grype "$IMAGE" \
  --only-fixed \
  --output json \
  --file "$OUTDIR/${IMAGE//[\/:]/_}-vulns.json"

echo "[+] Reports saved to $OUTDIR/"
echo "[+] Check the JSON file if you want to filter by severity or package name with jq"
