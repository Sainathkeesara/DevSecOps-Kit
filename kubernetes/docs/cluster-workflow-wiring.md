---
last_verified: 2026-09-22
tool_version: n/a
---

# How I wired Kubernetes into my cluster workflow

## Purpose

This doc describes one way to run a small service on a Kubernetes cluster: one namespace per environment, a Deployment plus a Service per app, all applied from versioned manifests. It is the layout I would copy for the next service; the docs also show alternatives (one shared namespace, Helm or Kustomize for templating), so treat this as a starting point rather than the only option.

## When to use

This layout fits when there is a running cluster with cluster-admin access available and the goal is to get a stateless web app reachable inside the cluster. It is one way to do it; a single namespace with label-based separation is the lighter alternative the docs also suggest for throwaway experiments.

## Prerequisites

- A running cluster with the standard command-line client configured and pointing at it.
- A namespace per environment (for example `web-dev` and `web-staging`) created up front so later manifests can stay environment-agnostic.
- The app container image already built and pullable from the cluster.

## Steps

### 1. Create one namespace per environment

I keep a minimal namespace manifest per environment and apply it first. Everything else references the namespace by name, so promoting from dev to staging is a matter of changing the namespace field rather than editing the workload itself.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: web-dev
  labels:
    app.kubernetes.io/managed-by: manifests
```

Apply it with the client apply command, then list namespaces to confirm `web-dev` shows up.

### 2. Add a Deployment with a pinned image tag

Each app gets a Deployment with two replicas and a pinned (immutable) image tag, so a re-apply only rolls when the tag actually changes. The selector, the pod-template labels, and the container port have to agree with each other and with the Service in the next step — a mismatch there is the most common reason pods run fine but receive no traffic.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: web-dev
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: web:1.0.0
          ports:
            - containerPort: 8080
```

### 3. Expose it with a ClusterIP Service

A ClusterIP Service in front of the Deployment gives a stable in-cluster address. The Service selector must equal the pod-template labels (`app: web`), and the Service port must forward to the container port from the Deployment.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: web-dev
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 8080
```

### 4. Apply dev first, then copy the pattern to staging

I apply the dev namespace manifests, confirm the rollout, and only then duplicate the directory for staging with the namespace renamed. Keeping dev manual-sync at first and flipping to automated sync later is what earned trust in the flow before staging depended on it.

## Verify

- Listing pods in `web-dev` shows two ready replicas of the Deployment.
- Listing services in `web-dev` shows the `web` Service with endpoints pointing at those pods.
- Deleting one pod results in a replacement being scheduled, confirming the Deployment controller is managing the set.
- Re-applying the same manifests reports no changes, confirming the checked-in state matches the cluster.
