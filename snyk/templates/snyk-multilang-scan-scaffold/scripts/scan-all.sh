#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-all.sh — run every language subscan in this scaffold and merge the results.
# Exits non-zero on the first subscan failure (severity threshold exceeded).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULT_DIR="${SCRIPT_DIR}/../snyk-results"
mkdir -p "${RESULT_DIR}"

FAIL=0
SUMMARY="${RESULT_DIR}/summary.log"
: > "${SUMMARY}"

for sub in "${SCRIPT_DIR}"/scan-*.sh; do
  lang="$(basename "${sub}" .sh | sed 's/^scan-//')"
  echo "==> ${lang}"
  if "${sub}" >> "${SUMMARY}" 2>&1; then
    echo "    OK"
  else
    echo "    FAIL"
    FAIL=1
  fi
done

if [ "${FAIL}" -ne 0 ]; then
  echo "One or more subscans failed. See ${SUMMARY} for details."
  exit 1
fi

echo "All subscans passed."