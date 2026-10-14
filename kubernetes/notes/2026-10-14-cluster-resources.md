---
last_verified: 2026-10-14
tool_version: n/a
---

# Poking at the cluster — what resources are even here

I ran `kubectl api-resources` today just to see what the cluster knows about. Got a huge list — way more than pods and services. I didn't expect stuff like leases and endpointslices to show up.

I tried `kubectl get all -n default` and it showed me pods, services, deployments, replicasets. Then I ran `kubectl get namespaces` and saw default, kube-system, kube-public. The kube-system one has all the cluster's own stuff in it.

What tripped me up: `get all` doesn't actually get *all* — it misses things like configmaps and secrets. I had to run `kubectl get configmaps` and `kubectl get secrets` separately. Not sure why `all` leaves those out yet.

Next I want to try `kubectl describe` on a kube-system pod to see what a real system workload looks like.
