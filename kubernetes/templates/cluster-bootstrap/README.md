---
last_verified: 2026-10-28
tool_version: n/a
---

# Cluster bootstrap: CNI, CSI, Ingress, Cert-Manager

> A starter scaffold for bootstrapping the add-ons a cluster needs before workloads go in: a CNI (Calico), a CSI storage driver, an IngressClass with a sample Ingress, and Cert-Manager for TLS. This is one way to lay it out; adjust component names and versions to your cluster.

## Purpose

Bootstrapping a cluster means installing the shared add-ons so applications have networking, persistent storage, ingress, and TLS certificates. The four components here are independent and can be applied in any order, though installing the CNI first is safest so that pods can communicate with each other.

## When to use

- A fresh cluster where none of these add-ons are installed yet.
- You want a single folder to copy into a cluster-bootstrap repository and apply per environment.
- You are comfortable that these are cluster-scoped changes and want to review each manifest before applying it.

## Prerequisites

- A running Kubernetes cluster with `kubectl` configured and the correct context set.
- Cluster-admin rights (CNI, StorageClass, IngressClass, and Cert-Manager are all cluster-scoped).
- A CNI choice. This scaffold uses Calico in `cni/`; swap that manifest for your preferred CNI.

## Directory layout

```
cluster-bootstrap/
├── cni/
│   └── calico-installation.yaml   # Calico operator + Installation CR placeholder
├── csi/
│   └── storage-class.yaml         # Reference StorageClass for a CSI driver
├── ingress/
│   └── ingress-class.yaml         # IngressClass and a sample Ingress resource
└── cert-manager/
    └── cert-manager-bootstrap.yaml # Cert-Manager namespace + placeholder
```

## Steps to adopt

1. Copy this folder into your cluster-bootstrap repository.
2. Review each manifest and adjust names, namespaces, and settings to your cluster.
3. Install the CNI first (see `cni/calico-installation.yaml`) so pods can communicate.
4. Install the CSI driver for your storage provider (see `csi/storage-class.yaml`), then create StorageClass objects.
5. Create the IngressClass and a sample Ingress (see `ingress/ingress-class.yaml`).
6. Install Cert-Manager (see `cert-manager/cert-manager-bootstrap.yaml`), then create a ClusterIssuer for TLS.
7. Verify each component (below) before adding workloads.

## Verify

- `kubectl get daemonset -n calico-system` — `calico-node` should be running on each node.
- `kubectl get storageclass` — your CSI StorageClass is listed.
- `kubectl get ingressclass` — your IngressClass is present.
- `kubectl get pod -n cert-manager` — Cert-Manager pods are running.
- `kubectl get clusterissuer` — a ClusterIssuer exists for issuing certificates.

## References

- `kubernetes/notes/0000-primer-kubernetes.md` — kit primer on Kubernetes objects and `kubectl`.
- `kubernetes/manifests/` — existing cluster-scoped manifest examples in the kit.
