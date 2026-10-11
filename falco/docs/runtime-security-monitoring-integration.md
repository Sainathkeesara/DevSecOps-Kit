---
last_verified: 2026-09-30
tool_version: n/a
---

# Falco runtime security monitoring integration

## Purpose

This guide describes how to wire Falco into a runtime security monitoring workflow: Falco observes workload behavior at runtime, emits structured findings, and those findings flow into the same triage path the team already uses for other runtime signals. The goal is a short, repeatable loop from detection to triage to response without operating Falco as an isolated console nobody checks.

## When to use

- The cluster already runs Falco and the team wants its findings to reach responders instead of sitting in pod logs.
- Alert routing needs to distinguish routine runtime events from findings that warrant investigation.
- The team is standardizing how runtime findings are ranked, assigned, and closed, and Falco needs to fit that process rather than define its own.

## Prerequisites

- Falco installed with a custom rules layer loaded after the defaults, so tuning does not require editing vendor-supplied files.
- Access to recent Falco output for baseline comparison before changing routing.
- An existing alert destination the team already monitors (chat channel, ticket queue, or central log search) with permission to add a new source.

## Steps

### 1. Define which findings deserve human attention

Review recent Falco output and sort rules into two tiers: findings that should notify a responder, and findings that should remain searchable but not notify. Keep the notifying set small at first; an integration that pages on every runtime event gets muted within days.

A companion guide on priority-based filtering under the same `../docs/` directory walks through ranking noisy rules and demoting low-value ones before routing.

### 2. Route Falco output by tier

Configure the output path so each tier lands where it will actually be seen:

- Low tier: retained in Falco pod logs for search and forensics.
- High tier: forwarded to the alert destination from the Prerequisites.

Keep one forwarding path per tier rather than one per rule. Per-rule webhooks multiply configuration and make it hard to tell which channel is authoritative during an incident.

### 3. Attach workload context to each forwarded finding

A bare rule name is not triageable. Ensure each forwarded finding carries the workload identity needed to act: cluster and namespace, workload and pod name, container and image reference, and the process or file detail from the rule output. When context is missing, the first responder spends the investigation just locating the workload, and the same finding gets re-investigated every time it fires.

### 4. Connect findings to the response workflow

Map each high-tier rule family to a default response: who owns it, what containment looks like, and what evidence to preserve. For example, an unexpected shell in a container maps to isolating the workload and capturing pod state, while a sensitive-file read maps to reviewing the process lineage before deciding. Document the mapping next to the routing configuration so on-call does not improvise it at night.

### 5. Tune the loop on a schedule

Revisit the tier assignment whenever the workload mix changes: new sidecars, new base images, or new namespaces typically shift which rules fire. Promote rules that caught real issues, demote rules whose firings were all benign, and remove forwarding entries for workloads that no longer exist.

## Verify

1. Trigger a known-suspicious action in a non-production namespace and confirm a high-tier finding arrives at the alert destination with workload context attached.
2. Trigger a known-benign action covered by an exclusion and confirm it stays in pod logs without notifying.
3. Review the alert destination after one week and confirm the Falco share of notifications matches the tier design rather than dominating it.
4. Confirm a second responder can follow the documented mapping from finding to owner to containment step without asking the author.

## Common errors

- **Forwarding every rule to the alert channel.** Broad forwarding trains the team to ignore the channel. Start with the smallest notifying set and expand only when triage capacity allows.
- **Findings without workload identity.** A notification that names the rule but not the namespace and pod cannot be acted on. Treat missing context as a routing defect, not a minor cosmetic gap.
- **Tuning the defaults file directly.** Edits to vendor-supplied rules are lost on the next update and hide the team's intent. Keep all tier and exclusion changes in the custom layer.
- **No owner per rule family.** Unowned findings linger because each responder assumes someone else is handling them. Assign ownership when the rule is promoted to the notifying tier, not after the first incident.

## References

- Companion walkthrough in this repo: `../docs/tuned-falco-rules-noise-reduction.md` (baseline ranking and exception workflow).
- Companion reference in this repo: `../docs/rule-optimization-priority-filtering.md` (priority tiers and output routing patterns).
- Companion concept note in this repo: `../docs/syscall-vs-tracepoint-rules.md` (event-source background for rule design).
