#!/usr/bin/env bash
# last_verified: 2026-07-04 · ansible 2.15.x

# Bootstrap script for target node preparation
# Prepares a Linux node for Ansible automation by installing Python and required packages

TARGET_HOST="$1"
TARGET_USER="${2:-root}"

echo "[INFO] Bootstrapping target: $TARGET_HOST as $TARGET_USER"

# Install Python 3 (required for Ansible modules)
ssh "$TARGET_USER@$TARGET_HOST" "apt-get update && apt-get install -y python3 python3-pip"

# Install basic packages often needed by Ansible modules
ssh "$TARGET_USER@$TARGET_HOST" "apt-get install -y curl wget git"

# Enable passwordless sudo for Ansible user
ssh "$TARGET_USER@$TARGET_HOST" "echo '$TARGET_USER ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

echo "[INFO] Target $TARGET_HOST ready for Ansible automation"