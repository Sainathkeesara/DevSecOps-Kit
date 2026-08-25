#!/bin/sh
# last_verified: 2026-08-25 · cosign n/a

set -e

if [ -n "$COSIGN_PRIVATE_KEY" ] && [ -n "$COSIGN_PUBLIC_KEY" ]; then
  echo "$COSIGN_PRIVATE_KEY" > /tmp/cosign.key
  echo "$COSIGN_PUBLIC_KEY" > /tmp/cosign.pub
  chmod 600 /tmp/cosign.key
  export COSIGN_KEY=/tmp/cosign.key
fi

if [ -n "$COSIGN_PASSWORD" ]; then
  export COSIGN_PASSWORD
fi

exec /cosign "$@"