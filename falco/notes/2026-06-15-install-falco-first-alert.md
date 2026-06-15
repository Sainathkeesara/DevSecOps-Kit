# Installing Falco and triggering my first security alert

I followed the Falco install docs to get it running on my Ubuntu 22.04 node. I already had a Kubernetes cluster handy, so I went the Helm route.

## Steps that worked

Added the Falcosecurity Helm repo and installed the chart:

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm install falco falcosecurity/falco \
  --namespace falco --create-namespace \
  --set driver.kind=ebpf
```

The eBPF driver loaded without needing kernel headers — that was a pleasant surprise. Checked the logs to confirm it started:

```bash
kubectl -n falco logs -l app.kubernetes.io/name=falco --tail=20
```

Saw the driver loaded message and a few initial rule evaluations. To trigger an alert, I ran a test pod and exec'd into it:

```bash
kubectl run test-pod --image=nginx
kubectl exec -it test-pod -- bash
```

Falco caught it right away — the alert showed up in the pod logs:

```
15:22:34.567891234: Warning Shell spawned in container k8s_pod_test-pod_default (id=abc123)
```

I piped the output through `jq` to see the structured alert (`-o json` in Falco's config) — it included the user, command, container ID, and image tag.

## Got stuck on

- The default Falco ruleset is **noisy** for local development. Every `kubectl exec` I ran fired a `Shell spawned in container` alert, including my own debug sessions. I added an exception for my user by mounting a custom rules file via Helm values:

```yaml
# custom-rules.yaml
customRules:
  rules_custom.yaml: |-
    - rule: Shell Spawned In Container
      exceptions:
        - name: kubectl_exec
          fields: [proc.name, user.name]
          values:
            - [kubectl, my-admin-user]
          comparator: "in"
```

Installed with:

```bash
helm upgrade falco falcosecurity/falco -n falco -f custom-rules.yaml
```

- The `driver.kind=ebpf` flag didn't work on my first try because the node didn't have CONFIG_DEBUG_INFO_BTF enabled. Switched to `driver.kind=module` (kernel module) as a fallback and it worked. The eBPF fallback message in the logs was clear enough to diagnose.
- I initially forgot to set `--namespace falco` on my `kubectl logs` and got "no resources found". The chart creates the namespace but the Helm install output doesn't remind you to scope your kubectl commands.

## What I'd try next

Write a rule that flags outbound curl calls from containers — that could catch data exfiltration. Also want to wire alerts to a webhook endpoint so they show up in Slack instead of only in pod logs.