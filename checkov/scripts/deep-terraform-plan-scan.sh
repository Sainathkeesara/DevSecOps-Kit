#!/usr/bin/env bash
# Deep Checkov Terraform plan analysis script with CI/CD gating.
# Level: L5
# Use: ./deep-terraform-plan-scan.sh [terraform dir] [plan args...]

set -euo pipefail

TERRAFORM_DIR="${1:-.}"
shift || true

REQUIRED_BINS=(terraform checkov jq)
for bin in "${REQUIRED_BINS[@]}"; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "Missing required binary: $bin" >&2
    exit 1
  fi
done

if [ ! -d "$TERRAFORM_DIR" ]; then
  echo "Terraform directory not found: $TERRAFORM_DIR" >&2
  exit 1
fi

TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
PLAN_BINARY="tfplan-${TIMESTAMP}.binary"
PLAN_JSON="tfplan-${TIMESTAMP}.json"
REPORT_DIR="checkov-reports"
OUTPUT_PREFIX="${REPORT_DIR}/checkov-${TIMESTAMP}"
FAIL_ON_SEVERITY="${CHECKOV_FAIL_ON_SEVERITY:-high,critical}"
SKIP_CHECKS="${CHECKOV_SKIP_CHECKS:-}"
EXTERNAL_CHECKS_DIR="${CHECKOV_EXTERNAL_CHECKS_DIR:-}"
COMPACT="${CHECKOV_COMPACT:-true}"

mkdir -p "$REPORT_DIR"

cd "$TERRAFORM_DIR"

terraform init -input=false -backend=false >/dev/null
terraform plan -out="$PLAN_BINARY" "$@"
terraform show -json "$PLAN_BINARY" | jq '.' > "$PLAN_JSON"

CHECKOV_ARGS=(
  -f "$PLAN_JSON"
  --framework terraform_plan
  --output sarif
  --output cli-json
  --quiet
)

if [ -n "$SKIP_CHECKS" ]; then
  CHECKOV_ARGS+=(--skip-check "$SKIP_CHECKS")
fi

if [ -n "$EXTERNAL_CHECKS_DIR" ]; then
  CHECKOV_ARGS+=(--external-checks-dir "$EXTERNAL_CHECKS_DIR")
fi

if [ "$COMPACT" = "true" ]; then
  CHECKOV_ARGS+=(--compact)
fi

convert_severity_to_flag() {
  local sev="$1"
  case "$sev" in
    critical) echo "--hard-fail-on CRITICAL" ;;
    high)     echo "--hard-fail-on HIGH" ;;
    medium)   echo "--hard-fail-on MEDIUM" ;;
    low)      echo "--hard-fail-on LOW" ;;
    *)        echo "" ;;
  esac
}

IFS=',' read -ra SEVERITIES <<< "$FAIL_ON_SEVERITY"
for sev in "${SEVERITIES[@]}"; do
  flag=$(convert_severity_to_flag "$sev")
  if [ -n "$flag" ]; then
    read -r -a flag_parts <<< "$flag"
    CHECKOV_ARGS+=("${flag_parts[@]}")
  fi
done

checkov "${CHECKOV_ARGS[@]}" > "${OUTPUT_PREFIX}.sarif" 2>&1 || true

if jq -e '.runs[].results[] | select(.level=="error")' "${OUTPUT_PREFIX}.sarif" >/dev/null 2>&1; then
  FAIL_COUNT=$(jq '[.runs[].results[] | select(.level=="error")] | length' "${OUTPUT_PREFIX}.sarif")
  echo "Scan completed with ${FAIL_COUNT} error-level findings (${OUTPUT_PREFIX}.sarif)"
  rm -f "$PLAN_BINARY" "$PLAN_JSON"
  exit 1
fi

PASS_COUNT=$(jq '[.runs[].results[] | select(.level=="none" or .level=="warning")] | length' "${OUTPUT_PREFIX}.sarif" || echo 0)
echo "Deep Checkov plan scan passed. ${PASS_COUNT} non-error results in ${OUTPUT_PREFIX}.sarif"
rm -f "$PLAN_BINARY" "$PLAN_JSON"
exit 0
