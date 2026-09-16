#!/bin/bash
# last_verified: 2026-09-16 · vault n/a
# Vault PKI secrets engine workflow — certificate issuance, renewal, and revocation.
#
# Purpose:
#   Walk through Vault's PKI secrets engine end-to-end against a single-level
#   self-signed root CA: enable the engine, generate the root, configure a
#   role, issue a leaf certificate, verify it with openssl, rotate it by
#   re-issuing, then revoke the original and confirm it lands on the CRL.
#   Single-level root only — no intermediate CA is configured here.
#
# When to use:
#   Short-lived service certificates where Vault is the internal CA and
#   callers fetch fresh certificates instead of managing files by hand.
#
# Prerequisites:
#   - vault binary on PATH, VAULT_ADDR and VAULT_TOKEN set (or dev server)
#   - jq (for JSON parsing)
#   - openssl (for certificate and CRL verification)
#
# Steps:
#   1. Verify Vault is reachable
#   2. Enable the PKI engine at $PKI_MOUNT and tune the max lease TTL
#   3. Generate a self-signed root CA
#   4. Configure the CA/cluster URLs
#   5. Create a leaf-certificate role
#   6. Issue a leaf certificate and verify it with openssl
#   7. Rotate (re-issue a fresh certificate — PKI certs have no renew endpoint)
#   8. Revoke the original certificate and confirm it appears on the CRL
#   9. List the remaining certificates
#
# Verify:
#   - `openssl x509 -in leaf.crt -noout -subject -issuer` shows the leaf
#     subject issued by the root CA subject.
#   - `openssl verify -CAfile ca.crt leaf.crt` returns OK.
#   - After revocation, the original serial appears in the CRL text.
#
# Common errors:
#   - "path is already in use" on enable: the engine is already mounted at
#     $PKI_MOUNT — the script reuses the existing mount.
#   - Connection refused on VAULT_ADDR: start a dev server first, e.g.
#     `vault server -dev`, and export VAULT_ADDR/VAULT_TOKEN.
#   - Revocation reports "serial not found": the serial string must match
#     exactly, including colon separators — the script passes through the
#     value returned at issuance time without reformatting.
#
# Rollback:
#   The script keeps every artifact under $WORK_DIR (certs, keys, serials).
#   To roll back, revoke any unexpired serials, then run
#   `vault secrets disable <mount>` to remove the engine mount.

set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
PKI_MOUNT="${PKI_MOUNT:-pki}"
ROLE_NAME="${ROLE_NAME:-example-dot-com}"
LEAF_CN="${LEAF_CN:-service.example.com}"
WORK_DIR="${WORK_DIR:-./vault-pki-work}"

log() { echo "  * $*"; }
die() { echo "ERROR: $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Prerequisite checks
# ---------------------------------------------------------------------------
command -v vault >/dev/null 2>&1 || die "vault not found on PATH"
command -v jq >/dev/null 2>&1 || die "jq not found on PATH"
command -v openssl >/dev/null 2>&1 || die "openssl not found on PATH"

export VAULT_ADDR VAULT_TOKEN

echo "=== Vault PKI Workflow (root CA only) ==="
echo "  Vault:     $VAULT_ADDR"
echo "  Mount:     $PKI_MOUNT/"
echo "  Role:      $ROLE_NAME"
echo "  Leaf CN:   $LEAF_CN"
echo "  Work dir:  $WORK_DIR"
echo ""

mkdir -p "$WORK_DIR"

# ---------------------------------------------------------------------------
# 1. Verify Vault is reachable
# ---------------------------------------------------------------------------
echo "[1/9] Checking Vault connection..."
if ! vault status >/dev/null 2>&1; then
  die "Cannot reach Vault at $VAULT_ADDR — start a dev server with: vault server -dev"
fi
log "Vault is alive."

# ---------------------------------------------------------------------------
# 2. Enable the PKI engine and tune the max lease TTL
# ---------------------------------------------------------------------------
echo ""
echo "[2/9] Enabling PKI engine at $PKI_MOUNT/..."
if vault secrets list -format=json | jq -e "has(\"$PKI_MOUNT/\")" >/dev/null 2>&1; then
  log "Already mounted at $PKI_MOUNT/ — reusing it."
else
  vault secrets enable -path="$PKI_MOUNT" pki
  log "Mounted PKI engine at $PKI_MOUNT/."
fi

vault secrets tune -max-lease-ttl=87600h "$PKI_MOUNT"
log "Max lease TTL set to 87600h (10 years) on $PKI_MOUNT/."

# ---------------------------------------------------------------------------
# 3. Generate a self-signed root CA
# ---------------------------------------------------------------------------
echo ""
echo "[3/9] Generating self-signed root CA..."
vault write -field=certificate "$PKI_MOUNT/root/generate/internal" \
  common_name="Example Root CA" \
  ttl=87600h > "$WORK_DIR/ca.crt"
log "Root CA certificate saved to $WORK_DIR/ca.crt."
openssl x509 -in "$WORK_DIR/ca.crt" -noout -subject -issuer

# ---------------------------------------------------------------------------
# 4. Configure the CA and CRL URLs
# ---------------------------------------------------------------------------
echo ""
echo "[4/9] Configuring cluster URLs..."
vault write "$PKI_MOUNT/config/urls" \
  issuing_certificates="$VAULT_ADDR/v1/$PKI_MOUNT/ca" \
  crl_distribution_points="$VAULT_ADDR/v1/$PKI_MOUNT/crl"
log "Cluster URLs configured on $PKI_MOUNT/config/urls."

# ---------------------------------------------------------------------------
# 5. Create a leaf-certificate role
# ---------------------------------------------------------------------------
echo ""
echo "[5/9] Creating role $ROLE_NAME..."
vault write "$PKI_MOUNT/roles/$ROLE_NAME" \
  allowed_domains="example.com" \
  allow_subdomains=true \
  max_ttl=720h
log "Role $ROLE_NAME created."

# ---------------------------------------------------------------------------
# 6. Issue a leaf certificate and verify it
# ---------------------------------------------------------------------------
echo ""
echo "[6/9] Issuing leaf certificate for $LEAF_CN..."
vault write -format=json "$PKI_MOUNT/issue/$ROLE_NAME" \
  common_name="$LEAF_CN" \
  ttl=24h > "$WORK_DIR/issue-1.json"

jq -r '.data.certificate' "$WORK_DIR/issue-1.json" > "$WORK_DIR/leaf.crt"
jq -r '.data.private_key' "$WORK_DIR/issue-1.json" > "$WORK_DIR/leaf.key"
jq -r '.data.serial_number' "$WORK_DIR/issue-1.json" > "$WORK_DIR/serial-1.txt"
chmod 600 "$WORK_DIR/leaf.key"

SERIAL_ONE="$(cat "$WORK_DIR/serial-1.txt")"
log "Leaf certificate issued. Serial: $SERIAL_ONE"

echo ""
echo "  -- Verifying leaf against the root CA..."
openssl x509 -in "$WORK_DIR/leaf.crt" -noout -subject -issuer
openssl verify -CAfile "$WORK_DIR/ca.crt" "$WORK_DIR/leaf.crt"
log "Leaf verifies against the root CA."

# ---------------------------------------------------------------------------
# 7. Rotate by re-issuing (PKI certificates have no renew endpoint)
# ---------------------------------------------------------------------------
echo ""
echo "[7/9] Rotating: issuing a fresh certificate for $LEAF_CN..."
echo "  NOTE: the PKI engine exposes no per-serial renew endpoint, so"
echo "  rotation means issuing a new certificate and retiring the old one."
vault write -format=json "$PKI_MOUNT/issue/$ROLE_NAME" \
  common_name="$LEAF_CN" \
  ttl=24h > "$WORK_DIR/issue-2.json"

jq -r '.data.certificate' "$WORK_DIR/issue-2.json" > "$WORK_DIR/leaf-rotated.crt"
jq -r '.data.serial_number' "$WORK_DIR/issue-2.json" > "$WORK_DIR/serial-2.txt"
SERIAL_TWO="$(cat "$WORK_DIR/serial-2.txt")"
log "Fresh certificate issued. Serial: $SERIAL_TWO"
openssl verify -CAfile "$WORK_DIR/ca.crt" "$WORK_DIR/leaf-rotated.crt"
log "Rotated certificate verifies against the root CA."

# ---------------------------------------------------------------------------
# 8. Revoke the original certificate and confirm it is on the CRL
# ---------------------------------------------------------------------------
echo ""
echo "[8/9] Revoking original certificate ($SERIAL_ONE)..."
vault write "$PKI_MOUNT/revoke" serial_number="$SERIAL_ONE"
log "Revocation request accepted."

echo ""
echo "  -- Confirming the serial appears on the CRL..."
vault read -format=json "$PKI_MOUNT/crl" > "$WORK_DIR/crl.json"
jq -r '.data.crl' "$WORK_DIR/crl.json" > "$WORK_DIR/crl.pem"
CRL_TEXT="$(openssl crl -in "$WORK_DIR/crl.pem" -noout -text)"
if echo "$CRL_TEXT" | grep -qi "$(echo "$SERIAL_ONE" | tr -d ':')"; then
  log "Confirmed — serial $SERIAL_ONE is listed on the CRL."
else
  # Fall back to comparing colon-separated form before failing.
  NORMALIZED="$(echo "$SERIAL_ONE" | tr '[:upper:]' '[:lower:]')"
  if echo "$CRL_TEXT" | tr '[:upper:]' '[:lower:]' | grep -q "$NORMALIZED"; then
    log "Confirmed — serial $SERIAL_ONE is listed on the CRL."
  else
    die "Serial $SERIAL_ONE not found on the CRL"
  fi
fi

# ---------------------------------------------------------------------------
# 9. List the remaining certificates
# ---------------------------------------------------------------------------
echo ""
echo "[9/9] Listing certificates on $PKI_MOUNT/..."
if vault list "$PKI_MOUNT/certs"; then
  log "Certificate list retrieved."
else
  log "No certificate list available (all entries may be expired or removed)."
fi

echo ""
echo "=== PKI Workflow Complete ==="
echo "  Root CA:   $WORK_DIR/ca.crt"
echo "  Retired:   $WORK_DIR/leaf.crt (serial $SERIAL_ONE, revoked)"
echo "  Current:   $WORK_DIR/leaf-rotated.crt (serial $SERIAL_TWO)"
echo "  CRL:       $WORK_DIR/crl.pem"
echo ""
echo "Next: point a service at leaf-rotated.crt/leaf.key, and re-run step 7"
echo "on your rotation schedule instead of trying to renew in place."
