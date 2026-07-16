#!/usr/bin/env bash
# last_verified: 2026-07-16 · ansible

# deploy.sh — run an Ansible playbook against an environment
# I just want the simplest possible deploy wrapper
# Usage: ./scripts/pipeline/deploy.sh <inventory> <playbook>

INVENTORY="${1:-inventory/prod.ini}"
PLAYBOOK="${2:-playbooks/site.yml}"

echo "[*] Running ansible-playbook -i $INVENTORY $PLAYBOOK"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --check
