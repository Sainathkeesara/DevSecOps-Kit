#!/bin/bash
# last_verified: 2026-07-16 · OWASP ZAP · Docker

TARGET="${1:-https://example.com}"
REPORT_DIR="${2:-./zap-reports}"

mkdir -p "$REPORT_DIR"

docker run --rm -v "$REPORT_DIR":/zap/wrk \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t "$TARGET" -J report.json

echo "Scan complete. JSON report at $REPORT_DIR/report.json"
