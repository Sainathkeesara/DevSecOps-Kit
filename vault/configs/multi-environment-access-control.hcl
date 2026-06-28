# Vault multi-environment access control policies
# HCL configuration for dev, staging, and prod environments
# with appropriate access levels per tier

# ===========================================================================
# Path-based access control for CI/CD pipelines
# ===========================================================================
# CI/CD jobs authenticate with Vault using approle or kubernetes auth.
# Policies are scoped to environment-specific secret paths.

# Development environment — engineers have full access
# Used by developers for local testing and feature work
path "secret/data/dev/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/dev/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Staging environment — read-only for most engineers, write for release team
# Release team handles deployment prep and test fixture setup
path "secret/data/staging/shared/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/staging/shared/*" {
  capabilities = ["read", "list"]
}

# Release team gets write access to specific paths
path "secret/data/staging/release/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/staging/release/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Production environment — tightly controlled
# Only on-call SREs have read access; no direct write access here
path "secret/data/prod/shared/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/prod/shared/*" {
  capabilities = ["read", "list"]
}

# ===========================================================================
# Entity and group metadata access
# ===========================================================================
# Policies can reference entity metadata for dynamic path construction
# This lets teams organize secrets by their Vault identity

path "identity/entity/name/{{identity.entity.name}}" {
  capabilities = ["read"]
}

path "identity/group/id/{{identity.groups.*.id}}" {
  capabilities = ["read"]
}

# ===========================================================================
# Transit engine access — encryption as a service
# ===========================================================================
# All environments can use the transit engine for encryption/decryption
# Prod has stricter key access; dev can create keys for testing

path "transit/keys/dev-*" {
  capabilities = ["create", "read", "update", "list"]
}

path "transit/keys/staging-*" {
  capabilities = ["read", "list"]
}

path "transit/keys/prod-*" {
  capabilities = ["read", "list"]
}

# Encryption/decryption operations
path "transit/encrypt/*" {
  capabilities = ["update"]
}

path "transit/decrypt/*" {
  capabilities = ["update"]
}

# ===========================================================================
# Database secrets engine access
# ===========================================================================
# Dynamic credentials are generated per-environment
# Applications get time-limited credentials, not static passwords

path "database/creds/dev-app-{{identity.entity.name}}" {
  capabilities = ["read"]
}

path "database/creds/staging-app-*" {
  capabilities = ["read"]
}

path "database/creds/prod-app-*" {
  capabilities = ["read"]
}

# ===========================================================================
# PKI (certificate) access
# ===========================================================================
# Services need certificates for TLS; prod certs require stricter controls

path "pki_int/sign/dev-dot-{{identity.entity.name}}/*" {
  capabilities = ["update"]
}

path "pki_int/sign/staging-dot-*" {
  capabilities = ["update"]
}

path "pki_int/sign/prod-dot-*" {
  capabilities = ["update"]
}