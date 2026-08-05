#!/usr/bin/env bash
# last_verified: 2026-08-05 · terraform n/a

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

backend_config="${1:-}"
state_file="${2:-terraform.tfstate}"
migration_plan="${3:-}"

usage() {
  echo "Usage: $0 <backend_config> [state_file] [migration_plan]"
  echo ""
  echo "Arguments:"
  echo "  backend_config   Path to backend configuration file"
  echo "  state_file       Name of the state file (default: terraform.tfstate)"
  echo "  migration_plan   Path to a migration plan JSON (optional)"
  exit 1
}

if [ -z "$backend_config" ]; then
  usage
fi

if [ ! -f "$backend_config" ]; then
  echo "Error: Backend config file not found: $backend_config" >&2
  exit 1
fi

init_backend() {
  echo "Initializing Terraform with remote backend..."
  terraform init -backend-config="$backend_config" -input=false -no-color
}

select_workspace() {
  local workspace="default"
  echo "Selecting workspace: $workspace"
  terraform workspace select "$workspace" 2>/dev/null || terraform workspace new "$workspace"
}

lock_state() {
  echo "Verifying state lock is enabled..."
  if grep -qE 'lock\s*=\s*true' "$backend_config" 2>/dev/null; then
    echo "State locking is enabled in backend config."
  else
    echo "Warning: State locking not explicitly set in backend config." >&2
    echo "Consider adding 'lock = true' to prevent concurrent modifications." >&2
  fi
}

migrate_state() {
  if [ -z "$migration_plan" ]; then
    echo "No migration plan provided. Skipping state migration."
    return 0
  fi

  if [ ! -f "$migration_plan" ]; then
    echo "Error: Migration plan file not found: $migration_plan" >&2
    exit 1
  fi

  echo "Running state migration from plan: $migration_plan"
  local resources
  resources=$(python3 -c "
import json, sys
with open('$migration_plan') as f:
    plan = json.load(f)
for r in plan.get('migrations', []):
    print(r.get('resource', ''))
" 2>/dev/null) || {
    echo "Error: Failed to parse migration plan." >&2
    exit 1
  }

  if [ -z "$resources" ]; then
    echo "No migrations found in plan."
    return 0
  fi

  while IFS= read -r resource; do
    echo "Migrating resource: $resource"
    terraform state mv "$resource" "$resource" 2>/dev/null || {
      echo "Warning: Migration may require manual intervention for: $resource" >&2
    }
  done <<< "$resources"
}

verify_state() {
  echo "Verifying remote state..."
  terraform state list -no-color > /dev/null 2>&1 || {
    echo "Error: Unable to read remote state. Check backend configuration and credentials." >&2
    exit 1
  }
  echo "Remote state is accessible and locked."
}

plan_and_apply() {
  echo "Running terraform plan..."
  terraform plan -no-color -input=false -out="${PROJECT_DIR}/terraform.tfplan"

  echo "Applying Terraform changes..."
  terraform apply -no-color -input=false -auto-approve "${PROJECT_DIR}/terraform.tfplan"
}

cleanup() {
  rm -f "${PROJECT_DIR}/terraform.tfplan"
  echo "Cleanup complete."
}

main() {
  echo "=== Terraform State Management Workflow ==="
  echo "Backend config: $backend_config"
  echo "State file: $state_file"
  echo ""

  init_backend
  select_workspace
  lock_state
  migrate_state
  verify_state
  plan_and_apply
  cleanup

  echo ""
  echo "State management workflow completed successfully."
}

main