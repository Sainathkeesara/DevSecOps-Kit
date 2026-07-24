#!/usr/bin/env bash

# last_verified: 2026-07-23 - bash n/a

# I wrote this script to practice the shell fundamentals I need for daily
# DevSecOps work: variables, conditionals, loops, functions, and cleanup.
# It runs against /tmp so nothing outside the script can be damaged.

LOG_FILE="/tmp/practice-shell-$$.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cleanup() {
  log "Removing temp files created during practice..."
  rm -f /tmp/practice-shell-$$.tmp
  rm -f "$LOG_FILE"
}

check_even_or_odd() {
  local num=$1
  if (( num % 2 == 0 )); then
    echo "$num is even"
  else
    echo "$num is odd"
  fi
}

main() {
  trap cleanup EXIT

  log "Starting Linux & Shell Fundamentals practice run"

  # Variables: referencing other variables with ${} is the safer pattern
  USER_NAME="learner"
  PROJECT_DIR="/tmp/practice-shell-$$"
  mkdir -p "$PROJECT_DIR"
  log "Working directory: $PROJECT_DIR for user $USER_NAME"

  # Conditional: test that /tmp exists before writing into it
  if [ -d "/tmp" ]; then
    log "/tmp is available — proceeding"
  else
    log "/tmp missing — cannot continue"
    exit 1
  fi

  # Loop: iterate over a small range and call a function
  for i in 1 2 3 4 5; do
    log "$(check_even_or_odd $i)"
  done

  # Array: collect the values I care about and iterate
  COLORS=("red" "green" "blue")
  for color in "${COLORS[@]}"; do
    log "processing color: $color"
  done

  # Argument parsing: read a positional arg if one was provided
  if [ $# -gt 0 ]; then
    log "Received argument: $1"
    echo "$1" > "$PROJECT_DIR/input.txt"
  else
    echo "no-arg" > "$PROJECT_DIR/input.txt"
  fi

  log "Practice run finished — temp files available at $PROJECT_DIR"
}

main "$@"
