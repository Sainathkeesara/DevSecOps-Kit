# How I tuned Falco rules to reduce noisy alerts

> A practical walkthrough of identifying the noisiest Falco rules, adding exceptions, lowering priority levels, and verifying the changes before deploying to the cluster.

## Purpose

Out of the box, Falco ships with dozens of default rules that cover everything from shell execution to file system writes. In a busy cluster, these rules fire constantly — every `kubectl exec`, every `apt-get` during a build, every Helm chart that mounts a `hostPath`. Without tuning, the signal-to-noise ratio makes it impossible to spot actual threats.

I went through three rounds of tuning on a production-like cluster (EKS, ~40 pods across 5 node groups) and cut alert volume by roughly 80% while keeping the rules that matter.

## When to tune

- The default `Warning` alerts are arriving faster than you can triage them.
- A specific rule fires dozens of times a day for the same known workload.
- Platform teams report that Falco alerts are being ignored because they're always noisy.

## Steps

### 1. Collect baseline stats

Before making changes, I dumped the current alert count per rule from the Falco output. If you're sending alerts to stdout (via the Falco Helm chart's default output), you can grep the logs:

```bash
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=5000 \
  | grep -oP 'Rule=\S+' \
  | sort | uniq -c | sort -rn
```

This gives you a ranked list of the most frequent rule firings. In my cluster, the top offenders were:

| Rule | Firings (24h) | Priority |
|------|---------------|----------|
| `Write below monitored dir` | ~2,400 | Warning |
| `Sensitive mount detected` | ~800 | Warning |
| `Read sensitive file trusted` | ~600 | Warning |
| `Redirect stdout/stderr to logfile` | ~450 | Warning |

### 2. Identify false-positive patterns

For each noisy rule, I checked what workload was triggering it and whether it was legitimate:

- **Write below monitored dir** — Helm and node-agent pods frequently write to `/etc` and `/var/run`. Legitimate infra traffic, not compromise.
- **Sensitive mount detected** — The monitoring stack (Prometheus, node-exporter) mounts `/proc` and `/sys` by design. Expected behavior.
- **Redirect stdout/stderr** — Our logging sidecar containers redirect stdout. This rule fires on every deployment.

### 3. Add exceptions

Falco rules support an `exceptions` field that lets you suppress alerts for known, safe conditions. I added exceptions to the default rules by overriding them in a custom rules file:

```yaml
# custom-rules.yaml — Deployed via Helm values: falco.rulesFiles
- rule: Write below monitored dir
  exceptions:
    - name: helm_secrets
      fields: [proc.name, fd.directory]
      values:
        - [helm, /etc/helm]
        - [vault-agent, /var/run/vault]
        - [node-exporter, /var/run/node_exporter]
      comparator: "in"

- rule: Redirect stdout/stderr to logfile
  exceptions:
    - name: logging_sidecars
      fields: [container.image.repository, proc.name]
      values:
        - [fluent-bit, sh]
        - [logstash, java]
        - [vector, vector]
      comparator: "in"
```

### 4. Lower priority for known-safe rules

Some rules are useful to know about but don't need to page anyone. I moved them from `Warning` to `Informational` or `Debug`:

```yaml
- rule: Read sensitive file trusted
  priority: INFO
```

This keeps them visible in the logs for forensic purposes but stops them from triggering alert routing.

### 5. Use priority-based output routing

The Falco Helm chart lets you filter output by minimum priority. I configured it so only `Warning` and above goes to Slack, while everything else stays in the pod logs:

```yaml
# falco Helm values.yaml
falco:
  outputs:
    rate: 0
    max_burst: 1000
  priority: info  # logs everything at info+
  alert_rule_priority: warning  # only warning+ → webhook/Slack
```

This is where most of the noise reduction came from — roughly 60% of alerts were `info` after the priority adjustments.

## Verify

### Compare before/after count

After applying the changes, I let the cluster run for an hour and compared the alert count:

```bash
# After tuning
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=2000 \
  | grep -oP 'Rule=\S+' \
  | sort | uniq -c | sort -rn
```

Expected outcome: the top offender dropped from ~2,400 to ~200 firings per 24h.

### Test a known-bad action

I verified that the rules still fire for genuinely suspicious activity by exec'ing into a test pod and running an unexpected command:

```bash
kubectl exec -n test -it alpine -- sh -c "curl http://malicious.example.com"
```

This should still trigger the networking/process rules and produce a `Warning`-level alert. If it doesn't, the exception is too broad.

### Check that exceptions are working

For each exception, I triggered the safe action and confirmed no alert was raised:

```bash
kubectl exec -n logging -it fluent-bit-xyz -- sh -c "echo test > /var/log/test.log"
```

No alert expected — this is the logging sidecar writing logs, which is exactly what we excepted.

## Common errors

- **Exception fields don't match the rule's condition.** If the exception references a field (like `proc.name`) that the rule doesn't use in its condition, the exception silently does nothing. I verified by reading the original rule definition in `/etc/falco/rules.d/`.
- **Helm custom rules ordering.** When using `customRules` in the Falco Helm chart, the files are loaded alphabetically. If an override doesn't take effect, the custom rules file might be loading before the default rules. I prefixed the file with `zz_` to ensure it loads last.
- **Priority changes on `append` rules.** You can't change the priority of a default rule by appending — the append only covers the original fields. For priority changes, I had to replace the rule entirely (remove the `append: true` and rewrite the condition).
- **Overly broad exceptions.** I initially excepted all of `/var/run` which suppressed alerts for a legitimate compromise that wrote to a runtime socket. I narrowed it to specific known processes.

## References

- [Falco rules syntax reference](https://falco.org/docs/rules/)
- [Falco Helm chart values](https://github.com/falcosecurity/charts/tree/master/falco)
- [Exception mechanism docs](https://falco.org/docs/reference/rules/exceptions/)
