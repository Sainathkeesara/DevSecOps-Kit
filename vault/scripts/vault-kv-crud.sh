#!/bin/bash
# Minimal Vault KV CRUD — write, read, list, delete secrets
# Requires: vault binary, VAULT_ADDR set, valid token

echo "=== Vault KV CRUD Demo ==="

# Write a secret — kv put creates or updates
echo "-- Writing secret --"
vault kv put secret/kit-demo \
  db_user=appuser \
  db_pass="s3cret!$(date +%s)" \
  api_key="sk-abc123" \
  ttl=3600

echo
echo "-- Reading back the secret --"
vault kv get secret/kit-demo

echo
echo "-- Reading just the db_user field --"
vault kv get -field=db_user secret/kit-demo

echo
echo "-- Listing secrets under secret/ --"
vault kv list secret/

echo
echo "-- Listing metadata versions --"
vault kv metadata get secret/kit-demo

echo
echo "-- Deleting the latest version --"
vault kv delete secret/kit-demo

echo
echo "-- Undelete (restore) version 1 --"
vault kv undelete -versions=1 secret/kit-demo

echo
echo "-- Final read after restore --"
vault kv get secret/kit-demo

echo
echo "-- Destroying permanently --"
vault kv destroy -versions=1 secret/kit-demo
