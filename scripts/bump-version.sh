#!/usr/bin/env bash
# last_verified: 2026-07-16 · git

# bump-version.sh — bump the current git tag by one patch version
# I tested this on a repo with tags like v1.2.3
# Usage: ./scripts/bump-version.sh [patch|minor|major]

TYPE="${1:-patch}"
CURRENT=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$TYPE" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac

echo "v${MAJOR}.${MINOR}.${PATCH}"
