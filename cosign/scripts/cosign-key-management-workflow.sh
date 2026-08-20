#!/usr/bin/env bash
# last_verified: 2026-08-20 · cosign n/a
set -euo pipefail

KEY_DIR="${1:-.}"
ACTION="${2:-}"

generate_key() {
  local keydir="$1"
  echo "[generate] Creating key pair in ${keydir}..."
  mkdir -p "${keydir}"
  pushd "${keydir}" >/dev/null
  cosign generate-key-pair
  popd >/dev/null
  echo "[generate] Done. Keys at ${keydir}/cosign.key and ${keydir}/cosign.pub"
}

sign_with_key() {
  local keydir="$1"
  local image="$2"
  echo "[sign] Signing ${image} with ${keydir}/cosign.key..."
  cosign sign --key "${keydir}/cosign.key" "${image}"
  echo "[sign] Signature attached."
}

rotate_key() {
  local old_dir="$1"
  local image="$2"
  local new_dir="${old_dir}.new"

  echo "[rotate] Generating new key pair in ${new_dir}..."
  mkdir -p "${new_dir}"
  pushd "${new_dir}" >/dev/null
  cosign generate-key-pair
  popd >/dev/null

  echo "[rotate] Re-signing ${image} with new key..."
  cosign sign --key "${new_dir}/cosign.key" "${image}"

  echo "[rotate] Removing old key files from ${old_dir}..."
  rm -f "${old_dir}/cosign.key" "${old_dir}/cosign.pub"

  echo "[rotate] Complete. New key stored in ${new_dir}/"
}

revoke_key() {
  local keydir="$1"
  echo "[revoke] Deleting key files from ${keydir}..."
  rm -f "${keydir}/cosign.key" "${keydir}/cosign.pub"
  echo "[revoke] Key files removed. Re-sign the image with a fresh key to fully replace the signature."
}

case "${ACTION}" in
  generate) generate_key "${KEY_DIR}" ;;
  rotate)   rotate_key   "${KEY_DIR}" "ghcr.io/myorg/myapp:latest" ;;
  revoke)   revoke_key   "${KEY_DIR}" ;;
  *)
    cat <<EOF
Cosign key management workflow
Usage: $0 <key-dir> <generate|rotate|revoke>

  generate  Create a new cosign key pair
  rotate    New key -> re-sign image -> delete old key files
  revoke    Delete key files (re-sign to fully replace)
EOF
    exit 1
    ;;
esac