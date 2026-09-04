// last_verified: 2026-09-04 · Vault 2.1.0

// Vault AWS secrets engine policy
// Mount path: aws-creds
// Purpose: allow the app role to request AWS IAM credentials scoped to a
// specific IAM policy attached to a Vault-managed role. Nothing outside the
// aws-creds/ path is granted here.

// ---------------------------------------------------------------------------
// 1.  Enable the AWS secrets engine (run once, outside policy scope)
// ---------------------------------------------------------------------------
// vault secrets enable -path=aws-creds aws

// ---------------------------------------------------------------------------
// 2.  Configure the AWS root credentials (run once)
// ---------------------------------------------------------------------------
// vault write aws-creds/config/root \
//   access_key=AKIA... \
//   secret_key=...

// ---------------------------------------------------------------------------
// 3.  Create a Vault role that maps to an IAM policy
// ---------------------------------------------------------------------------
// vault write aws-creds/roles/my-app-role \
//   credential_type=iam_user \
//   policy_arns=arn:aws:iam::aws:policy/ReadOnlyAccess \
//   default_sts_ttl=1h \
//   max_sts_ttl=4h

// ---------------------------------------------------------------------------
// 4.  Attach this policy to a Vault identity / AppRole
// ---------------------------------------------------------------------------
// vault policy write aws-app-policy - <<EOF
// (contents of this file)
// EOF

// ---------------------------------------------------------------------------
// Policy rules
// ---------------------------------------------------------------------------

// Generate AWS IAM credentials for the role
path "aws-creds/creds/my-app-role" {
  capabilities = ["read"]
}

// List available roles so callers can discover what they can request
path "aws-creds/roles/*" {
  capabilities = ["list", "read"]
}

// Rotate the AWS root credentials stored in Vault
path "aws-creds/config/root" {
  capabilities = ["update"]
}

// Read the current AWS config (who is the assumed role ARN, etc.)
path "aws-creds/config" {
  capabilities = ["read", "list"]
}
