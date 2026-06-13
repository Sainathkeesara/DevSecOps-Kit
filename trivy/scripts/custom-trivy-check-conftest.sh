#!/bin/sh
# Custom Trivy check with Rego policies via Conftest integration
#
# Purpose:
#   Run Trivy misconfiguration scans and evaluate results against
#   custom Rego policies using Conftest. This lets you layer
#   organisation-specific rules on top of Trivy's built-in checks.
#
# When to use:
#   - Enforce internal security baselines beyond Trivy's default rules
#   - Gate CI builds on policy violations that Trivy doesn't express
#   - Gradual policy rollout where specific paths or severities get
#     different thresholds
#
# Prerequisites:
#   - trivy (>= 0.45)
#   - conftest (>= 0.50)
#   - jq
#   - opa (optional, for direct policy validation)
#
# Usage:
#   ./custom-trivy-check-conftest.sh --policy ./policies --target fs:.
#   ./custom-trivy-check-conftest.sh --policy ./policies --target image:nginx:latest --severity HIGH,CRITICAL

set -u

SEVERITY="CRITICAL,HIGH"
TARGETS=""
POLICY_DIR="./policies"
OUTDIR="./trivy-conftest-reports"

while [ $# -gt 0 ]; do
  case "$1" in
    --policy)
      POLICY_DIR="$2"; shift 2 ;;
    --severity)
      SEVERITY="$2"; shift 2 ;;
    --outdir)
      OUTDIR="$2"; shift 2 ;;
    -*)
      echo "[!] Unknown option: $1"
      exit 1
      ;;
    *)
      TARGETS="$TARGETS $1"; shift ;;
  esac
done

if [ -z "$TARGETS" ]; then
  echo "[!] No targets specified"
  echo "Usage: $0 [--policy P] [--severity S] [--outdir D] <target>..."
  echo "  Targets:  image:<name>   — container image"
  echo "            fs:<path>      — filesystem path"
  exit 1
fi

for CMD in trivy conftest jq; do
  if ! command -v "$CMD" >/dev/null 2>&1; then
    echo "[!] $CMD not found — install from package manager or official docs"
    exit 1
  fi
done

if [ ! -d "$POLICY_DIR" ]; then
  echo "[!] Policy directory not found: $POLICY_DIR"
  exit 1
fi

mkdir -p "$OUTDIR"

TOTAL=0
PASSED=0
FAILED=0

scan_and_evaluate() {
  TYPE="$1"
  VALUE="$2"
  SAFE_NAME=$(echo "${TYPE}_${VALUE}" | tr '/:.' '___' | tr -d '[:space:]')
  TRIVY_JSON="$OUTDIR/${SAFE_NAME}-trivy.json"
  POLICY_INPUT="$OUTDIR/${SAFE_NAME}-policy-input.json"
  CONFTEST_OUT="$OUTDIR/${SAFE_NAME}-conftest.json"

  echo "[*] Scanning $TYPE:$VALUE ..."

  case "$TYPE" in
    image)
      trivy image "$VALUE" \
        --severity "$SEVERITY" \
        --scanners misconfig \
        --format json \
        --quiet \
        --output "$TRIVY_JSON" 2>/dev/null
      ;;
    fs)
      trivy fs "$VALUE" \
        --severity "$SEVERITY" \
        --scanners misconfig \
        --format json \
        --quiet \
        --output "$TRIVY_JSON" 2>/dev/null
      ;;
    *)
      echo "  [!] Unknown target type: $TYPE (use image: or fs:)"
      return 1
      ;;
  esac

  if [ ! -f "$TRIVY_JSON" ]; then
    echo "  [!] Trivy produced no output for $TYPE:$VALUE"
    return 1
  fi

  TOTAL=$((TOTAL + 1))

  jq '{results: [.Results[]? | {target: .Target, misconfigurations: [.Misconfigurations[]? | {type: .Type, id: .ID, title: .Title, severity: .Severity, message: .Message, cause: .CauseMetadata.Resource}]}]}' \
    "$TRIVY_JSON" > "$POLICY_INPUT" 2>/dev/null

  if conftest test "$POLICY_INPUT" --policy "$POLICY_DIR" --output json > "$CONFTEST_OUT" 2>/dev/null; then
    echo "  [+] Policy check PASSED for $TYPE:$VALUE"
    PASSED=$((PASSED + 1))
  else
    FAILURE_COUNT=$(jq '[.[]? | select(.failures > 0)] | length' "$CONFTEST_OUT" 2>/dev/null || echo 0)
    echo "  [!] Policy check FAILED for $TYPE:$VALUE ($FAILURE_COUNT failure(s))"
    jq -r '.[]? | select(.failures > 0) | "    - \(.filename): \(.failures) failure(s)"' "$CONFTEST_OUT" 2>/dev/null
    FAILED=$((FAILED + 1))
  fi
}

echo "=== Custom Trivy + Conftest Check ==="
echo "Severity filter : $SEVERITY"
echo "Policy dir      : $POLICY_DIR"
echo "Output dir      : $OUTDIR"
echo ""

for TARGET in $TARGETS; do
  TYPE="${TARGET%%:*}"
  VALUE="${TARGET#*:}"

  if [ "$TYPE" = "$VALUE" ] || [ -z "$VALUE" ]; then
    echo "[!] Invalid target format: $TARGET (use type:value)"
    FAILED=$((FAILED + 1))
    TOTAL=$((TOTAL + 1))
    continue
  fi

  scan_and_evaluate "$TYPE" "$VALUE"
  echo ""
done

SUMMARY_FILE="$OUTDIR/summary.txt"
{
  echo "=== Custom Trivy + Conftest Summary ==="
  echo "Date          : $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Severity      : $SEVERITY"
  echo "Policy dir    : $POLICY_DIR"
  echo "---"
  echo "Targets total : $TOTAL"
  echo "Passed        : $PASSED"
  echo "Failed        : $FAILED"
} > "$SUMMARY_FILE"

cat "$SUMMARY_FILE"

if [ "$FAILED" -gt 0 ]; then
  echo "[!] $FAILED target(s) failed policy checks"
  exit 1
fi

echo "[+] All targets passed policy checks"
exit 0
