#!/usr/bin/env bash
# last_verified: 2026-09-27 · linux-shell-fundamentals (concept, n/a)

# The shell patterns I actually reach for when automating DevOps work, as
# opposed to the variables-and-loops exercises. The three that keep coming
# back are: wrapping each step so one failure does not hide the rest, retrying
# a step that failed for a transient reason, and reading configuration out of a
# key=value file so values never sit in the script body.
#
# Everything runs against /tmp in a $$-suffixed directory, so re-running it
# cannot collide with another copy and nothing outside the script is touched.

WORK_DIR="/tmp/devops-shell-patterns-$$"
mkdir -p "$WORK_DIR"
SUMMARY="$WORK_DIR/summary.txt"
: > "$SUMMARY"

log() {
  # Quoted on purpose: an unquoted $1 would word-split any message containing
  # a space, which is most of them.
  echo "[$(date '+%H:%M:%S')] $1"
}

# run_step <name> <command...>
# Records the exit status of each step and keeps going, so a failure halfway
# down still leaves me a full picture instead of a script that died on step 1
# and told me nothing about steps 2 and 3.
run_step() {
  local name=$1
  shift

  log "START $name"
  "$@"
  local status=$?

  printf '%-20s %s\n' "$name" "$status" >> "$SUMMARY"

  if [ "$status" -ne 0 ]; then
    log "FAIL  $name (exit $status) — continuing so I see the rest"
  else
    log "OK    $name"
  fi

  return "$status"
}

# retry <attempts> <command...>
# For steps that fail for a reason outside my control (a registry timing out,
# a remote API rate-limiting me). The sleep doubles each time so I am not
# hammering whatever was already unhappy.
retry() {
  local attempts=$1
  shift
  local n=1
  local delay=1

  while [ "$n" -le "$attempts" ]; do
    if "$@"; then
      log "succeeded on attempt $n"
      return 0
    fi
    if [ "$n" -eq "$attempts" ]; then
      log "giving up after $attempts attempts"
      return 1
    fi
    log "attempt $n failed, sleeping ${delay}s before retrying"
    sleep "$delay"
    n=$((n + 1))
    delay=$((delay * 2))
  done
}

# Stands in for the call that actually does fail sometimes. It counts its own
# attempts and only succeeds from the second one on, so the retry path is
# exercised on every run without depending on a network being unhappy.
fetch_remote_inputs() {
  local counter_file="$WORK_DIR/fetch-attempts"
  local count=0

  if [ -f "$counter_file" ]; then
    count=$(cat "$counter_file")
  fi
  count=$((count + 1))
  echo "$count" > "$counter_file"

  if [ "$count" -ge 2 ]; then
    echo "inputs fetched on attempt $count"
    return 0
  fi

  echo "remote input endpoint did not respond" >&2
  return 1
}

# read_env_file <path> — reads KEY=value into the environment. The redirect at
# the end of the loop keeps it in this shell, so the exports survive the call.
read_env_file() {
  local file=$1
  local key value

  while IFS='=' read -r key value; do
    case "$key" in
      ''|\#*) continue ;;
    esac
    export "$key=$value"
    log "loaded $key from $(basename "$file")"
  done < "$file"
}

write_env_file() {
  cat > "$WORK_DIR/pipeline.env" <<'EOF'
# key=value, one per line. Blank lines and # comments are skipped.
DEPLOY_TARGET=staging
IMAGE_TAG=v1
NOTIFY_CHANNEL=none
EOF
}

main() {
  log "working dir: $WORK_DIR"

  # Reading config out of a file is what lets the same script run unchanged
  # against different targets.
  write_env_file
  read_env_file "$WORK_DIR/pipeline.env"
  log "resolved to $IMAGE_TAG for $DEPLOY_TARGET"

  run_step "validate-image-tag" test -n "$IMAGE_TAG"

  run_step "check-target-known" test "$DEPLOY_TARGET" != "unknown"

  # Retry only where the failure could be transient. Wrapping a syntax error
  # in a retry just means waiting longer for the same error.
  retry 3 fetch_remote_inputs

  run_step "notify-skipped-when-none" test "$NOTIFY_CHANNEL" = "none"

  echo
  echo "--- step summary (step, exit status) ---"
  cat "$SUMMARY"

  # The summary is the actual deliverable: CI needs the script to exit non-zero
  # if any step failed, so I look for a row that is not a zero status.
  if [ -s "$SUMMARY" ] && grep -qvE ' 0$' "$SUMMARY"; then
    echo "at least one step failed — exiting 1" >&2
    return 1
  fi

  echo "all steps reported 0"
  return 0
}

main "$@"
