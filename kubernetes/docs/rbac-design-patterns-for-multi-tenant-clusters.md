---
last_verified: 2026-10-29
tool_version: n/a
---

# RBAC design patterns for multi-tenant clusters

## Purpose

Define how to structure Kubernetes RBAC so multiple teams or workloads share one cluster without stepping on each other.

## When to use

- Shared clusters hosting several teams.
- Platform teams offering namespaces as a service.

## Prerequisites

- A cluster with namespace isolation.
- Familiarity with Roles, ClusterRoles, and bindings.

## Patterns

### Namespace-scoped roles

Give each tenant a Role in their own namespace. Bind a Group to it. Avoid ClusterRoleBindings for tenant work.

### Platform admin tier

Keep a small group of cluster-admins. Everyone else gets least-privilege roles.

### Read-only observers

Create a ClusterRole with get/list/watch. Bind to auditors and CI bots.

### Break-glass

Maintain a separate break-glass account with cluster-admin, stored outside normal SSO, and audit its use.

## Steps

1. Create namespace per tenant.
2. Define Role with needed verbs.
3. Bind via RoleBinding to a group.
4. Test with `kubectl auth can-i`.

## Verify

```bash
kubectl auth can-i list pods -n team-a --as=system:serviceaccount:team-a:deployer
```

## Common errors

- Binding a ClusterRole to a tenant namespace still grants cluster-wide if ClusterRoleBinding used.
- Forgetting to bind service accounts for workloads.
