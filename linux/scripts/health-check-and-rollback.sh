#!/usr/bin/env bash
# last_verified: 2026-10-03 · linux n/a
# Purpose: Single entry point for a Linux host health check and for the rollback
#          that follows a bad change. Subcommands: check, snapshot, rollback.
# Usage:   ./health-check-and-rollback.sh check [--mount PATH]...
#          ./health-check-and-rollback.sh snapshot --file PATH [--name NAME] [--dry-run]
#          ./health-check-and-rollback.sh rollback --snapshot NAME --file PATH [--unit NAME] [--dry-run] [--yes]
# Exit:    0 healthy, 1 degraded, 2 critical, 64 usage error, 70 rollback failed
# Verify:  ./health-check-and-rollback.sh check --mount /

set -euo pipefail

readonly PROG="${0##*/}"
readonly STATE_DIR="${STATE_DIR:-/var/lib/linux-healthcheck}"

# Thresholds. Every value is overridable from the environment so a per-host
# profile can be applied without editing this file.
LOAD_PER_CORE_WARN="${LOAD_PER_CORE_WARN:-1.5}"
LOAD_PER_CORE_CRIT="${LOAD_PER_CORE_CRIT:-3.0}"
MEM_AVAIL_WARN_PCT="${MEM_AVAIL_WARN_PCT:-15}"
MEM_AVAIL_CRIT_PCT="${MEM_AVAIL_CRIT_PCT:-5}"
DISK_USAGE_WARN_PCT="${DISK_USAGE_WARN_PCT:-80}"
DISK_USAGE_CRIT_PCT="${DISK_USAGE_CRIT_PCT:-90}"
INODE_USAGE_WARN_PCT="${INODE_USAGE_WARN_PCT:-80}"
INODE_USAGE_CRIT_PCT="${INODE_USAGE_CRIT_PCT:-90}"
ZOMBIE_WARN="${ZOMBIE_WARN:-1}"
ZOMBIE_CRIT="${ZOMBIE_CRIT:-20}"
LISTEN_WARN="${LISTEN_WARN:-200}"
LISTEN_CRIT="${LISTEN_CRIT:-500}"

readonly SEV_OK=0
readonly SEV_WARN=1
readonly SEV_CRIT=2
readonly EX_USAGE=64
readonly EX_ROLLBACK=70

worst_severity=$SEV_OK
mounts=()
target_file=""
target_unit=""
snapshot_name=""
assume_yes=0
dry_run=0

die() {
  local code=$1
  shift
  printf '%s: error: %s\n' "$PROG" "$*" >&2
  exit "$code"
}

usage() {
  sed -n '2,9p' "$0" | sed 's/^#\{1,\} \{0,1\}//'
}

# --------------------------------------------------------------- preflight ---

# Binaries and kernel files without which a report would be misleading.
require_prereqs() {
  local missing=() bin
  for bin in awk df cp mkdir date; do
    command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
  done
  ((${#missing[@]} == 0)) || die "$EX_USAGE" "missing required binaries: ${missing[*]}"
  [[ -r /proc/loadavg ]] || die "$EX_USAGE" "/proc/loadavg unreadable: not a Linux host"
  [[ -r /proc/meminfo ]] || die "$EX_USAGE" "/proc/meminfo unreadable: not a Linux host"
}

# Probes that depend on an optional binary degrade to SKIP instead of aborting
# the run: a partial report is still actionable, a missing report is not.
have() { command -v "$1" >/dev/null 2>&1; }

# ------------------------------------------------------------------ helpers --

detect_cpus() {
  local n
  n=$(awk '/^processor[[:space:]]*:/ {c++} END {print c+0}' /proc/cpuinfo 2>/dev/null || echo 0)
  ((n > 0)) || n=1
  printf '%s\n' "$n"
}

# record <severity> <probe> <detail>
record() {
  local sev=$1 status
  case "$sev" in
    "$SEV_OK") status="OK" ;;
    "$SEV_WARN") status="WARN" ;;
    *) status="CRIT" ;;
  esac
  if ((sev > worst_severity)); then
    worst_severity=$sev
  fi
  printf '%-5s %-16s %s\n' "$status" "$2" "$3"
}

skip() { printf '%-5s %-16s %s\n' "SKIP" "$1" "$2"; }

# pct_ge <value> <threshold> succeeds when value >= threshold
pct_ge() { awk -v a="$1" -v b="$2" 'BEGIN { exit !(a >= b) }'; }
# pct_lt <value> <threshold> succeeds when value < threshold
pct_lt() { awk -v a="$1" -v b="$2" 'BEGIN { exit !(a < b) }'; }

# ------------------------------------------------------------------- probes --

probe_load() {
  local cpus load1 ratio
  cpus=$(detect_cpus)
  read -r load1 _ </proc/loadavg
  ratio=$(awk -v l="$load1" -v c="$cpus" 'BEGIN { printf "%.2f", l / c }')
  if ! awk -v r="$ratio" -v t="$LOAD_PER_CORE_CRIT" 'BEGIN { exit !(r >= t) }'; then
    if ! awk -v r="$ratio" -v t="$LOAD_PER_CORE_WARN" 'BEGIN { exit !(r >= t) }'; then
      record "$SEV_OK" load "1-min load ${ratio} per core across ${cpus} cpu"
      return 0
    fi
    record "$SEV_WARN" load "1-min load ${ratio} per core across ${cpus} cpu (warn at ${LOAD_PER_CORE_WARN})"
    return 0
  fi
  record "$SEV_CRIT" load "1-min load ${ratio} per core across ${cpus} cpu (crit at ${LOAD_PER_CORE_CRIT})"
}

probe_memory() {
  local total_kb avail_kb pct
  total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
  avail_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
  if [[ -z "$total_kb" || -z "$avail_kb" ]]; then
    skip memory "kernel does not export MemAvailable"
    return 0
  fi
  pct=$(awk -v a="$avail_kb" -v t="$total_kb" 'BEGIN { printf "%.1f", (a / t) * 100 }')
  if pct_lt "$pct" "$MEM_AVAIL_CRIT_PCT"; then
    record "$SEV_CRIT" memory "${pct}% available (crit below ${MEM_AVAIL_CRIT_PCT}%)"
  elif pct_lt "$pct" "$MEM_AVAIL_WARN_PCT"; then
    record "$SEV_WARN" memory "${pct}% available (warn below ${MEM_AVAIL_WARN_PCT}%)"
  else
    record "$SEV_OK" memory "${pct}% available"
  fi
}

# df_probe <label> <extra-df-flag|-> <warn> <crit> <path>...
df_probe() {
  local label=$1 flag=$2 warn=$3 crit=$4
  shift 4
  local path out used fs
  for path in "$@"; do
    if [[ "$flag" == "-" ]]; then
      out=$(df -P "$path" 2>/dev/null | awk 'NR == 2 {print $1, $5}' || true)
    else
      out=$(df -P "$flag" "$path" 2>/dev/null | awk 'NR == 2 {print $1, $5}' || true)
    fi
    if [[ -z "$out" ]]; then
      record "$SEV_CRIT" "$label" "cannot read usage for ${path}"
      continue
    fi
    fs=${out%% *}
    used=${out##* }
    if pct_ge "$used" "$crit"; then
      record "$SEV_CRIT" "$label" "${path} ${used} used on ${fs} (crit at ${crit}%)"
    elif pct_ge "$used" "$warn"; then
      record "$SEV_WARN" "$label" "${path} ${used} used on ${fs} (warn at ${warn}%)"
    else
      record "$SEV_OK" "$label" "${path} ${used} used on ${fs}"
    fi
  done
}

probe_zombies() {
  local n
  if ! have ps; then
    skip zombies "ps not available"
    return 0
  fi
  n=$(ps -eo stat= 2>/dev/null | awk '$1 ~ /^Z/ {c++} END {print c+0}' || true)
  if ((n >= ZOMBIE_CRIT)); then
    record "$SEV_CRIT" zombies "${n} unreaped child processes (crit at ${ZOMBIE_CRIT})"
  elif ((n >= ZOMBIE_WARN)); then
    record "$SEV_WARN" zombies "${n} unreaped child processes (warn at ${ZOMBIE_WARN})"
  else
    record "$SEV_OK" zombies "${n} unreaped child processes"
  fi
}

probe_failed_units() {
  local units
  if ! have systemctl; then
    skip failed-units "systemctl not available (container or non-systemd host)"
    return 0
  fi
  units=$(systemctl --failed --no-legend --plain 2>/dev/null | awk 'NF {c++} END {print c+0}' || true)
  if ((units == 0)); then
    record "$SEV_OK" failed-units "no failed units"
    return 0
  fi
  record "$SEV_CRIT" failed-units "${units} failed unit(s):"
  systemctl --failed --no-legend --plain 2>/dev/null | awk 'NF {print "     - " $1}'
}

probe_oom() {
  local log_source log_text hits
  if have journalctl; then
    log_source=journalctl
    log_text=$(journalctl -k -b --no-pager -q 2>/dev/null || true)
  elif have dmesg; then
    log_source=dmesg
    log_text=$(dmesg 2>/dev/null || true)
  else
    skip oom-kills "neither journalctl nor dmesg available"
    return 0
  fi
  if [[ -z "$log_text" ]]; then
    skip oom-kills "kernel log buffer not readable via ${log_source}"
    return 0
  fi
  hits=$(printf '%s\n' "$log_text" | awk 'tolower($0) ~ /out of memory/ {c++} END {print c+0}')
  if ((hits > 0)); then
    record "$SEV_WARN" oom-kills "${hits} out-of-memory line(s) in the current boot buffer (via ${log_source})"
  else
    record "$SEV_OK" oom-kills "no out-of-memory lines in the current boot buffer (via ${log_source})"
  fi
}

probe_listeners() {
  local n
  if ! have ss; then
    skip listeners "ss not available"
    return 0
  fi
  n=$(ss -H -tln 2>/dev/null | awk 'NF {c++} END {print c+0}' || true)
  if ((n >= LISTEN_CRIT)); then
    record "$SEV_CRIT" listeners "${n} listening tcp socket(s) (crit at ${LISTEN_CRIT})"
  elif ((n >= LISTEN_WARN)); then
    record "$SEV_WARN" listeners "${n} listening tcp socket(s) (warn at ${LISTEN_WARN})"
  else
    record "$SEV_OK" listeners "${n} listening tcp socket(s)"
  fi
}

# -------------------------------------------------------------- subcommands --

cmd_check() {
  require_prereqs
  ((${#mounts[@]} == 0)) && mounts=("/")
  printf '%-5s %-16s %s\n' "STATE" "PROBE" "DETAIL"
  probe_load
  probe_memory
  df_probe filesystem - "$DISK_USAGE_WARN_PCT" "$DISK_USAGE_CRIT_PCT" "${mounts[@]}"
  df_probe inodes -i "$INODE_USAGE_WARN_PCT" "$INODE_USAGE_CRIT_PCT" "${mounts[@]}"
  probe_zombies
  probe_failed_units
  probe_oom
  probe_listeners
  case "$worst_severity" in
    "$SEV_OK") printf '\nresult: healthy\n' ;;
    "$SEV_WARN") printf '\nresult: degraded - hold the change, do not roll back yet\n' ;;
    *) printf '\nresult: critical - snapshot the current state, then roll back\n' ;;
  esac
  return "$worst_severity"
}

cmd_snapshot() {
  require_prereqs
  [[ -n "$target_file" ]] || die "$EX_USAGE" "snapshot requires --file PATH"
  [[ -f "$target_file" ]] || die "$EX_USAGE" "$target_file is not a regular file"
  local name dest
  name=${snapshot_name:-"$(date -u +%Y%m%dT%H%M%S)Z"}
  dest="$STATE_DIR/$name"
  if ((dry_run)); then
    printf 'dry-run: would copy %s to %s\n' "$target_file" "$dest"
    return 0
  fi
  mkdir -p "$STATE_DIR"
  [[ ! -e "$dest" ]] || die "$EX_USAGE" "snapshot ${name} already exists at ${dest}"
  cp -p "$target_file" "$dest"
  printf 'snapshot %s written to %s\n' "$name" "$dest"
  if have sha256sum; then
    printf '  %s  %s\n' "$(sha256sum <"$target_file" | awk '{print $1}')" "$target_file"
    printf '  %s  %s\n' "$(sha256sum <"$dest" | awk '{print $1}')" "$dest"
  fi
  return 0
}

cmd_rollback() {
  require_prereqs
  [[ -n "$target_file" ]] || die "$EX_USAGE" "rollback requires --file PATH"
  [[ -n "$snapshot_name" ]] || die "$EX_USAGE" "rollback requires --snapshot NAME"
  local src="$STATE_DIR/$snapshot_name" undo reply
  [[ -f "$src" ]] || die "$EX_ROLLBACK" "no such snapshot: ${src}"

  if have sha256sum; then
    if [[ "$(sha256sum <"$src")" == "$(sha256sum <"$target_file" 2>/dev/null || echo none)" ]]; then
      printf 'snapshot %s is byte-identical to %s - nothing to roll back\n' "$snapshot_name" "$target_file"
      return 0
    fi
  else
    printf 'note: sha256sum unavailable, restoring without a pre-restore comparison\n' >&2
  fi

  if ((dry_run)); then
    printf 'dry-run: would restore %s over %s' "$src" "$target_file"
    [[ -n "$target_unit" ]] && printf ' and restart unit %s' "$target_unit"
    printf '\n'
    return 0
  fi

  if ((assume_yes == 0)); then
    printf 'about to overwrite %s with %s\n' "$target_file" "$src"
    read -r -p 'continue? [y/N] ' reply || die "$EX_USAGE" "no input on stdin, aborting"
    [[ "$reply" == "y" || "$reply" == "Y" ]] || die "$EX_USAGE" "aborted at prompt"
  fi

  # Keep the outgoing file beside the snapshot so a rollback is itself reversible.
  undo="$STATE_DIR/pre-rollback-$snapshot_name"
  cp -p "$target_file" "$undo"
  cp -p "$src" "$target_file"
  printf 'restored %s over %s (outgoing copy kept at %s)\n' "$src" "$target_file" "$undo"

  if [[ -n "$target_unit" ]]; then
    have systemctl || die "$EX_ROLLBACK" "restored ${target_file}, but systemctl is unavailable: restart ${target_unit} by hand"
    systemctl restart "$target_unit" || die "$EX_ROLLBACK" "systemctl restart ${target_unit} failed"
    printf 'restarted unit %s\n' "$target_unit"
  fi
  return 0
}

# --------------------------------------------------------------------- main --

main() {
  local cmd="${1:-check}"
  shift || true
  while (($#)); do
    case "$1" in
      --mount)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "--mount needs a path"
        mounts+=("$2")
        shift 2
        ;;
      --file)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "--file needs a path"
        target_file=$2
        shift 2
        ;;
      --unit)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "--unit needs a unit name"
        target_unit=$2
        shift 2
        ;;
      --snapshot)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "--snapshot needs a name"
        snapshot_name=$2
        shift 2
        ;;
      --name)
        [[ $# -ge 2 ]] || die "$EX_USAGE" "--name needs a value"
        snapshot_name=$2
        shift 2
        ;;
      --dry-run) dry_run=1; shift ;;
      --yes | -y) assume_yes=1; shift ;;
      -h | --help) usage; exit 0 ;;
      *) die "$EX_USAGE" "unknown argument: $1" ;;
    esac
  done

  case "$cmd" in
    check) cmd_check ;;
    snapshot) cmd_snapshot ;;
    rollback) cmd_rollback ;;
    -h | --help | help) usage ;;
    *) die "$EX_USAGE" "unknown subcommand: ${cmd} (expected check, snapshot, or rollback)" ;;
  esac
}

main "$@"
