#!/usr/bin/env bash
# Multi-target Trivy scanner for monorepos.
# Reads targets from trivy.yaml and runs each scan type.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${REPO_DIR}/trivy.yaml"
OUTPUT_DIR="${REPO_DIR}/trivy-results"

mkdir -p "$OUTPUT_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

echo "=== Trivy Monorepo Scan ==="
echo "Config: $CONFIG_FILE"
echo "Output: $OUTPUT_DIR"
echo ""

# Scan container images
echo "--- Scanning container images ---"
trivy image --config "$CONFIG_FILE" \
    --format sarif \
    --output "$OUTPUT_DIR/images.sarif" 2>&1 | tee "$OUTPUT_DIR/images.log"
IMAGE_EXIT=$?

# Scan filesystem paths
echo "--- Scanning filesystem paths ---"
trivy filesystem --config "$CONFIG_FILE" \
    --format sarif \
    --output "$OUTPUT_DIR/filesystem.sarif" 2>&1 | tee "$OUTPUT_DIR/filesystem.log"
FS_EXIT=$?

# Scan Git repository history
echo "--- Scanning Git repositories ---"
trivy repository --config "$CONFIG_FILE" \
    --format sarif \
    --output "$OUTPUT_DIR/git.sarif" 2>&1 | tee "$OUTPUT_DIR/git.log"
GIT_EXIT=$?

echo ""
echo "=== Scan Results ==="
echo "  Images report:      $OUTPUT_DIR/images.sarif"
echo "  Filesystem report:  $OUTPUT_DIR/filesystem.sarif"
echo "  Git report:         $OUTPUT_DIR/git.sarif"

if [ $IMAGE_EXIT -ne 0 ] || [ $FS_EXIT -ne 0 ] || [ $GIT_EXIT -ne 0 ]; then
    echo "One or more scans reported issues."
    echo "  Image exit: $IMAGE_EXIT | Filesystem exit: $FS_EXIT | Git exit: $GIT_EXIT"
    exit 1
fi

echo "All scans completed."
