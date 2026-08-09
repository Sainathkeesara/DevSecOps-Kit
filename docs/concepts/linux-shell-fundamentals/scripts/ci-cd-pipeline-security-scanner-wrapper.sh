#!/usr/bin/env bash

# last_verified: 2026-08-09 · bash n/a

# This script wraps multiple security scanner stages into a single CI/CD
# pipeline entry point.  It demonstrates Linux shell fundamentals —
# functions, arrays, traps, argument parsing, and conditional logic —
# combined with CI/CD concepts such as stage ordering, artifact
# collection, and exit-code propagation.

set -o pipefail

ARTIFACT_DIR="./scanner-artifacts"
REPORT_FILE="$ARTIFACT_DIR/pipeline-summary.txt"
FAILED_STAGES=()
declare -A STAGE_STATUS

cleanup() {
  echo "[cleanup] Removing temporary artifact directory"
  rm -rf "$ARTIFACT_DIR"
}

log() {
  local level="$1"
  local msg="$2"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg"
}

run_stage() {
  local stage_name="$1"
  local scanner_cmd="$2"
  local target="$3"

  log "INFO" "Starting stage: $stage_name"

  if [ ! -d "$target" ]; then
    log "ERROR" "Target directory $target does not exist"
    STAGE_STATUS["$stage_name"]="FAIL"
    FAILED_STAGES+=("$stage_name")
    return 1
  fi

  local output_file="$ARTIFACT_DIR/${stage_name}-results.txt"
  mkdir -p "$ARTIFACT_DIR"

  if eval "$scanner_cmd" \"$target\" > "$output_file" 2>&1; then
    STAGE_STATUS["$stage_name"]="PASS"
    log "INFO" "Stage $stage_name completed successfully"
    return 0
  else
    STAGE_STATUS["$stage_name"]="FAIL"
    FAILED_STAGES+=("$stage_name")
    log "ERROR" "Stage $stage_name failed — see $output_file"
    return 1
  fi
}

generate_report() {
  mkdir -p "$ARTIFACT_DIR"
  {
    echo "=== Security Scanner Pipeline Summary ==="
    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    for stage in "${!STAGE_STATUS[@]}"; do
      echo "$stage: ${STAGE_STATUS[$stage]}"
    done
    echo ""
    if [ ${#FAILED_STAGES[@]} -eq 0 ]; then
      echo "Result: ALL STAGES PASSED"
    else
      echo "Result: FAILED STAGES — ${FAILED_STAGES[*]}"
    fi
  } > "$REPORT_FILE"

  log "INFO" "Report written to $REPORT_FILE"
}

main() {
  trap cleanup EXIT

  if [ $# -lt 2 ]; then
    echo "Usage: $0 <target-directory> <scanner-command> [additional-commands...]" >&2
    exit 2
  fi

  local target_dir="$1"
  shift
  local scanner_commands=("$@")

  if [ ${#scanner_commands[@]} -eq 0 ]; then
    echo "Error: at least one scanner command is required" >&2
    exit 2
  fi

  log "INFO" "Pipeline target: $target_dir"
  log "INFO" "Scanner count: ${#scanner_commands[@]}"

  for i in "${!scanner_commands[@]}"; do
    run_stage "scanner-$((i+1))" "${scanner_commands[$i]}" "$target_dir" || true
  done

  generate_report

  if [ ${#FAILED_STAGES[@]} -gt 0 ]; then
    log "ERROR" "Pipeline finished with failures"
    exit 1
  else
    log "INFO" "Pipeline finished successfully"
    exit 0
  fi
}

main "$@"
