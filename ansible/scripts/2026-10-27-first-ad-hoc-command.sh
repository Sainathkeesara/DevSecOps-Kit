#!/usr/bin/env bash
# last_verified: 2026-10-27 · ansible n/a

# First ad-hoc command against a local inventory.
# inventory.ini: [web]\nlocalhost ansible_connection=local
ansible -i inventory.ini web -m ping
ansible -i inventory.ini web -m command -a "uptime"
