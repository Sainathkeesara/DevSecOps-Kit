#!/usr/bin/env bash
# last_verified: 2026-08-04 · ansible n/a
# Bootstrap a target node for Ansible management.

apt-get update -qq
apt-get install -y -qq openssh-server python3

mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh

echo "Bootstrap complete — node ready for Ansible."