#!/bin/sh
# last_verified: 2026-09-18 · codeql n/a
# Build a database for the sample source and run the pack suite against it.
# Usage: ./test-pack.sh [source-root] [output-dir]
SRC_ROOT="${1:-./fixtures/basic}"
OUT_DIR="${2:-./pack-results}"
DB_DIR="${OUT_DIR}/empty-db"

mkdir -p "${OUT_DIR}"

if ! command -v codeql >/dev/null 2>&1; then
  echo "codeql CLI not found; install it and re-run" >&2
  exit 2
fi

if [ ! -d "${SRC_ROOT}" ]; then
  echo "source root not found: ${SRC_ROOT}" >&2
  exit 2
fi

PACK_ROOT="$(dirname "$(dirname "$0")")"

codeql database create "${DB_DIR}" \
  --language=python \
  --source-root="${SRC_ROOT}"

codeql database analyze "${DB_DIR}" \
  "${PACK_ROOT}/suites/custom-suite.qls" \
  --format=sarifv2 \
  --output="${OUT_DIR}/custom-results.sarif"

echo "results written to ${OUT_DIR}/custom-results.sarif"
