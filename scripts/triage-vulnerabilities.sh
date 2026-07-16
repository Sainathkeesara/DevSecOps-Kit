#!/usr/bin/env bash
# last_verified: 2026-07-16 · trivy

# triage-vulnerabilities.sh — progressive Trivy vulnerability triage
# I'm running scans at increasing severity levels so I don't get flooded
# Usage: ./scripts/triage-vulnerabilities.sh <image-name>

IMAGE="${1:-}"
if [[ -z "$IMAGE" ]]; then
  echo "Usage: $0 <image-name>"
  exit 1
fi

echo "[*] Phase 1: CRITICAL only"
trivy image --severity CRITICAL --exit-code 1 "$IMAGE" || echo "[!] CRITICAL vulns found"

echo "[*] Phase 2: HIGH + CRITICAL"
trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMAGE" || echo "[!] HIGH vulns found"

echo "[*] Phase 3: report only"
trivy image --severity MEDIUM,HIGH,CRITICAL --exit-code 0 "$IMAGE" || true
