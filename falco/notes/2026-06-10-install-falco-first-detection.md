# My first Falco install and detection

## What happened
I followed the Falco install docs and got the DaemonSet running. The eBPF driver loaded on my Ubuntu 22.04 node without any kernel headers — surprise, that worked out of the box.

## Steps that worked
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm install falco falcosecurity/falco -n falco --create-namespace
kubectl -n falco logs -l app=falco
```
I ran a test container and exec'd into it with bash. Falco caught it immediately:
```
10:15:22.123456789: Warning Shell spawned in container k8s_pod_test-pod_default (id=abc123)
```

## What tripped me up
The default alert threshold was noisy — every `kubectl exec` fired an alert, including my own debugging. I added an exception for my user account:
```yaml
# In falco_rules.yaml
- rule: Shell Spawned In Container
  exceptions:
    - name: kubectl exec
      fields: [proc.name, user.name]
      values: [kubectl, my-admin-user]
      comparator: "in"
```

## What I'd try next
I want to write a rule that detects if someone runs `curl` to send data outside the cluster. Also should wire Falco alerts to a webhook that hits my local Slack test channel.
