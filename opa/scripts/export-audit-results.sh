#!/usr/bin/env bash
# last_verified: 2026-08-27 · OPA Gatekeeper
set -euo pipefail

# Export Gatekeeper audit results to JSON and print a compliance summary.
#
# Usage:
#   ./export-audit-results.sh [--constraint <name>] [--output-dir <dir>]
#
# Without --constraint, the script audits every Constraint in the cluster
# and writes one JSON file per Constraint kind under <output-dir>.

OUTPUT_DIR="."
CONSTRAINT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --constraint)
      CONSTRAINT="$2"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$OUTPUT_DIR"

if [ -n "$CONSTRAINT" ]; then
  KINDS=$(kubectl get constraints --no-headers -o custom-columns='KIND:.kind,NAME:.metadata.name' | grep "$CONSTRAINT" | awk '{print $1}' | sort -u)
else
  KINDS=$(kubectl get constraints --no-headers -o custom-columns='KIND:.kind' | sort -u)
fi

if [ -z "$KINDS" ]; then
  echo "No constraints found."
  exit 0
fi

TOTAL_VIOLATIONS=0
TOTAL_CONSTRAINTS=0

for kind in $KINDS; do
  FILE="$OUTPUT_DIR/${kind,,}-audit.json"
  kubectl get "$kind" --all-namespaces -o json > "$FILE"

  COUNT=$(jq '[.items[].status.violations // [] | length] | add // 0' "$FILE")
  ITEMS=$(jq '.items | length' "$FILE")
  TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + COUNT))
  TOTAL_CONSTRAINTS=$((TOTAL_CONSTRAINTS + ITEMS))

  echo "$kind: $ITEMS constraint(s), $COUNT violation(s) -> $FILE"
done

echo ""
echo "=== Compliance summary ==="
echo "Constraint kinds audited : $(echo "$KINDS" | wc -w)"
echo "Total constraints checked: $TOTAL_CONSTRAINTS"
echo "Total violations found   : $TOTAL_VIOLATIONS"

if [ "$TOTAL_VIOLATIONS" -gt 0 ]; then
  echo "STATUS: NON-COMPLIANT"
  exit 1
else
  echo "STATUS: COMPLIANT"
  exit 0
fi
