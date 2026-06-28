#!/usr/bin/env bash
# Purpose: Run a ZAP DAST scan using the Automation Framework via Docker.
# Usage:   ./run-zap-dast.sh <target_url> [output_dir] [plan_file]
# Example: ./run-zap-dast.sh https://staging.example.com reports plans/quick-scan.yaml

set -euo pipefail

TARGET_URL="${1:?Usage: $0 <target_url> [output_dir] [plan_file]}"
OUTDIR="${2:-./reports}"
PLAN_FILE="${3:-./plans/quick-scan.yaml}"
CONTAINER_NAME="zap-dast-worker"
ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"

mkdir -p "$OUTDIR"

cleanup() {
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

PLAN_CONTENT=$(sed "s|{{TARGET_URL}}|$TARGET_URL|g; s|{{REPORT_DIR}}|/zap/reports|g" "$PLAN_FILE")

# Inject the plan as a temp file so the container can read it
echo "$PLAN_CONTENT" > /tmp/zap-plan.yaml

docker run --rm --name "$CONTAINER_NAME" \
  -v /tmp/zap-plan.yaml:/zap/plan.yaml:ro \
  -v "$(pwd)/$OUTDIR":/zap/reports \
  "$ZAP_IMAGE" \
  zap.sh -cmd -autorun /zap/plan.yaml
