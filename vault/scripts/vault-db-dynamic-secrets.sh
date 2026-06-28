#!/bin/bash
# Build a Vault dynamic secrets workflow for database credentials from scratch
#
# Purpose:
#   Walk through Vault's database secrets engine end-to-end: start a Postgres
#   container, configure Vault to manage its credentials, generate ephemeral
#   users, verify they work, then revoke the lease.
#
# Prerequisites:
#   - vault binary on PATH, VAULT_ADDR and VAULT_TOKEN set (or use dev server)
#   - docker (for the Postgres target)
#   - jq (for JSON parsing)
#   - psql from postgresql-client (for credential verification)
#
# Steps:
#   1. Start Vault dev server (or check existing one)
#   2. Spin up a Postgres 16 container
#   3. Enable the database secrets engine
#   4. Configure the Postgres connection
#   5. Create a role with granular SQL grants
#   6. Generate dynamic credentials
#   7. Verify the credentials against Postgres
#   8. Revoke and confirm the user is gone

set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
PG_CONTAINER="vault-db-demo-pg"
PG_PORT="5432"
PG_DB="demodb"
PG_ROOT_USER="admin"
PG_ROOT_PASS="adminpass"
DB_MOUNT="demo-db"

log()  { echo "  * $*"; }
die()  { echo "ERROR: $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Prerequisite checks
# ---------------------------------------------------------------------------
command -v vault >/dev/null 2>&1 || die "vault not found"
command -v docker >/dev/null 2>&1 || die "docker not found"
command -v jq    >/dev/null 2>&1 || die "jq not found"

# ---------------------------------------------------------------------------
# Cleanup handler — roll back resources on exit or error
# ---------------------------------------------------------------------------
cleanup() {
  echo ""
  echo "==> Cleaning up..."
  vault secrets disable "$DB_MOUNT" 2>/dev/null || true
  docker rm -f "$PG_CONTAINER" 2>/dev/null || true
  echo "==> Cleanup done."
}
trap cleanup EXIT

echo "=== Vault Dynamic Database Secrets — Demo ==="
echo "  Vault:   $VAULT_ADDR"
echo "  Postgres: :$PG_PORT / $PG_DB"
echo ""

# ---------------------------------------------------------------------------
# 1. Verify Vault is reachable
# ---------------------------------------------------------------------------
echo "[1/7] Checking Vault connection..."
if ! vault status >/dev/null 2>&1; then
  die "Cannot reach Vault at $VAULT_ADDR — start a dev server with:\n  vault server -dev -dev-root-token-id=$VAULT_TOKEN"
fi
log "Vault is alive."

# ---------------------------------------------------------------------------
# 2. Start Postgres container
# ---------------------------------------------------------------------------
echo ""
echo "[2/7] Starting Postgres 16 container..."
docker rm -f "$PG_CONTAINER" 2>/dev/null || true
docker run -d --name "$PG_CONTAINER" \
  -e POSTGRES_USER="$PG_ROOT_USER" \
  -e POSTGRES_PASSWORD="$PG_ROOT_PASS" \
  -e POSTGRES_DB="$PG_DB" \
  -p "$PG_PORT:5432" \
  postgres:16-alpine > /dev/null

log "Waiting for Postgres to accept connections..."
for i in $(seq 1 20); do
  if docker exec "$PG_CONTAINER" pg_isready -q 2>/dev/null; then
    log "Postgres is ready."
    break
  fi
  if [ "$i" -eq 20 ]; then die "Postgres did not start in time"; fi
  sleep 1
done

# ---------------------------------------------------------------------------
# 3. Enable the database secrets engine at a non-default path
# ---------------------------------------------------------------------------
echo ""
echo "[3/7] Enabling database secrets engine at $DB_MOUNT/..."
if vault secrets list -format=json | jq -e "has(\"$DB_MOUNT/\")" >/dev/null 2>&1; then
  log "Already enabled at $DB_MOUNT/"
else
  vault secrets enable -path="$DB_MOUNT" database
  log "Mounted database engine at $DB_MOUNT/"
fi

# ---------------------------------------------------------------------------
# 4. Configure the Postgres connection
# ---------------------------------------------------------------------------
echo ""
echo "[4/7] Configuring Postgres connection in Vault..."
vault write "$DB_MOUNT/config/postgres-connection" \
  plugin_name="postgresql-database-plugin" \
  allowed_roles="dev-role" \
  connection_url="postgresql://{{username}}:{{password}}@localhost:$PG_PORT/$PG_DB?sslmode=disable" \
  username="$PG_ROOT_USER" \
  password="$PG_ROOT_PASS"
log "Connection 'postgres-connection' created."

# ---------------------------------------------------------------------------
# 5. Create a role with minimal SELECT grants
# ---------------------------------------------------------------------------
echo ""
echo "[5/7] Creating role 'dev-role'..."
vault write "$DB_MOUNT/roles/dev-role" \
  db_name="postgres-connection" \
  creation_statements="CREATE USER \"{{name}}\" WITH PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="5m" \
  max_ttl="30m"
log "Role 'dev-role' created with 5-minute default TTL."

# ---------------------------------------------------------------------------
# 6. Generate dynamic credentials
# ---------------------------------------------------------------------------
echo ""
echo "[6/7] Generating dynamic database credentials..."
CREDS=$(vault read -format=json "$DB_MOUNT/creds/dev-role")
DB_USER=$(echo "$CREDS" | jq -r '.data.username')
DB_PASS=$(echo "$CREDS" | jq -r '.data.password')
LEASE_ID=$(echo "$CREDS" | jq -r '.lease_id')
LEASE_DURATION=$(echo "$CREDS" | jq -r '.lease_duration')

log "Username:      $DB_USER"
log "Password:      $DB_PASS"
log "Lease ID:      $LEASE_ID"
log "Lease TTL:     ${LEASE_DURATION}s"

# Try connecting while the lease is active
echo ""
echo "  -- Testing connection with generated credentials..."
if docker exec -e PGPASSWORD="$DB_PASS" "$PG_CONTAINER" \
  psql -U "$DB_USER" -d "$PG_DB" -c "SELECT current_user AS db_user, NOW() AS connected_at;" 2>&1; then
  log "Connection successful — the dynamic user exists in Postgres."
else
  log "Connection failed (host networking may need adjustment on Linux)"
fi

# ---------------------------------------------------------------------------
# 7. Revoke the lease and confirm the user is removed
# ---------------------------------------------------------------------------
echo ""
echo "[7/7] Revoking lease to invalidate credentials..."
vault lease revoke "$LEASE_ID" > /dev/null
log "Lease $LEASE_ID revoked."

# Give Postgres a moment to apply the revocation
sleep 1

echo ""
echo "  -- Confirming the dynamic user is gone..."
if docker exec -e PGPASSWORD="$DB_PASS" "$PG_CONTAINER" \
  psql -U "$DB_USER" -d "$PG_DB" -c "SELECT 1;" 2>&1; then
  log "WARNING: User still exists (revocation may not have propagated yet)."
else
  log "Confirmed — connection refused. The dynamic user has been removed."
fi

echo ""
echo "=== Demo Complete ==="
echo "  The database secrets engine cycled through:"
echo "    config -> role -> credential generation -> verification -> revocation"
echo ""
echo "Next: try adjusting the default_ttl or adding multiple roles for"
echo "different access levels (readonly vs read-write)."
