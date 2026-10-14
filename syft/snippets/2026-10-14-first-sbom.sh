#!/usr/bin/env bash
# last_verified: 2026-10-14 · syft n/a
# My first SBOM with syft — scan a local dir, print a table.
# Usage: ./2026-10-14-first-sbom.sh [PATH]

TARGET="${1:-.}"

syft "$TARGET" -o syft-table
# TODO: try -o spdx-json next, not sure how big the file gets yet
