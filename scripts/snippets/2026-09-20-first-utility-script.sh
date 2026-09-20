#!/usr/bin/env bash
# last_verified: 2026-09-20 · scripts n/a
# My first utility script for the kit: prints a formatted header and lists
# available toolkit directories under scripts/bash/. I wrote this to learn
# the scripts directory layout before adding more helpers.

echo "=== DevSecOps-Kit Script Helpers ==="
echo "Available toolkits:"
find scripts/bash/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sed 's/^/  - /'
echo "Root scripts: $(find scripts/ -maxdepth 1 -name '*.sh' -exec basename {} \;)"
echo "Done."
