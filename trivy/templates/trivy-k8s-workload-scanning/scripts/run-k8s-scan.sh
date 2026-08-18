#!/usr/bin/env bash
# last_verified: 2026-08-18 · Trivy n/a
# Run a Trivy Kubernetes workload scan against a live cluster
# and write SARIF output to the target directory.
set -euo pipefail

OUTPUT_DIR="${1:-./trivy-k8s-results}"
SEVERITY="${TRIVY_SEVERITY:-HIGH,CRITICAL}"

mkdir -p "$OUTPUT_DIR"

echo "Scanning Kubernetes workloads..."
trivy k8s cluster \
  --severity "$SEVERITY" \
  --ignore-unfixed \
  --format sarif \
  --output "$OUTPUT_DIR/workload-scan.sarif"

echo "Results written to $OUTPUT_DIR/workload-scan.sarif"
