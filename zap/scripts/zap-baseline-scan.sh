#!/usr/bin/env bash
# last_verified: 2026-09-26 · zap n/a
# Purpose: Run a small ZAP baseline scan against a target and fail on High findings.
# Usage: ./zap-baseline-scan.sh <target_url>
# Verify: re-run against the same target; zap-reports/zap-baseline-summary.txt lists alert counts.

set -euo pipefail

TARGET_URL="${1:?Usage: $0 <target_url>}"
OUTDIR="${OUTDIR:-./zap-reports}"
CONTAINER_NAME="${ZAP_CONTAINER_NAME:-zap-baseline-worker}"
ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"
FAIL_ON="${FAIL_ON:-High}"

mkdir -p "$OUTDIR"

cleanup() {
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "[*] Starting ZAP baseline scan against $TARGET_URL"
docker run --name "$CONTAINER_NAME" --rm \
  -v "$OUTDIR:/zap/wrk:rw" \
  "$ZAP_IMAGE" zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-baseline-report.html > "$OUTDIR/zap-baseline.log" 2>&1 || true

python3 - "$OUTDIR/zap-baseline.log" "$OUTDIR/zap-baseline-summary.txt" <<'EOF'
import re
import sys

log_path, summary_path = sys.argv[1], sys.argv[2]
text = open(log_path, errors="replace").read()
counts = {"High": 0, "Medium": 0, "Low": 0, "Informational": 0}
for m in re.finditer(r"^(High|Medium|Low|Informational)\s+\((\d+)", text, re.M):
    counts[m.group(1)] += int(m.group(2))
total = sum(counts.values())
with open(summary_path, "w") as fh:
    fh.write("ZAP baseline summary\n")
    for level in ("High", "Medium", "Low", "Informational"):
        fh.write(f"{level}: {counts[level]}\n")
    fh.write(f"Total: {total}\n")
print(open(summary_path).read())
EOF

HIGH_COUNT=$(grep -E "^High:" "$OUTDIR/zap-baseline-summary.txt" | awk '{print $2}')
if [ "$FAIL_ON" = "High" ] && [ "${HIGH_COUNT:-0}" -gt 0 ]; then
  echo "[!] High findings detected ($HIGH_COUNT) — see $OUTDIR/zap-baseline-report.html"
  exit 2
fi
echo "[+] Baseline scan done — no High findings"
