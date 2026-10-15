#!/usr/bin/env bash
# last_verified: 2026-10-15 · nuclei n/a
# What I learned running my first nuclei scan (nuclei-008).
# I followed the quickstart shape: pick a target I own, run the default
# template set against it, and save the output to a file so I can re-read
# it afterwards. The examples I found all pointed at a live host, so I
# swapped in a local practice target instead — scanning anything I do not
# own felt wrong, and localhost keeps the blast radius at zero.
# Got stuck on: there is no nuclei binary in this container, so nothing
# below has actually run here yet. The echo lines record the exact command
# I will try first on a machine with nuclei installed.

TARGET="${1:-http://127.0.0.1:8080}"
OUT_DIR="${2:-./nuclei-out}"

# Doing the binary check first because the quickstart assumes nuclei is
# already on PATH, and mine is not — better to fail with a hint than with
# a bare "command not found".
if ! command -v nuclei >/dev/null 2>&1; then
  echo "nuclei is not on PATH. Install it first, then re-run this script."
  echo "Planned first scan: nuclei -u $TARGET -o $OUT_DIR/first-scan.txt"
  exit 0
fi

# Keeping one output file per run so I can diff runs later without
# re-scanning. -u takes a single target; a list of targets would use -l.
mkdir -p "$OUT_DIR"
echo "Scanning $TARGET ..."
nuclei -u "$TARGET" -o "$OUT_DIR/first-scan.txt"
echo "Done. Findings (if any) are in $OUT_DIR/first-scan.txt"
# What I would try next: re-run with -severity to focus on one band,
# then read one matched template to understand what it actually sent.
