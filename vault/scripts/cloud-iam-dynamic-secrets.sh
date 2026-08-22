#!/usr/bin/env bash
# last_verified: 2026-08-22 · HashiCorp Vault n/a
set -euo pipefail

# Vault dynamic secrets workflow for cloud IAM credentials
#
# Purpose:
#   Demonstrate Vault's cloud secrets engines (AWS, Azure, GCP) end-to-end:
#   enable the engine, configure cloud credentials, define a role that
#   generates short-lived IAM principals, request credentials, use them,
#   and revoke the lease.
#
# This example uses AWS because it is the most documented cloud backend,
# but the flow is identical for Azure and GCP — swap the secrets engine
# path and credential configuration.
#
# Prerequisites:
#   - vault binary on PATH, VAULT_ADDR and VAULT_TOKEN set (dev server works)
#   - AWS CLI configured with permissions to create IAM users/policies
#   - jq for JSON parsing

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
AWS_MOUNT="aws-iam"
AWS_ROLE="ci-role"
AWS_POLICY_ARN="arn:aws:iam::aws:policy/ReadOnlyAccess"
LEASE_TTL="1h"
MAX_TTL="24h"

log()  { printf '  * %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# 1. Prerequisites
# ---------------------------------------------------------------------------
command -v vault >/dev/null 2>&1 || die "vault not found on PATH"
command -v jq    >/dev/null 2>&1 || die "jq not found on PATH"

if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  die "AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be set"
fi

# ---------------------------------------------------------------------------
# 2. Cleanup handler — disable the secrets engine and revoke any active
#    leases on exit so the demo does not leave orphaned IAM users.
# ---------------------------------------------------------------------------
cleanup() {
  log "Cleaning up..."
  vault secrets disable "$AWS_MOUNT" >/dev/null 2>&1 || true
  log "Engine $AWS_MOUNT disabled."
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# 3. Enable the AWS secrets engine
# ---------------------------------------------------------------------------
log "Enabling AWS secrets engine at $AWS_MOUNT ..."
if ! vault secrets list -format=json | jq -e "has(\"$AWS_MOUNT/\")" >/dev/null 2>&1; then
  vault secrets enable -path="$AWS_MOUNT" aws
else
  log "Engine $AWS_MOUNT already enabled."
fi

# ---------------------------------------------------------------------------
# 4. Configure the root AWS credentials Vault uses to call IAM APIs
# ---------------------------------------------------------------------------
log "Configuring AWS root credentials ..."
vault write "$AWS_MOUNT/config/root" \
  access_key="$AWS_ACCESS_KEY_ID" \
  secret_key="$AWS_SECRET_ACCESS_KEY" \
  region="us-east-1"

# ---------------------------------------------------------------------------
# 5. Create a role that generates short-lived IAM users
# ---------------------------------------------------------------------------
# The policy ARN here is ReadOnlyAccess so the generated credential cannot
# modify resources. Adjust to match the least-privilege posture needed.
log "Creating role $AWS_ROLE ..."
vault write "$AWS_MOUNT/roles/$AWS_ROLE" \
  credential_type=iam_user \
  policy_arns="$AWS_POLICY_ARN" \
  default_sts_ttl="$LEASE_TTL" \
  max_sts_ttl="$MAX_TTL"

# ---------------------------------------------------------------------------
# 6. Generate dynamic IAM credentials
# ---------------------------------------------------------------------------
log "Generating dynamic IAM credentials ..."
CREDS=$(vault read -format=json "$AWS_MOUNT/creds/$AWS_ROLE")
AWS_ACCESS_KEY_ID=$(echo "$CREDS" | jq -r '.data.access_key')
AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | jq -r '.data.secret_key')
LEASE_ID=$(echo "$CREDS" | jq -r '.lease_id')

log "Access key:  $AWS_ACCESS_KEY_ID"
log "Lease ID:    $LEASE_ID"
log "TTL:         $LEASE_TTL"

# ---------------------------------------------------------------------------
# 7. Verify the credentials work against AWS
# ---------------------------------------------------------------------------
log "Verifying credentials with AWS CLI ..."
if AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    aws sts get-caller-identity >/dev/null 2>&1; then
  log "Credentials are valid."
else
  die "Credential verification failed — check IAM policy ARN"
fi

# ---------------------------------------------------------------------------
# 8. Revoke the lease
# ---------------------------------------------------------------------------
log "Revoking lease $LEASE_ID ..."
vault lease revoke "$LEASE_ID"
log "Lease revoked. IAM user is gone."

log "Done. Orphaned credentials are cleaned up by the EXIT trap."
