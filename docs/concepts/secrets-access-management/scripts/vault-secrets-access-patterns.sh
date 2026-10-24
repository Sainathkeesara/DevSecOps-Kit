#!/usr/bin/env bash
# last_verified: 2026-10-24 · vault n/a
# Practice: common Vault secret access patterns.
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"

echo "Listing KV v2 secrets under secret/data/app ..."
vault kv list secret/app || echo "no secrets or path missing"

echo "Reading a single secret ..."
vault kv get secret/app/db || true

echo "Writing a secret (practice only) ..."
vault kv put secret/app/db username=demo password=demo || true

echo "Done."
