#!/usr/bin/env bash
# last_verified: 2026-07-16 · ansible

# bootstrap.sh — install Python on a target node so Ansible can run
# Ansible needs Python on the target; this gets it there fast
# Usage: ./scripts/ansible/bootstrap.sh <user@host>

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <user@host>"
  exit 1
fi

echo "[*] Bootstrapping $TARGET"
ssh "$TARGET" "sudo apt update && sudo apt install -y python3"
