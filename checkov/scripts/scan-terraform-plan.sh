#!/usr/bin/env bash
# Purpose: Export a Terraform plan to JSON and evaluate it with Checkov.
# Use: ./scan-terraform-plan.sh [plan output file] [checkov args...]
# Requires: terraform, checkov, jq

set -euo pipefail

PLAN_BINARY="${1:-tfplan.binary}"
shift || true

if [ ! -f "$PLAN_BINARY" ]; then
    echo "Plan file not found: $PLAN_BINARY"
    echo "Generate one with: terraform plan -out=$PLAN_BINARY"
    exit 1
fi

PLAN_JSON="${PLAN_BINARY%.binary}.json"
echo "Converting $PLAN_BINARY to $PLAN_JSON..."
terraform show -json "$PLAN_BINARY" | jq '.' > "$PLAN_JSON"

echo "Running Checkov on $PLAN_JSON..."
checkov -f "$PLAN_JSON" --framework terraform_plan "$@"

echo "Checkov scan complete."
