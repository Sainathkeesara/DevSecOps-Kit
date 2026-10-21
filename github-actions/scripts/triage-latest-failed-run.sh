#!/usr/bin/env bash
# last_verified: 2026-10-21 · GitHub Actions n/a
#
# Triage the most recent failed GitHub Actions run and save the evidence.
#
# This automates the loop I keep repeating by hand: a push goes red, I open the
# Actions tab, hunt for the run, expand the failed job, and copy the failing
# step out of the log. The script does the hunt, prints the failing jobs and
# steps, and writes the failed-step log to a file I can attach to a ticket.
#
# It only reads. It never dispatches, cancels or re-runs a workflow.
#
# Usage:
#   triage-latest-failed-run.sh [--limit N] [--workflow NAME] [--run-id ID]
#                               [--out DIR] [--repo OWNER/REPO]
#
# Exit codes:
#   0  no failed run among the runs it looked at
#   1  a failed run was found, so this can be used as a gate
#   2  bad usage, or gh could not answer the request

# No `set -e` on purpose: every gh call below decides for itself whether a
# non-zero status is fatal, and I want the error text to reach the caller
# instead of the shell aborting half-way through.
set -uo pipefail

LIMIT=20
WORKFLOW=""
RUN_ID=""
REPO=""
OUT_DIR="."

usage() {
  cat <<'EOF'
Usage: triage-latest-failed-run.sh [options]

  --limit N          how many recent runs to look at (default: 20)
  --workflow NAME    only consider runs whose workflow name contains NAME
  --run-id ID        triage this run instead of searching for one
  --out DIR          where to write the failed-step log (default: current dir)
  --repo OWNER/REPO  repository to query (default: the current repository)
  -h, --help         show this help

Exit codes: 0 = no failed run found, 1 = failed run found, 2 = error.
EOF
}

die() {
  printf '%s\n' "$*" >&2
  exit 2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --limit)
      [ $# -ge 2 ] || die "--limit needs a value"
      LIMIT="$2"
      shift 2
      ;;
    --workflow)
      [ $# -ge 2 ] || die "--workflow needs a value"
      WORKFLOW="$2"
      shift 2
      ;;
    --run-id)
      [ $# -ge 2 ] || die "--run-id needs a value"
      RUN_ID="$2"
      shift 2
      ;;
    --out)
      [ $# -ge 2 ] || die "--out needs a value"
      OUT_DIR="$2"
      shift 2
      ;;
    --repo)
      [ $# -ge 2 ] || die "--repo needs a value"
      REPO="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$LIMIT" in
  ''|*[!0-9]*) die "--limit must be a whole number" ;;
esac
[ "$LIMIT" -gt 0 ] || die "--limit must be greater than zero"

# Every gh call goes through here so --repo is applied in one place.
gh_run() {
  if [ -n "$REPO" ]; then
    gh "$@" --repo "$REPO"
  else
    gh "$@"
  fi
}

run_id=""
conclusion=""

if [ -n "$RUN_ID" ]; then
  run_id="$RUN_ID"
  conclusion=$(gh_run run view "$run_id" --json conclusion --jq '.conclusion' 2>&1)
  status=$?
  if [ "$status" -ne 0 ]; then
    printf 'gh could not read run %s (exit %s):\n%s\n' "$run_id" "$status" "$conclusion" >&2
    exit 2
  fi
else
  # One listing, tab separated, newest first — gh returns runs newest first.
  runs=$(gh_run run list --limit "$LIMIT" \
    --json databaseId,workflowName,status,conclusion \
    --jq '.[] | "\(.databaseId)\t\(.workflowName)\t\(.status)\t\(.conclusion)"' 2>&1)
  status=$?
  if [ "$status" -ne 0 ]; then
    printf 'gh could not list workflow runs (exit %s):\n%s\n' "$status" "$runs" >&2
    exit 2
  fi

  if [ -z "$runs" ]; then
    printf 'No workflow runs found for this repository.\n'
    exit 0
  fi

  inspected=0
  skipped_filtered=0
  skipped_running=0

  while IFS=$'\t' read -r id workflow_name run_status run_conclusion; do
    [ -n "$id" ] || continue
    if [ -n "$WORKFLOW" ]; then
      case "$workflow_name" in
        *"$WORKFLOW"*) ;;
        *)
          skipped_filtered=$((skipped_filtered + 1))
          continue
          ;;
      esac
    fi
    inspected=$((inspected + 1))
    if [ "$run_status" != "completed" ]; then
      skipped_running=$((skipped_running + 1))
      continue
    fi
    if [ "$run_conclusion" = "failure" ]; then
      run_id="$id"
      conclusion="failure"
      break
    fi
  done <<<"$runs"

  if [ "$skipped_running" -gt 0 ]; then
    printf '%s run(s) were still running and were not judged.\n' "$skipped_running"
  fi

  if [ -z "$run_id" ]; then
    printf 'No failed run among the %s run(s) inspected' "$inspected"
    if [ "$skipped_filtered" -gt 0 ]; then
      printf ' (%s skipped by the --workflow filter)' "$skipped_filtered"
    fi
    printf '.\n'
    exit 0
  fi
fi

report=$(gh_run run view "$run_id" \
  --json workflowName,displayTitle,event,headBranch,createdAt,url,jobs \
  --jq '"Workflow: \(.workflowName)", "Run: \(.displayTitle)", "Event: \(.event) on \(.headBranch)", "Created: \(.createdAt)", "URL: \(.url)", "Jobs:", (.jobs[] | "  \(.name): \(.conclusion)", (.steps[] | select(.conclusion == "failure") | "    failed step: \(.name)"))' 2>&1)
status=$?
if [ "$status" -ne 0 ]; then
  printf 'gh could not read run %s (exit %s):\n%s\n' "$run_id" "$status" "$report" >&2
  exit 2
fi
printf '%s\n' "$report"

if [ "$conclusion" != "failure" ]; then
  printf 'This run did not fail, so there is no failed-step log to collect.\n'
  exit 0
fi

mkdir -p "$OUT_DIR" || die "could not create output directory: $OUT_DIR"
log_file="$OUT_DIR/run-$run_id-failed.log"
err_file="$OUT_DIR/run-$run_id-failed.err"

gh_run run view "$run_id" --log-failed >"$log_file" 2>"$err_file"
status=$?
if [ "$status" -ne 0 ]; then
  printf 'gh could not fetch the failed-step log for run %s (exit %s):\n' "$run_id" "$status" >&2
  sed -n '1,5p' "$err_file" >&2
  rm -f "$err_file"
  exit 2
fi
rm -f "$err_file"

if [ -s "$log_file" ]; then
  printf 'Failed-step log written to %s (%s lines).\n' "$log_file" "$(wc -l <"$log_file" | tr -d ' ')"
else
  printf 'gh returned no failed-step log lines for this run; %s is empty.\n' "$log_file"
fi

exit 1
