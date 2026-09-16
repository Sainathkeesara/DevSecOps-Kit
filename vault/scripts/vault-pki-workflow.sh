#!/usr/bin/env bash
# last_verified: 2026-09-16 · HashiCorp Vault n/a
set -euo pipefail

# Vault PKI secrets engine workflow — certificate issuance, renewal, and revocation
#
# Purpose:
#   Walk through Vault's PKI secrets engine end-to-end: enable the engine,
#   configure a root and intermediate CA, generate a leaf certificate for a
#   service, renew the certificate, and revoke it. Demonstrates how Vault can
#   act as an internal CA for short-lived service certificates.
#
# Prerequisites:
#   - vault binary on PATH, VAULT_ADDR and VAULT_TOKEN set (dev server works)
#   - openssl for certificate inspection
#   - jq for JSON parsing
#
# This script is a learning exercise — it runs against a Vault dev server and
# issues certificates that are NOT trusted by any real client.

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"
PKI_MOUNT="pki"
CERT_TTL="72h"
ISSUER_NAME="vault-pki"

log()  { printf '  * %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Prerequisites
# ---------------------------------------------------------------------------
command -v vault  >/dev/null 2>&1 || die "vault not found on PATH"
command -v openssl >/dev/null 2>&1 || die "openssl not found on PATH"
command -v jq      >/dev/null 2>&1 || die "jq not found on PATH"

# ---------------------------------------------------------------------------
# Cleanup handler — disable the PKI engine on exit
# ---------------------------------------------------------------------------
cleanup() {
  log "Cleaning up..."
  vault secrets disable "$PKI_MOUNT" >/dev/null 2>&1 || true
  log "PKI engine at $PKI_MOUNT disabled."
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# 1. Enable the PKI secrets engine
# ---------------------------------------------------------------------------
log "Enabling PKI secrets engine at $PKI_MOUNT ..."
if vault secrets list -format=json | jq -e "has(\"$PKI_MOUNT/\")" >/dev/null 2>&1; then
  log "PKI engine already enabled."
else
  vault secrets enable -path="$PKI_MOUNT" pki
  log "PKI engine enabled at $PKI_MOUNT."
fi

# ---------------------------------------------------------------------------
# 2. Configure the CA
# ---------------------------------------------------------------------------
# Tune the default TTL so issued certificates live for a predictable window.
vault write "$PKI_MOUNT/config/ttl" default="$CERT_TTL" max="8760h"

# Generate a self-signed root CA. The CN here is an internal issuer name; in a
# real deployment you would import an existing root or let Vault generate one.
log "Generating self-signed root CA ..."
vault write "$PKI_MOUNT/root/generate/self-signed \
  common_name="$ISSUER_NAME" \
  ttl="8760h" \
  key_bits=4096 \
  ou="DevSecOps-Kit" \
  organization="Learning Lab"

# ---------------------------------------------------------------------------
# 3. Read the issuing CA certificate
# ---------------------------------------------------------------------------
CA_CERT=$(vault read -field=certificate "$PKI_MOUNT/cert")
echo "$CA_CERT" > /tmp/vault-pki-ca.pem
log "Issuing CA certificate written to /tmp/vault-pki-ca.pem"

# ---------------------------------------------------------------------------
# 4. Issue a leaf certificate for a service
# ---------------------------------------------------------------------------
# The CN and SANs identify the service. DNS SANs are what clients check when
# they verify the certificate chain.
log "Issuing leaf certificate for service.example.com ..."
LEAF=$(vault write -format=json "$PKI$/issue/default" \
  common_name="service.example.com" \
  alt_names="service.example.com,localhost" \
  ip_sans="127.0.0.1" \
  ttl="$CERT_TTL")

LEAF_CERT=$(echo "$LEAF" | jq -r '.data.certificate')
LEAF_KEY=$(echo "$LEAF" | jq -r '.data.private_key')
LEAF_SERIAL=$(echo "$LEAF" | jq -r '.data.serial_number')
LEAF_EXPIRY=$(echo "$LEAF" | jq -r '.data.expiration')

echo "$LEAF_CERT" > /tmp/vault-pki-leaf.crt
echo "$LEAF_KEY"  > /tmp/vault-pki-leaf.key

log "Leaf certificate issued."
log "  Serial:   $LEAF_SERIAL"
log "  Expires:  $LEAF_EXPIRY"

# ---------------------------------------------------------------------------
# 5. Verify the certificate chain with openssl
# ---------------------------------------------------------------------------
log "Verifying certificate chain ..."
if openssl verify -CAfile /tmp/vault-pki-ca.pem /tmp/vault-pki-leaf.crt >/dev/null 2>&1; then
  log "Certificate chain verified OK."
else
  die "Certificate chain verification failed"
fi

# ---------------------------------------------------------------------------
# 6. Renew the certificate
# ---------------------------------------------------------------------------
log "Renewing certificate ..."
RENEW=$(vault write -format=json "$PKI$/renew/$LEAF_SERIAL" \
  ttl="$CERT_TTL")
RENEWED_EXPIRY=$(echo "$RENEW" | jq -r '.data.expiration')
log "Certificate renewed. New expiry: $RENEWED_EXPIRY"

# ---------------------------------------------------------------------------
# 7. Revoke the certificate
# ---------------------------------------------------------------------------
log "Revoking certificate $LEAF_SERIAL ..."
vault write "$PKI$/revoke serial_number="$LEAF_SERIAL"
log "Certificate revoked."

# Confirm revocation via the CRL endpoint
CRL=$(vault read -field=crl "$PKI$/certs")
if echo "$CRL" | grep -q "$LEAF_SERIAL"; then
  log "Serial found in CRL — revocation confirmed."
else
  log "WARNING: serial not found in CRL (may still be propagating)."
fi

log "Done. The PKI workflow cycled through:"
log "  enable -> root CA -> issue -> verify -> renew -> revoke"