#!/usr/bin/env bash
# Purpose: Compare vulnerability sets across two container image versions using Grype
# Usage: ./vuln-diff-two-images.sh <image:v1> <image:v2> [--outdir <path>]
# Shows new vulnerabilities (v2 only), fixed vulnerabilities (v1 only), and common ones.

set -euo pipefail

IMAGE1="${1:?Usage: $0 <image:v1> <image:v2> [--outdir <path>]}"
IMAGE2="${2:?Usage: $0 <image:v1> <image:v2> [--outdir <path>]}"
OUTDIR="${3:-./grype-vuln-diff}"

mkdir -p "$OUTDIR"

echo "[*] Scanning $IMAGE1 ..."
grype "$IMAGE1" --output json > "$OUTDIR/image1.json"

echo "[*] Scanning $IMAGE2 ..."
grype "$IMAGE2" --output json > "$OUTDIR/image2.json"

# Build sorted lists of vulnerability IDs from each image
jq -r '.Matches[]? | "\(.Vulnerability.ID):\(.Package.Name)"' "$OUTDIR/image1.json" | sort > "$OUTDIR/vulns-v1.txt"
jq -r '.Matches[]? | "\(.Vulnerability.ID):\(.Package.Name)"' "$OUTDIR/image2.json" | sort > "$OUTDIR/vulns-v2.txt"

# Diff: lines in v1 not in v2 = fixed; lines in v2 not in v1 = new; common lines
comm -23 "$OUTDIR/vulns-v1.txt" "$OUTDIR/vulns-v2.txt" > "$OUTDIR/fixed.txt" || true
comm -13 "$OUTDIR/vulns-v1.txt" "$OUTDIR/vulns-v2.txt" > "$OUTDIR/new.txt" || true
comm -12 "$OUTDIR/vulns-v1.txt" "$OUTDIR/vulns-v2.txt" > "$OUTDIR/common.txt" || true

FIXED_COUNT=$(wc -l < "$OUTDIR/fixed.txt")
NEW_COUNT=$(wc -l < "$OUTDIR/new.txt")
COMMON_COUNT=$(wc -l < "$OUTDIR/common.txt")

echo ""
echo "=== Vulnerability Diff Summary ==="
echo "  Image 1: $IMAGE1"
echo "  Image 2: $IMAGE2"
echo "  Fixed vulns (in v1 only):  $FIXED_COUNT"
echo "  New vulns (in v2 only):    $NEW_COUNT"
echo "  Still present (both):      $COMMON_COUNT"
echo ""

# Show severity breakdown for new vulnerabilities
if [ "$NEW_COUNT" -gt 0 ]; then
  echo "=== New Vulnerabilities by Severity ==="
  while IFS=: read -r VULN_ID PKG; do
    SEVERITY=$(jq -r --arg id "$VULN_ID" --arg pkg "$PKG" \
      '.Matches[]? | select(.Vulnerability.ID == $id and .Package.Name == $pkg) | .Vulnerability.Severity' \
      "$OUTDIR/image2.json" | head -1)
    echo "  [$SEVERITY] $VULN_ID  $PKG"
  done < "$OUTDIR/new.txt" | sort
  echo ""
fi

echo "[*] Detailed reports saved to $OUTDIR/"
echo "    new.txt     — vulnerabilities in $IMAGE2 only"
echo "    fixed.txt   — vulnerabilities in $IMAGE1 only"
echo "    common.txt  — vulnerabilities present in both"
