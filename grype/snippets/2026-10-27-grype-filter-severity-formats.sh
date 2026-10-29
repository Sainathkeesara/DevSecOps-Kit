#!/usr/bin/env bash
# last_verified: 2026-10-29 · grype n/a
#
# Grype vulnerability scan: filter by severity and output formats
# I ran this to explore how grype surfaces findings and how to
# narrow or reformat the results for my workflow.

set -o pipefail

TARGET="${1:-./dist}"

echo "🔍 Scanning $TARGET with grype..."
grype "$TARGET"

echo ""
echo "--- Filter by severity (high+) ---"
grype "$TARGET" --severity ">=high"

echo ""
echo "--- Output as SBOM (CycloneDX) ---"
grype "$TARGET" -o cyclonedx | head -30

echo ""
echo "--- Output as JSON ---"
grype "$TARGET" -o json | head -20