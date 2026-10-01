#!/usr/bin/env bash
# last_verified: 2026-10-01 · assets n/a
# What I learned auditing asset references across the docs

ASSETS_DIR="/work/DevSecOps-Kit/assets"
DOCS_ROOT="/work/DevSecOps-Kit"

echo "[*] Auditing asset references in $DOCS_ROOT..."
echo "    Assets directory: $ASSETS_DIR"
echo

# List all assets
echo "[*] Assets on disk:"
find "$ASSETS_DIR" -type f -name "*.png" -o -name "*.jpg" -o -name "*.svg" | while read -r asset; do
    basename "$asset"
done
echo

# Search for markdown image links pointing to assets
echo "[*] Markdown image links referencing assets/"
grep -r '\.\./assets/' "$DOCS_ROOT" --include="*.md" | grep -E '!\[.*\]\(.*assets/' || echo "    (none found)"
echo

# Search for any reference to asset filenames
for asset in architecture-overview.png cicd-workflow.png devsecops-pipeline.png; do
    echo "[*] Searching for: $asset"
    grep -r "$asset" "$DOCS_ROOT" --include="*.md" | head -5 || echo "    (no references found)"
    echo
done

# Check README specifically
echo "[*] README.md asset mentions:"
grep -i assets /work/DevSecOps-Kit/README.md || echo "    (none found)"
echo

echo "[*] Audit complete — see output above for orphaned assets"