---
last_verified: 2026-10-02
tool_version: n/a
---

# Linux production system administration runbook

## Purpose

This runbook defines the standard operating procedure for responding to a degraded or
unhealthy Linux host in production: how to triage, which signals to check in which order, how to
stabilise the host, and how to hand off. It is written for the on-call engineer who
has just been paged and needs a deterministic sequence rather than improvisation.

## When to use

Use this runbook when monitoring reports a host-level problem: sustained high load,
disk pressure, a failed service, suspected resource exhaustion, or a host that has
stopped responding to health checks. Do not use it for application-logic bugs that
leave the host itself healthy — those belong to the service runbook, not this one.

## Prerequisites

- SSH access to the affected host (or console access if SSH is unresponsive).
- A second terminal or a shared incident channel for recording observations.
- Knowledge of which services are expected to run on the host and which of them
  are safe to restart without data loss.

## Steps

### 1. Establish whether the host is reachable

Attempt a login. If SSH times out, check from the console or hypervisor whether the
machine is powered on and whether the network path is up before assuming an OS fault.
Record the outcome — "host unreachable" and "host reachable but degraded" are
different incidents with different next steps.

### 2. Check load, memory, and disk pressure

Run the three resource checks in order, because each one changes how you interpret
the others:

```bash
uptime
free -h
df -h /
```

A high load average with free memory and free disk points at CPU contention. A high
load average with exhausted memory points at swapping or the out-of-memory killer.
A full root filesystem explains a wide range of otherwise confusing service
failures, so always confirm disk before going deeper.

### 3. Identify the failed or offending service

List services that are not in their expected state and inspect the most recent
journal entries for the prime suspect:

```bash
systemctl --failed
systemctl status <service-name>
journalctl -u <service-name> --since "30 min ago" --no-pager | tail -50
```

Correlate timestamps: a service that failed two minutes after a deployment or a
configuration change is a different incident from one that has been flapping for
hours.

### 4. Stabilise

Apply the smallest intervention that restores service, in this order of
escalation: restart the failed service, then restart dependent services, then
reboot the host only if the OS itself is wedged. After each step, re-run the
checks from Step 2 and confirm the service is active before escalating further:

```bash
systemctl restart <service-name>
systemctl is-active <service-name>
```

Do not combine multiple changes at once — if the host recovers you need to know
which action recovered it.

### 5. Preserve evidence and hand off

Before closing the incident, save the relevant journal slice and the resource
readings to the incident record with timestamps, note which stabilisation step
worked, and flag anything that needs a follow-up (a filesystem that is 90% full,
a service with no restart policy, a repeat offender). An incident that ends with
"fixed it, not sure how" will page again.

## Verify

The host is considered stable when all of the following hold:

- `systemctl --failed` returns an empty list.
- Load average is back within the host's normal band for its CPU count.
- Root filesystem usage is below the alerting threshold with headroom for logs.
- The affected service answers its own health check (port, socket, or
  application endpoint — whichever the service runbook defines).

Re-check after fifteen minutes. A host that passes immediately after a restart
and degrades again has an underlying leak or a runaway job, not a one-off fault.

## Rollback

Every stabilisation action in Step 4 has an inverse:

- A restarted service can be stopped and returned to its prior state with
  `systemctl stop` / `systemctl start`, or pinned to the previous known-good
  configuration if the restart picked up a bad config change.
- A configuration edit made during the incident must be reverted from the saved
  copy taken before editing — never reconstruct the old config from memory.
- A reboot is not reversible, so treat it as the last resort and record the
  pre-reboot process table (`ps aux`) beforehand when the host is still
  responsive enough to produce one.

If the incident was triggered by a deployment or config rollout, the rollback is
owned by that change's own procedure — this runbook only restores the host, it
does not roll back the release.

## Common errors

- **Restarting services before checking disk.** A full filesystem makes every
  restart fail in confusing ways. Check `df` first, every time.
- **Reading only the tail of the log.** The cause is usually above the final
  error lines. Widen the `--since` window before concluding the log says nothing.
- **Rebooting a host that only needed a service restart.** A reboot hides the
  evidence (process state, transient logs) and takes longer. Escalate through
  the steps in order.
- **Fixing without recording.** Undocumented recoveries cannot be turned into
  monitoring or prevention. Write down the readings and the step that worked.

## References

- `../notes/2026-07-21-install-linux-vm-terminal-first-commands.md` — first-boot
  orientation: the commands an unfamiliar terminal session starts with.
- `../notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md` — scripting
  pitfalls encountered while automating routine host tasks.
