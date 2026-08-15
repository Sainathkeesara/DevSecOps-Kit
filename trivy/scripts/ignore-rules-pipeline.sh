#!/bin/sh
# last_verified: 2026-08-15 · trivy

scan_target() {
  TARGET_TYPE="$1"
  TARGET_VALUE="$2"
  SEVERITY="$3"
  IGNOREFILE="$4"
  OUTDIR="$5"
  FAIL_ON=$(echo "$6" | tr '[:lower:]' '[:upper:]')

  SAFE_NAME=$(echo "${TARGET_TYPE}_${TARGET_VALUE}" | tr '/:.' '___' | tr -d '[:space:]')
  JSON_OUT="$OUTDIR/${SAFE_NAME}-vulns.json"
  SUMMARY_OUT="$OUTDIR/${SAFE_NAME}-summary.txt"

  IGNORE_ARGS=""
  if [ -n "$IGNOREFILE" ] && [ -f "$IGNOREFILE" ]; then
    IGNORE_ARGS="--ignorefile $IGNOREFILE"
  fi

  trivy "${TARGET_TYPE}" "$TARGET_VALUE" \
    --format json \
    --severity "$SEVERITY" \
    --quiet \
    "$IGNORE_ARGS" \
    --output "$JSON_OUT"

  TRIVY_EXIT=$?

  if [ ! -f "$JSON_OUT" ]; then
    echo "0" > "$OUTDIR/${SAFE_NAME}-count.txt"
    return 0
  fi

  FAIL_COUNT=$(jq --arg sev "$FAIL_ON" '
    [.Results[]? | .Vulnerabilities[]? | select((.Severity | ascii_upcase) == $sev)] | length
  ' "$JSON_OUT" 2>/dev/null || echo 0)

  echo "$FAIL_COUNT" > "$OUTDIR/${SAFE_NAME}-count.txt"

  {
    echo "=== $TARGET_VALUE ==="
    echo "Fail-threshold: $FAIL_ON"
    echo "Findings: $FAIL_COUNT"
    echo "Exit code: $TRIVY_EXIT"
  } > "$SUMMARY_OUT"

  if [ "$FAIL_COUNT" -gt 0 ]; then
    return 1
  fi
  return 0
}

main() {
  SEVERITY="CRITICAL,HIGH"
  FAIL_ON="CRITICAL"
  IGNOREFILE=".trivyignore"
  OUTDIR="./trivy-ignore-reports"
  TARGETS=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --severity)
        SEVERITY="$2"; shift 2 ;;
      --fail-on)
        FAIL_ON="$2"; shift 2 ;;
      --ignorefile)
        IGNOREFILE="$2"; shift 2 ;;
      --outdir)
        OUTDIR="$2"; shift 2 ;;
      -*)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
      *)
        TARGETS="$TARGETS $1"; shift ;;
    esac
  done

  if [ -z "$TARGETS" ]; then
    echo "Usage: $0 [--severity S] [--fail-on F] [--ignorefile I] [--outdir D] <target>..." >&2
    echo "  Targets:  image:<name>   — container image" >&2
    echo "            fs:<path>      — filesystem path" >&2
    exit 1
  fi

  for CMD in trivy jq; do
    if ! command -v "$CMD" >/dev/null 2>&1; then
      echo "$CMD not found" >&2
      exit 1
    fi
  done

  mkdir -p "$OUTDIR"

  TARGET_COUNT=0
  FAIL_COUNT=0

  for TARGET in $TARGETS; do
    TARGET_COUNT=$((TARGET_COUNT + 1))
    TYPE="${TARGET%%:*}"
    VALUE="${TARGET#*:}"

    if [ "$TYPE" = "$VALUE" ]; then
      echo "Skipping malformed target (missing type prefix): $TARGET" >&2
      continue
    fi

    echo "[$TARGET_COUNT] Scanning $TARGET ..."
    if ! scan_target "$TYPE" "$VALUE" "$SEVERITY" "$IGNOREFILE" "$OUTDIR" "$FAIL_ON"; then
      FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
  done

  TOTAL_FAIL=0
  for f in "$OUTDIR"/*-count.txt; do
    [ -f "$f" ] || continue
    TOTAL_FAIL=$((TOTAL_FAIL + $(cat "$f")))
  done

  echo ""
  echo "=== Pipeline summary ==="
  echo "Targets scanned: $TARGET_COUNT"
  echo "Targets with failures: $FAIL_COUNT"
  echo "Total $FAIL_ON findings: $TOTAL_FAIL"
  echo "Reports: $OUTDIR"

  if [ "$TOTAL_FAIL" -gt 0 ]; then
    echo "Pipeline FAILED: $FAIL_ON findings exceed zero-threshold" >&2
    exit 1
  fi
  exit 0
}

main "$@"
