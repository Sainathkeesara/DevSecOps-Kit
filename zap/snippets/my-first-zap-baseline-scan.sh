#!/bin/bash
# My first ZAP CLI baseline scan
# Uses the official ZAP Docker image for a headless scan

TARGET="${1:-https://example.com}"
OUTPUT_DIR="${2:-./zap-reports}"

mkdir -p "$OUTPUT_DIR"

docker run --rm -v "$OUTPUT_DIR":/zap/wrk \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t "$TARGET" -r report.html

echo "Scan complete. Report at $OUTPUT_DIR/report.html"
