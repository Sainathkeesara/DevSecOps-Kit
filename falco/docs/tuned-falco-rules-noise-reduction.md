---
last_verified: 2026-07-06
tool_version: n/a
---

# How I tuned Falco rules to reduce noisy alerts

> A practical walkthrough of identifying the noisiest Falco rules, adding exceptions, lowering priority levels, and verifying the changes before deploying to a cluster.

## Purpose

Out of the box, Falco ships with dozens of default rules covering everything from shell execution to file system writes. In a busy cluster, these rules fire constantly — every `kubectl exec`, every `apt-get` during a build, every Helm chart that mounts a `hostPath`. Without tuning, the signal-to-noise ratio makes it impossible to spot actual threats.

This doc covers three rounds of tuning I went through on a medium-sized cluster (roughly 40 pods across several node groups). The approach cut alert volume by about 80% while keeping the rules that actually matter.

## Steps

### 1. Collect baseline stats

Before changing anything, I dumped the current alert count per rule from the Falco output. If alerts go to stdout (the default in the Helm chart), you can grep the logs:

```bash
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=5000 \
  | grep -oP 'Rule=\S+' \
  | sort | uniq -c | sort -rn
```

In my cluster the top offenders over 24 hours were:

- **Write below monitored dir** — the most frequent, around 2,400 firings
- **Sensitive mount detected** — roughly 800 firings
- **Read sensitive file trusted** — roughly 600 firings
- **Redirect stdout/stderr to logfile** — roughly 450 firings

### 2. Identify false-positive patterns

For each noisy rule, I checked what workload triggered it and whether it was genuinely suspicious:

- **Write below monitored dir** — Helm and node-agent pods write to `/etc` and `/var/run`. Legitimate infrastructure traffic, not a compromise.
- **Sensitive mount detected** — The monitoring stack (Prometheus node-exporter, metrics collectors) mounts `/proc` and `/sys` by design. Expected behaviour.
- **Redirect stdout/stderr** — Logging sidecar containers redirect stdout as part of normal operation. This rule fires on every deployment.

### 3. Add exceptions

Falco rules support an `exceptions` field to suppress alerts for known safe conditions. I added exceptions by overriding default rules in a custom rules file:

```yaml
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

I found that the exception fields must match fields the rule actually uses in its condition. If they don't, the exception silently does nothing. The only way to verify is to read the original rule definition.

### 4. Lower priority for known-safe rules

Some rules are useful to know about but don't need to page anyone. I moved them from `Warning` to `Informational`:

```yaml
- rule: Read sensitive file trusted
  priority: INFO
```

This keeps them in the logs for forensic purposes but stops them from triggering alert routing. One thing that tripped me up: you can't change the priority of a default rule by appending — the append only covers the original fields. For priority changes, I had to replace the rule entirely (remove `append: true` and rewrite the condition).

### 5. Use priority-based output routing

The Falco Helm chart lets you filter output by minimum priority. I configured it so only `Warning` and above goes to the webhook, while everything else stays in pod logs:

```yaml
falco:
  priority: info
  alert_rule_priority: warning
```

This is where most of the noise reduction came from — roughly 60% of alerts became `info` after the priority adjustments.

## Verify

### Compare before / after count

After applying the changes, I let the cluster run for an hour and compared alert counts using the same grep command:

```bash
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=2000 \
  | grep -oP 'Rule=\S+' \
  | sort | uniq -c | sort -rn
```

The top offender dropped from ~2,400 to ~200 firings per 24 hours.

### Test a known-bad action

I verified that the rules still fire for genuinely suspicious activity by exec'ing into a test pod and running something unexpected:

```bash
kubectl exec -n test -it alpine -- sh -c "curl http://malicious.example.com"
```

This triggered the networking and process rules and produced a `Warning`-level alert. If it hadn't, the exception would be too broad.

### Test that exceptions are working

For each exception I added, I triggered the safe action and confirmed no alert was raised:

```bash
kubectl exec -n logging -it fluent-bit-xyz -- sh -c "echo test > /var/log/test.log"
```

No alert fired — the logging sidecar writing its own logs is legitimately excepted.
