#!/usr/bin/env bash
# last_verified: 2026-10-28 · opentofu n/a
#
# Publish a local OpenTofu module to a module registry.
# This is one way to do it; the docs also suggest publishing via
# the registry's web UI for small teams.

set -uo pipefail

REGISTRY_URL="${REGISTRY_URL:-}"
MODULE_DIR="${MODULE_DIR:-.}"
MODULE_NAME="${MODULE_NAME:-}"
MODULE_VERSION="${MODULE_VERSION:-}"

usage() {
  cat <<EOF
Usage: REGISTRY_URL=... MODULE_NAME=... MODULE_VERSION=... $0 [MODULE_DIR]
EOF
}

if [ -z "$REGISTRY_URL" ] || [ -z "$MODULE_NAME" ] || [ -z "$MODULE_VERSION" ]; then
  usage
  exit 2
fi

[ -d "$MODULE_DIR" ] || { echo "module dir not found: $MODULE_DIR"; exit 1; }

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

archive="$tmpdir/${MODULE_NAME}-${MODULE_VERSION}.tar.gz"
tar -czf "$archive" -C "$MODULE_DIR" . || { echo "archive failed"; exit 1; }

echo "publishing $MODULE_NAME $MODULE_VERSION to $REGISTRY_URL"
if ! curl -sS -X POST "$REGISTRY_URL/modules" \
     -H "Content-Type: application/gzip" \
     --data-binary "@$archive"; then
  echo "publish request failed"
  exit 1
fi

echo
echo "done"
EOF