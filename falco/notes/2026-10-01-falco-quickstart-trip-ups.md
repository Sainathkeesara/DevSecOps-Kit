---
last_verified: 2026-10-01
tool_version: n/a
---

# Falco quickstart — what tripped me up

> Following the official Falco quickstart and writing down the four things that actually stopped me.

## The path I took

The quickstart starts with the Helm chart, so that's what I did:

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco -n falco-system --create-namespace
```

Then I just sat and watched:

```bash
kubectl -n falco-system get pods -w
```

## What tripped me up

### 1. It picks a driver for me, and the one it picked wouldn't load

The quickstart says Falco selects the best available driver automatically. On the older kernel my test node was running, the eBPF probe would not load — the pod logs said roughly that the BPF probe wasn't supported on that kernel, and the DaemonSet went to CrashLoopBackOff. Nothing in the main quickstart body flagged that I'd need to intervene, so I lost a while reading crash logs instead of the install page.

Pinning the legacy driver is what unblocked me, either in a values file:

```yaml
driver:
  kind: kmod
```

or at install time:

```bash
helm install falco falcosecurity/falco -n falco-system --create-namespace \
  --set driver.kind=kmod
```

I should have set the driver on the first install rather than the third.

### 2. The default rules fire on my own `kubectl exec`

Once it was running, the log was flooded with "Shell spawned in container" every time I opened a debug session into a pod. The default rules have no exception for that, and my own tooling was generating most of the noise.

I added an exception in a custom rules ConfigMap. The thing I got wrong first time was leaving out `condition` — Falco evaluates an exception against its condition, so an entry with only `fields`/`values` sits there inert and suppresses nothing:

```yaml
# custom-rules.yaml
- rule: Shell Spawned In Container
  exceptions:
    - name: kubectl-exec
      condition: proc.name = kubectl and user.name = my-user
```

Then redeployed with the chart's custom-rules keys. The name of the ConfigMap goes in `customRules.configmap` — not `customRules.name`, which I tried first and the chart ignored:

```bash
helm upgrade falco falcosecurity/falco -n falco-system \
  --set customRules.enabled=true \
  --set customRules.configmap=falco-custom-rules
```

### 3. Terminal output is text, and I wanted JSON

The quickstart shows text output in the terminal, which is fine for watching. As soon as I wanted to ship those events anywhere I needed JSON instead, and the chart doesn't turn that on for you:

```yaml
falco:
  json_output: true
  json_include_output_property: true
```

### 4. There's no built-in Slack output

This one cost me the most time because I assumed Falco ships with a webhook. It doesn't — the quickstart stops at "watch the logs in `kubectl logs`". Forwarding events to Slack, or anywhere else, is a separate component (falcosidekick) that you deploy yourself. It's reachable through the chart under the sidekick values, and I had the path wrong twice before it worked — the webhook URL lives under `config.slack.webhookUrl` inside the sidekick block, not at the top level with a lowercased field name:

```yaml
falco:
  falcosidekick:
    enabled: true
    config:
      slack:
        webhookUrl: "https://hooks.slack.com/services/..."
```

## What I'd try next

- Write a rule that flags `curl`/`wget` reaching out from a container
- Get the sidekick actually posting to a test Slack webhook, so I can see the event shape end to end
- Retry the newer driver on a current kernel so I'm not pinned to the legacy one
