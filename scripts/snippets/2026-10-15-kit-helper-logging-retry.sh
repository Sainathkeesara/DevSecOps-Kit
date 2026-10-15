#!/usr/bin/env bash
# last_verified: 2026-10-15 · scripts n/a
# Minimal kit helper script with logging and retry (scripts-007).
# I kept writing the same two helpers by hand in every throwaway script —
# a timestamped log line and a "try N times with a sleep" loop — so I
# pulled both into one file I can source. Sourcing keeps it simple: the
# caller gets log() and retry() as functions instead of a second process.
# The demo at the bottom exercises both with a command that always
# succeeds, because I wanted to see the happy path before trusting this
# around a flaky one.

# log prints one timestamped line. I send it to stdout (not stderr) on
# purpose: my scripts pipe stdout into files and I want the log lines in
# the file too. One arg, no flags — the quickstart version I copied had
# log levels and I dropped them because I never used them.
log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

# retry runs a command up to N times with a fixed sleep between tries.
# Usage: retry <attempts> <delay_seconds> <command...>
# I pass attempts and delay as args instead of globals because my first
# version used globals and I kept forgetting to set them before calling.
retry() {
  attempts="$1"
  delay="$2"
  shift 2
  n=1
  while [ "$n" -le "$attempts" ]; do
    if "$@"; then
      return 0
    fi
    log "attempt $n/$attempts failed, sleeping ${delay}s"
    sleep "$delay"
    n=$((n + 1))
  done
  log "all $attempts attempts failed"
  return 1
}

# Demo: a command that succeeds on the second try. I use a counter file
# in /tmp so the flakiness survives across the retry loop iterations.
if [ "${1:-}" = "--demo" ]; then
  log "starting demo run"
  retry 3 1 bash -c 'echo hello from the demo'
  log "demo finished"
fi
