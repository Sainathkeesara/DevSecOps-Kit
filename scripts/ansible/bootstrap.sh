#!/usr/bin/env bash
# last_verified: 2026-09-05 · ansible

# bootstrap.sh — prepare a fresh target host for Ansible
# Usage: ./scripts/ansible/bootstrap.sh [target_host]
#
# What I want this to do: get Python + sshd ready on a fresh box
# so the rest of the playbooks can run without surprises.

TARGET="${1:-localhost}"

echo "[*] bootstrapping $TARGET for Ansible"

# install python3 (Ansible needs it on the managed node)
if command -v apt >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y python3 python3-apt openssh-server
elif command -v yum >/dev/null 2>&1; then
  sudo yum install -y python3 openssh-server
else
  echo "[!] no supported package manager found — install python3 + sshd manually"
  exit 1
fi

# make sure sshd is up so ansible can connect
sudo systemctl enable --now sshd

# sanity check
python3 --version
ssh -o BatchMode=yes -o ConnectTimeout=5 "$TARGET" true && echo "[ok] ssh works" || echo "[!] ssh failed — check keys"