---
last_verified: 2026-09-19
tool_version: n/a
---

# Falco rule optimization patterns — reducing noise with priority-based filtering

## Purpose

Default Falco rulesets are written for broad coverage, so on a busy cluster they emit far more alerts than a responder can triage. This guide describes repeatable optimization patterns that keep detection value while cutting noise: centralizing match values in lists, extracting repeated conditions into macros, ordering conditions cheap-first, overriding rule priority instead of duplicating rules, and routing output by priority tier.

## When to use

- Alert volume from a small set of rules dominates the event stream and most firings trace to known-legitimate workloads.
- The team wants `Warning` and above to page while `Informational` stays searchable in logs.
- Rules are maintained as a custom layer on top of vendor defaults rather than edits to the defaults file itself.

## Prerequisites

- Falco installed with a custom rules file loaded after the defaults (custom file referenced in the Falco configuration).
- Access to recent Falco output (stdout log or forwarded events) so the noisiest rules can be ranked before tuning.
- Ability to reload or restart Falco to apply rule changes in a non-production test namespace first.

## Steps

### 1. Rank the noisiest rules before changing anything

Count firings per rule over a fixed window and record the baseline. Rank by count, then annotate each with the workload that triggers it and whether that workload is expected.

```bash
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=5000 \
  | grep -oP 'Rule=\S+' \
  | sort | uniq -c | sort -rn
```

Tune only the top offenders first. Rules that fire rarely but carry high severity are left untouched.

### 2. Centralize match values in lists

When several rules match against the same set of binaries, image names, or paths, move those values into a named list so there is one place to update.

```yaml
- list: trusted_sidecars
  items: [fluent-bit, vector, logstash]

- macro: is_trusted_sidecar
  condition: proc.name in (trusted_sidecars)
```

Adding a new sidecar means editing the list, not every rule. Lists also make review easier because the allowlist is visible in one block.

### 3. Extract repeated conditions into macros

If the same `container and not <exclusion>` fragment appears in five rules, extract it once. The rule body then states intent instead of repeating plumbing.

```yaml
- macro: spawned_shell_in_container
  condition: >
    evt.type = execve
    and proc.name in (sh, bash)
    and container

- rule: Shell spawned inside container
  desc: Detect interactive shells started in a running container
  condition: spawned_shell_in_container and not is_trusted_sidecar
  output: Shell in container (proc=%proc.name container=%container.name)
  priority: WARNING
```

A companion example of minimal shell-in-container detection lives in the existing tuned-rules walkthrough under the same `falco/docs/` directory.

### 4. Order conditions cheap-first

Falco evaluates the condition left to right. Place the cheapest, most selective test first so non-matching events short-circuit early: event type, then process name, then container scope, then expensive field comparisons last.

```yaml
# Preferred: selective event-type check first
condition: >
  evt.type = openat
  and fd.name in (sensitive_paths)
  and container
  and not is_trusted_sidecar
```

Avoid leading with a broad `container` check followed by a long alternation; every event pays the cost of the alternation before filtering.

### 5. Override priority instead of duplicating the rule

To quiet a rule without losing it, override its priority in the custom file rather than copying the whole rule. Keep the original condition intact so future default updates still apply.

```yaml
- rule: Read sensitive file trusted
  priority: INFO
```

Reserve `WARNING` and above for actions that need a human. Demoted rules remain in logs for forensics but stop driving alert routing. Verify whether the local setup requires a full rule replacement or supports a priority-only override, and test the result before rolling out.

### 6. Route output by priority tier

Configure the output path so only `Warning` and above reaches the alert channel while everything stays in pod logs. Conceptually:

- `Informational` and below: retained in Falco pod logs for search and forensics.
- `Warning` and above: forwarded to the webhook or alert pipeline.

This single routing change typically removes the largest share of noise, because demoted rules no longer page.

## Verify

1. Re-run the ranking command from Step 1 over the same window length and compare per-rule counts against the baseline.
2. Trigger one known-legitimate action (for example, the sidecar write covered by an exclusion) and confirm no alert is emitted.
3. Trigger one known-suspicious action in a test pod (for example, spawning an unexpected shell) and confirm a `Warning`-level alert still fires.
4. Run a rule syntax check or a Falco dry validation in the test namespace before promoting the custom file to the rest of the fleet.

## Common errors

- **Exception fields that the rule never uses.** An exclusion referencing fields absent from the rule condition is silently ignored. Read the original rule definition and reuse its fields.
- **Priority override that does not take effect.** Some setups require replacing the rule body rather than appending a priority line. If the severity in output is unchanged after reload, the override form is wrong for that installation.
- **Over-broad exclusions.** Excluding an entire image repository because one tag is noisy suppresses genuine detections from sibling tags. Scope exclusions to the exact binary and path observed.
- **Tuning without a baseline.** Changing three rules at once with no before-count makes it impossible to tell which change helped. Change one pattern, re-measure, then continue.

## References

- Companion walkthrough in this repo: `falco/docs/tuned-falco-rules-noise-reduction.md` (baseline ranking and exception workflow).
- Companion concept note in this repo: `falco/docs/syscall-vs-tracepoint-rules.md` (event-source background for condition design).
