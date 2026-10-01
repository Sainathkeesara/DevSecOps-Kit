---
last_verified: 2026-10-01
tool_version: 0.40.0
sources: []
---

# Falco quickstart — what tripped me up

> Following the official Falco quickstart and writing down the things that actually stopped me.

## The quickstart path I took

The docs say to start with the Helm chart for Kubernetes. I ran:

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco -n falco-system --create-namespace
```

Then watched the pods come up:

```bash
kubectl -n falco-system get pods -w
```

## What tripped me up

### 1. Driver selection defaults to eBPF but my kernel was too old

The quickstart says "Falco automatically selects the best driver" — but on my Ubuntu 20.04 test node (kernel 5.4), the eBPF probe failed to load because it needs kernel 5.8+. The DaemonSet went into CrashLoopBackOff with:

```
falco: ERROR: failed to load BPF probe: kernel version 5.4.0 not supported
```

The fix was explicit driver selection in values.yaml:

```yaml
driver:
  kind: kmod
```

Or at install time:

```bash
helm install falco falcosecurity/falco -n falco-system --create-namespace \
  --set driver.kind=kmod
```

The quickstart mentions this in a sidebar but it's easy to miss if you just copy the one-liner.

### 2. Default rules are noisy — every `kubectl exec` fires

Once Falco was running, the logs were flooded with "Shell spawned in container" alerts. Every time I ran `kubectl exec` to debug something, Falco alerted on my own session. The default rule has no exceptions.

I added an exception for my user in a custom rules ConfigMap:

```yaml
# custom-rules.yaml
- rule: Shell Spawned In Container
  exceptions:
    - name: kubectl-exec
      fields: [proc.name, user.name]
      values: [kubectl, my-user]
      comparator: "in"
```

Then redeployed with:

```bash
helm upgrade falco falcosecurity/falco -n falco-system \
  --set customRules.enabled=true \
  --set customRules.name=falco-custom-rules
```

### 3. Output format — JSON vs text

The quickstart shows text output in the terminal, but for any real integration you need JSON. The Helm chart doesn't enable JSON output by default. I added:

```yaml
falco:
  json_output: true
  json_include_output_property: true
```

This makes the logs parseable by log shippers (Fluent Bit, Vector, etc.).

### 4. No built-in webhook — you need falcosidekick

The quickstart stops at "logs appear in kubectl logs". There's no native webhook/Slack/email output in Falco itself. You have to deploy falcosidekick as a separate component. The Helm chart has a `falcosidekick` sub-chart but it's disabled by default and the configuration is a separate values section.

```yaml
falcosidekick:
  enabled: true
  config:
    slack:
      webhookurl: "https://hooks.slack.com/services/..."
```

This wasn't obvious from the quickstart — I assumed Falco had outputs built in.

## What I'd try next

- Write a rule detecting `curl`/`wget` to external IPs from containers
- Set up falcosidekick with a test Slack webhook
- Try the modern eBPF driver on a newer kernel (5.15+) to avoid kmod