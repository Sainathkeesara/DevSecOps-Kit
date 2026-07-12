#!/usr/bin/env bash
# last_verified: 2026-07-12 · Git 2.54.0

# Increments the last git tag version — run `./bump-version.sh patch` to bump
LAST=$(git tag --sort=-v:refname 2>/dev/null | head -1)
MAJOR=$(echo "${LAST:-0.0.0}" | cut -d. -f1)
MINOR=$(echo "${LAST:-0.0.0}" | cut -d. -f2)
PATCH=$(echo "${LAST:-0.0.0}" | cut -d. -f3)
case "${1:-patch}" in
  major) echo "$((MAJOR+1)).0.0" ;;
  minor) echo "$MAJOR.$((MINOR+1)).0" ;;
  *)     echo "$MAJOR.$MINOR.$((PATCH+1))" ;;
esac
