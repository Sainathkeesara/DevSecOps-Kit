---
last_verified: 2026-07-09
tool_version: n/a
sources: []
---

# Kubernetes — quick primer

> First-day notes for someone who's never used Kubernetes. Personal voice, plain language.

## What is it?

Kubernetes is an open-source system for automating the deployment, scaling, and management of containerized applications. From what I've read, you tell it what you want your cluster to look like — "run three copies of this app, expose it on port 80, keep them healthy" — and it continuously works to make that happen. It's like a data-center operating system: instead of logging into individual servers, you operate at the cluster level.

## What does it do?

Kubernetes schedules containers onto worker nodes, monitors their health, automatically replaces failed ones, and can scale them up or down based on load. It provides built-in service discovery, load balancing, rolling updates, and secret management. I interact with it through `kubectl` commands pointing at a cluster, and everything is defined as YAML resources (Pods, Services, Deployments, etc.).

## Why does it exist?

Before Kubernetes, running apps at scale meant manually provisioning VMs, writing cron jobs for restarts, and hoping your load balancer configuration didn't drift. If a server died, someone had to notice and act. Kubernetes abstracts all of that away: it treats a fleet of machines as one logical pool and continuously reconciles reality with the desired state. It's become the standard because it handles the boring operational work so teams can focus on code.

## Key terminology

- **Cluster** — A set of machines (nodes) controlled by Kubernetes. Example: a control plane plus three worker nodes running my workloads.
- **Node** — A single machine (physical or virtual) in the cluster that runs containers. Example: an EC2 instance with the kubelet agent.
- **Pod** — The smallest deployable unit, usually wrapping one container. Example: a single Pod running the `nginx` container.
- **Deployment** — Manages a set of identical Pods, ensuring the desired count is running and updates them safely. Example: a Deployment with `replicas: 3` keeps three Nginx Pods alive.
- **Service** — A stable network endpoint that load-balances traffic to a set of Pods. Example: a ClusterIP Service lets other Pods reach the app via a fixed DNS name.
- **Namespace** — A virtual partition inside a cluster for isolation and resource grouping. Example: `default` for regular apps and `kube-system` for cluster internals.

## A tiny example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: nginx:1.25
        ports:
        - containerPort: 80
```

This Deployment requests two replicas of Nginx. `kubectl apply -f deploy.yaml` creates the Pods, and `kubectl scale deployment hello-deploy --replicas=3` adds a third without changing the file.

## What I'll cover next

I want to explore the other resource types (Services, ConfigMaps, Secrets) and learn how they wire together. Then I'll set up a local cluster — probably Minikube or kind — and practice deploying a multi-container app. After that, I'll look at how Helm and Kustomize help manage larger configurations.
