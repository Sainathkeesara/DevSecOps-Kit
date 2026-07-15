---
last_verified: 2026-07-15
tool_version: n/a
---

# Exploring Kubernetes — pods, deployments, services, namespaces

I finally pointed `kubectl` at a cluster and started poking around. First thing I ran was `kubectl get pods` and got back `No resources found in default namespace.` — which actually told me the tool was working, just empty.

## What I saw

- **Pods** are the smallest thing you run. I made one with a manifest (see `../manifests/2026-07-15-first-pod-service.yaml`) and it showed up as `Running`. A pod can hold more than one container, but I kept it to one for now.
- **Deployments** wrap pods with a desired replica count. `kubectl create deployment hello --image=nginx` gave me a deployment that spawned a pod on its own. I liked this more than hand-writing pods.
- **Services** are how pods get a stable address. My `ClusterIP` service lets other things inside the cluster reach the pod on port 80 without caring which node it landed on.
- **Namespaces** are just folders for resources. Everything I made landed in `default` until I tried `kubectl get pods -n kube-system` and saw a ton of system pods I didn't create.

## Commands I kept using

```bash
kubectl get pods,svc,deploy        # what's running
kubectl describe pod hello-pod     # why is it pending?
kubectl logs hello-pod             # what did nginx print?
kubectl delete -f first-pod-service.yaml
```

## What tripped me up

`kubectl apply` vs `kubectl create` confused me at first — apply is declarative (it fixes what's there), create is one-shot. I also forgot pods die when a node reboots unless a deployment owns them, so I'll use deployments next time.
