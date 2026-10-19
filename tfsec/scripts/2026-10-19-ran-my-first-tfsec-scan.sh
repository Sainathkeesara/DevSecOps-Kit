#!/usr/bin/env bash
# last_verified: 2026-10-19 · tfsec n/a

# What I learned running my first tfsec scan.
# I didn't have tfsec installed locally, so this just documents the steps I'd
# run once the binary is available. Keeping it as a script so future-me can
# re-run it.

set -o pipefail

echo "Checking for tfsec..."
if ! command -v tfsec >/dev/null 2>&1; then
  echo "tfsec not installed. Install from the official release, then re-run."
  exit 1
fi

echo "tfsec version:"
tfsec --version

echo "Scanning current directory..."
tfsec . --minimum-severity MEDIUM
