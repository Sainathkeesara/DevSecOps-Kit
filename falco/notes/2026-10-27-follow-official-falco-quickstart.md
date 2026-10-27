---
last_verified: 2026-10-27
tool_version: n/a
---

# Falco quickstart — what tripped me up

I installed Falco and ran the quickstart. Mostly smooth, but a few things bit me.

## Steps I followed
1. Installed via the official package repo on Ubuntu.
2. Started the systemd service; checked `systemctl status falco`.
3. Ran `falco` in the foreground to see events.

## Got stuck on
- Kernel module vs eBPF: my kernel headers were missing, so the module build failed. Switching to the eBPF driver with `falco -o engine.kind=ebpf` worked.
- Rule files live under `/etc/falco/rules.d/` and the default rules are noisy on a busy dev box; I had to tune `falco_rules.yaml`.

## What I'd try next
- Write a custom rule to detect a shell spawned in a container.
- Pipe Falco events to Falcosidekick for alerting.
