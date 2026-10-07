#!/usr/bin/env bash
# last_verified: 2026-10-07 · checkov n/a
#
# Checkov health check and rollback procedure.
#
# Purpose:
#   One entry point for a Checkov scan gate: prove the scanner runs,
#   classify the latest scan result, and undo a bad scan-gate change
#   by restoring the previous Checkov configuration.
#
# Subcommands:
#   check     Run a Checkov scan and record the outcome. Classifies
#             healthy (scanner exited 0), critical (scanner exited
#             non-zero, meaning failed checks or a scan error), or
#             degraded (the scan passed but the result record could
#             not be persisted, so the audit trail is broken).
#   snapshot  Record the current state of the Checkov config file so
#             a later change can be rolled back. A snapshot stores
#             the file contents, its checksum, and whether the file
#             existed at all, so "remove a bad config" is roll-able
#             too.
#   list      List recorded snapshots with their presence state and
#             timestamp.
#   rollback  Restore the config file from a named snapshot after
#             verifying the snapshot's checksum.
#
# Usage:
#   ./checkov-health-check-and-rollback.sh check [--directory DIR] [--config FILE] [--dry-run]
#   ./checkov-health-check-and-rollback.sh snapshot [--file FILE] [--name NAME] [--dry-run]
#   ./checkov-health-check-and-rollback.sh list
#   ./checkov-health-check-and-rollback.sh rollback --snapshot NAME [--file FILE] [--dry-run] [--yes]
#
# Environment:
#   CHECKOV_HEALTH_STATE_DIR  where results and snapshots are kept
#                             (default: .checkov-health)
#   CHECKOV_ARGS              extra arguments passed through to checkov
#                             (stick to flags this kit already uses,
#                             e.g. --framework, --compact, --skip-check)
#
# Exit codes: 0 healthy, 1 degraded, 2 critical, 64 usage error,
#             70 rollback failed
#
# Verify: ./checkov-health-check-and-rollback.sh check --directory checkov

set -euo pipefail

readonly PROG="${0##*/}"
readonly STATE_DIR="${CHECKOV_HEALTH_STATE_DIR:-.checkov-health}"
readonly RESULTS_DIR="${STATE_DIR}/results"
readonly SNAPSHOTS_DIR="${STATE_DIR}/snapshots"

readonly SEV_OK=0
readonly SEV_DEGRADED=1
readonly SEV_CRITICAL=2
readonly EX_USAGE=64
readonly EX_ROLLBACK=70

subcommand=""
target_dir="."
config_file=""
snapshot_file=".checkov.yaml"
snapshot_name=""
dry_run=0
assume_yes=0

tmp_output=""

cleanup() {
  if [[ -n "$tmp_output" ]]; then
    rm -f "$tmp_output"
  fi
  return 0
}
trap cleanup EXIT

die() {
  local code=$1
  shift
  printf '%s: error: %s\n' "$PROG" "$*" >&2
  exit "$code"
}

usage() {
  cat <<'USAGE'
Usage:
  checkov-health-check-and-rollback.sh check [--directory DIR] [--config FILE] [--dry-run]
  checkov-health-check-and-rollback.sh snapshot [--file FILE] [--name NAME] [--dry-run]
  checkov-health-check-and-rollback.sh list
  checkov-health-check-and-rollback.sh rollback --snapshot NAME [--file FILE] [--dry-run] [--yes]

Exit: 0 healthy, 1 degraded, 2 critical, 64 usage error, 70 rollback failed
USAGE
}

require_checkov() {
  command -v checkov >/dev/null 2>&1 \
    || die "$EX_USAGE" "checkov not found in PATH — install checkov before running a health check"
  local version
  version="$(checkov --version 2>/dev/null | head -n 1 || true)"
  printf 'checkov: %s\n' "${version:-version unknown}"
}

file_checksum() {
  sha256sum "$1" | awk '{print $1}'
}

record_result() {
  local rc=$1
  local stamp record
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  mkdir -p "$RESULTS_DIR" || return 1
  record="${RESULTS_DIR}/${stamp}.txt"
  {
    printf 'timestamp: %s\n' "$stamp"
    printf 'target: %s\n' "$target_dir"
    printf 'config: %s\n' "${config_file:-auto-discovered}"
    if [[ -n "$config_file" ]]; then
      printf 'config_sha256: %s\n' "$(file_checksum "$config_file")"
    fi
    printf 'checkov: %s\n' "$(checkov --version 2>/dev/null | head -n 1 || true)"
    printf 'exit_code: %s\n' "$rc"
  } >"$record" || return 1
  printf 'result record: %s\n' "$record"
  return 0
}

cmd_check() {
  [[ -d "$target_dir" ]] \
    || die "$EX_USAGE" "target directory does not exist: $target_dir"
  if [[ -n "$config_file" ]]; then
    [[ -f "$config_file" ]] \
      || die "$EX_USAGE" "config file does not exist: $config_file"
  fi
  require_checkov

  local scan_cmd=(checkov --directory "$target_dir")
  if [[ -n "$config_file" ]]; then
    scan_cmd+=(--config "$config_file")
  fi
  if [[ -n "${CHECKOV_ARGS:-}" ]]; then
    # CHECKOV_ARGS is a deliberate pass-through; word splitting is intended.
    # shellcheck disable=SC2206
    scan_cmd+=(${CHECKOV_ARGS})
  fi

  if (( dry_run )); then
    printf '[dry-run] would run: %s\n' "${scan_cmd[*]}"
    printf '[dry-run] would record the result under %s\n' "$RESULTS_DIR"
    return 0
  fi

  tmp_output="$(mktemp "${TMPDIR:-/tmp}/checkov-health.XXXXXX")"
  local rc=0
  "${scan_cmd[@]}" >"$tmp_output" 2>&1 || rc=$?
  cat "$tmp_output"

  local severity=$SEV_OK
  if (( rc != 0 )); then
    severity=$SEV_CRITICAL
  fi

  if ! record_result "$rc"; then
    if (( severity == SEV_OK )); then
      severity=$SEV_DEGRADED
      printf '%s: warning: scan passed but the result record could not be written under %s\n' \
        "$PROG" "$STATE_DIR" >&2
    fi
  fi

  case $severity in
    "$SEV_OK")       printf 'RESULT: healthy\n' ;;
    "$SEV_DEGRADED") printf 'RESULT: degraded\n' ;;
    *)               printf 'RESULT: critical\n' ;;
  esac
  return "$severity"
}

cmd_snapshot() {
  if [[ -z "$snapshot_name" ]]; then
    snapshot_name="$(date -u +%Y%m%dT%H%M%SZ)"
  fi
  local snap_dir="${SNAPSHOTS_DIR}/${snapshot_name}"

  if (( dry_run )); then
    if [[ -f "$snapshot_file" ]]; then
      printf '[dry-run] would copy %s to %s/config\n' "$snapshot_file" "$snap_dir"
    else
      printf '[dry-run] would record %s as absent in %s\n' "$snapshot_file" "$snap_dir"
    fi
    return 0
  fi

  if [[ -d "$snap_dir" ]]; then
    die "$EX_USAGE" "snapshot already exists: $snapshot_name — pick another --name"
  fi
  mkdir -p "$snap_dir" || die "$EX_ROLLBACK" "cannot create snapshot directory: $snap_dir"

  if [[ -f "$snapshot_file" ]]; then
    cp "$snapshot_file" "${snap_dir}/config"
    file_checksum "$snapshot_file" >"${snap_dir}/config.sha256"
    printf 'present\n' >"${snap_dir}/presence"
  else
    printf 'absent\n' >"${snap_dir}/presence"
  fi
  {
    printf 'snapshot: %s\n' "$snapshot_name"
    printf 'file: %s\n' "$snapshot_file"
    printf 'timestamp: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } >"${snap_dir}/meta"
  printf 'snapshot %s recorded for %s\n' "$snapshot_name" "$snapshot_file"
}

cmd_list() {
  if [[ ! -d "$SNAPSHOTS_DIR" ]]; then
    printf 'no snapshots recorded yet (state dir: %s)\n' "$STATE_DIR"
    return 0
  fi
  local snap name presence stamp found=0
  for snap in "${SNAPSHOTS_DIR}"/*/; do
    [[ -d "$snap" ]] || continue
    found=1
    name="${snap%/}"
    name="${name##*/}"
    presence="$(cat "${snap}presence" 2>/dev/null || printf 'unknown')"
    stamp="$(sed -n 's/^timestamp: //p' "${snap}meta" 2>/dev/null | head -n 1)"
    printf '%s  %-7s  %s\n' "$name" "$presence" "${stamp:-unknown}"
  done
  if (( ! found )); then
    printf 'no snapshots recorded yet (state dir: %s)\n' "$STATE_DIR"
  fi
}

cmd_rollback() {
  [[ -n "$snapshot_name" ]] \
    || die "$EX_USAGE" "rollback needs --snapshot NAME (run the list subcommand to see recorded snapshots)"
  local snap_dir="${SNAPSHOTS_DIR}/${snapshot_name}"
  [[ -d "$snap_dir" ]] \
    || die "$EX_ROLLBACK" "snapshot not found: $snapshot_name"

  local presence
  presence="$(cat "${snap_dir}/presence" 2>/dev/null || printf 'unknown')"

  if [[ "$presence" == "present" ]]; then
    [[ -f "${snap_dir}/config" ]] \
      || die "$EX_ROLLBACK" "snapshot $snapshot_name is missing its config payload"
    local recorded current
    recorded="$(cat "${snap_dir}/config.sha256" 2>/dev/null || true)"
    current="$(file_checksum "${snap_dir}/config")"
    [[ "$recorded" == "$current" ]] \
      || die "$EX_ROLLBACK" "checksum mismatch on snapshot $snapshot_name — refusing to restore a corrupted snapshot"
  fi

  if (( dry_run )); then
    if [[ "$presence" == "present" ]]; then
      printf '[dry-run] would restore %s from snapshot %s\n' "$snapshot_file" "$snapshot_name"
    else
      printf '[dry-run] would remove %s (snapshot %s recorded it absent)\n' "$snapshot_file" "$snapshot_name"
    fi
    return 0
  fi

  if (( ! assume_yes )); then
    printf 'Roll back %s to snapshot %s? [y/N] ' "$snapshot_file" "$snapshot_name"
    local answer=""
    read -r answer || true
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      die "$EX_USAGE" "rollback cancelled"
    fi
  fi

  case "$presence" in
    present)
      cp "${snap_dir}/config" "$snapshot_file"
      printf 'restored %s from snapshot %s\n' "$snapshot_file" "$snapshot_name"
      ;;
    absent)
      rm -f "$snapshot_file"
      printf 'removed %s (snapshot %s recorded it absent)\n' "$snapshot_file" "$snapshot_name"
      ;;
    *)
      die "$EX_ROLLBACK" "snapshot $snapshot_name has an unknown presence state: $presence"
      ;;
  esac
}

main() {
  if [[ $# -lt 1 ]]; then
    usage >&2
    exit "$EX_USAGE"
  fi
  subcommand="$1"
  shift
  case "$subcommand" in
    check|snapshot|rollback|list) ;;
    -h|--help|help)
      usage
      exit 0
      ;;
    *)
      die "$EX_USAGE" "unknown subcommand: $subcommand"
      ;;
  esac

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --directory|-d)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "$1 requires a value"
        target_dir="$2"
        shift
        ;;
      --config)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "$1 requires a value"
        config_file="$2"
        shift
        ;;
      --file)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "$1 requires a value"
        snapshot_file="$2"
        shift
        ;;
      --name|--snapshot)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "$1 requires a value"
        snapshot_name="$2"
        shift
        ;;
      --dry-run) dry_run=1 ;;
      --yes|-y) assume_yes=1 ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "$EX_USAGE" "unknown argument for '$subcommand': $1"
        ;;
    esac
    shift
  done

  case "$subcommand" in
    check) cmd_check ;;
    snapshot) cmd_snapshot ;;
    list) cmd_list ;;
    rollback) cmd_rollback ;;
  esac
}

main "$@"
