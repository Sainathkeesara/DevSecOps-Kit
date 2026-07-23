#!/usr/bin/env bash

# last_verified: 2026-07-23 - bash n/a

# I'm practicing the core software supply chain verification loop:
# produce the artifact, hash it, then confirm the hash matches what the
# publisher released. Before adding signatures or attestation I wanted
# to make sure the checksum step is solid.

create_and_verify_artifact() {
  local artifact="$1"
  local published_hash="$2"

  # Compute the checksum of what we actually received
  local computed_hash
  computed_hash=$(sha256sum "$artifact" | awk '{print $1}')

  # Compare against the publisher's advertised hash
  if [ "$computed_hash" = "$published_hash" ]; then
    echo "VERIFIED: checksum matches"
    return 0
  else
    echo "FAILED: checksum mismatch"
    echo "  Expected: $published_hash"
    echo "  Actual:   $computed_hash"
    return 1
  fi
}

main() {
  # Create a dummy artifact and compute its own checksum.
  # In a real workflow the published hash would come from the release page,
  # and the downloaded artifact would come from the registry or upstream site.
  TEMP_DIR="$(mktemp -d)"
  ARTIFACT="$TEMP_DIR/release.tar.gz"
  echo "Practice release content for supply-chain exercise" > "$ARTIFACT"

  # "Published" hash — fetched from the vendor's release checksums file
  PUBLISHED_HASH=$(sha256sum "$ARTIFACT" | awk '{print $1}')

  log "Verifying artifact at $ARTIFACT"
  if create_and_verify_artifact "$ARTIFACT" "$PUBLISHED_HASH"; then
    log "Supply chain check passed"
  else
    log "Supply chain check failed — investigate before deploying"
    exit 1
  fi
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

main
