#!/usr/bin/env bash
# last_verified: 2026-08-30 - Vault n/a

# First Vault secret: write and read back using the CLI
# Start a dev server first: vault server -dev -dev-root-token-id=root

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

# Write a secret
vault kv put secret/myapp/config username="admin" password="s3cret" endpoint="https://api.example.com"

# Read it back
vault kv get secret/myapp/config

# Read a single field
vault kv get -field=password secret/myapp/config

# List secrets at a path
vault kv list secret/myapp/
