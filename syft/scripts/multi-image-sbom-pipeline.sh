#!/usr/bin/env bash
# Multi-image SBOM generation pipeline
#
# Purpose: Generate SPDX + CycloneDX SBOMs for multiple container images
# in a single run. Accepts image references from CLI args or a file.
#
# Usage:
#   ./multi-image-sbom-pipeline.sh alpine:latest nginx:1.25 python:3.12-slim
#   ./multi-image-sbom-pipeline.sh --from-file images.txt

OUT_DIR="${OUT_DIR:-./sbom-output}"
mkdir -p "$OUT_DIR"

images=()

if [[ "$1" == "--from-file" && -n "$2" ]]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        images+=("$line")
    done < "$2"
else
    images=("$@")
fi

if [[ ${#images[@]} -eq 0 ]]; then
    echo "No images specified. Provide image references as arguments or use --from-file <file>."
    exit 1
fi

for img in "${images[@]}"; do
    safe_name=$(echo "$img" | tr '/:' '_')
    echo "==> Generating SBOMs for $img"

    if ! syft "$img" -o cyclonedx-json > "$OUT_DIR/${safe_name}_cyclonedx.json" 2>/dev/null; then
        echo "  [!] CycloneDX failed for $img — skipping SPDX as well"
        continue
    fi

    if ! syft "$img" -o spdx-json > "$OUT_DIR/${safe_name}_spdx.json" 2>/dev/null; then
        echo "  [!] SPDX failed for $img — CycloneDX was written though"
    fi

    echo "  Done: $safe_name"
done

echo ""
echo "=== Summary ==="
echo "Output directory: $OUT_DIR"
ls -lh "$OUT_DIR"/*.json 2>/dev/null || echo "(no SBOMs generated)"
echo ""
echo "To verify a generated SBOM: syft packages sbom:<path-to-json>"
