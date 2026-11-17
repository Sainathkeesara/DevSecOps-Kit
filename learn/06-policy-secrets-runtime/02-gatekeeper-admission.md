---
last_verified: 2026-11-17
tool_version: n/a
sources: []
---

# Reject privileged and root pods with Gatekeeper

You wrote and tested Rego policies locally in the previous lesson. Now you'll move those policies into the cluster: Gatekeeper wraps OPA as a Kubernetes admission webhook, so a Rego rule can reject a pod before it ever runs. This lesson continues directly from Rego basics — you'll port the same deny logic into Gatekeeper's `input.review.object` shape, apply it as a Constraint, and watch a privileged root pod get rejected, then fixed.

## What you'll learn

- Install Gatekeeper and confirm its admission CRDs are present in the cluster.
- Write a Gatekeeper ConstraintTemplate + Constraint that rejects privileged containers and containers running as root.
- Plant a violating pod, confirm Gatekeeper rejects it, then fix the pod's security context and confirm it's admitted.

## Before you start

- [Rego basics and testing policies](01-rego-basics.md) — you already wrote a Rego deny rule and tested it with `opa test`; here you port that same logic into Gatekeeper's `input.review.object` shape (the top-level `input` used by `opa eval` becomes `input.review.object` under Gatekeeper).
- [Deploy per environment from Git with Argo CD](../05-kubernetes-gitops/07-argocd-gitops.md) — you're comfortable applying manifests with `kubectl` to a reachable cluster.
- Gatekeeper installed in a cluster you can reach with `kubectl` (controller pods running in `gatekeeper-system`).
- `kubectl` installed: `kubectl version --client` prints a client version.

## Walkthrough

### 1. Confirm Gatekeeper is installed and its CRDs are present

```bash
kubectl -n gatekeeper-system get pods
kubectl get crds | grep gatekeeper
```

You should see Gatekeeper controller pods running and CRDs such as `constrainttemplates.gatekeeper.sh` and `constraints.gatekeeper.sh`. If Gatekeeper isn't installed yet, apply the controller overlay in `opa/manifests/gatekeeper-production-deployment.yaml` first, then wait for the controller pods to become `Running`.

### 2. Add a ConstraintTemplate + Constraint that rejects privileged and root containers

Create `opa/manifests/gatekeeper-pod-security.yaml` with a ConstraintTemplate wrapping two Rego deny rules — one for privileged containers, one for containers running as root — plus a Constraint that scopes the template to all Pods:

```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8spodsecuritybaseline
spec:
  crd:
    spec:
      names:
        kind: K8sPodSecurityBaseline
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8s.podsecuritybaseline

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          container.securityContext.privileged == true
          msg := sprintf("Container %v runs privileged — not allowed", [container.name])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not container.securityContext.runAsNonRoot == true
          msg := sprintf("Container %v must run as non-root (runAsNonRoot: true)", [container.name])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPodSecurityBaseline
metadata:
  name: block-privileged-root-pods
spec:
  enforcementAction: deny
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
```

Apply it:

```bash
kubectl apply -f opa/manifests/gatekeeper-pod-security.yaml
```

You should see: `constrainttemplate.templates.gatekeeper.sh/k8spodsecuritybaseline created` and `k8spodsecuritybaseline.constraints.gatekeeper.sh/block-privileged-root-pods created`, and the new `K8sPodSecurityBaseline` CRD becomes available.

### 3. Plant a violating pod and watch Gatekeeper reject it

Create a pod that runs privileged as root:

```bash
kubectl run bad-pod --image=nginx --overrides='{"spec":{"containers":[{"name":"bad","securityContext":{"privileged":true,"runAsUser":0}}]}}'
```

You should see: `Error from server (Forbidden): admission webhook "validation.gatekeeper.sh" denied the request: ... runs privileged — not allowed`. Gatekeeper blocks the pod before it's created.

### 4. Fix the pod and confirm it's admitted

Rerun without privileged and as non-root:

```bash
kubectl run good-pod --image=nginx --overrides='{"spec":{"containers":[{"name":"good","securityContext":{"runAsNonRoot":true,"runAsUser":1000}}]}}'
```

You should see: `pod/good-pod created`. The same image is admitted once the security context satisfies the policy.

## Exercise

Working alone, with Gatekeeper still running:

1. Add a third rule to the `K8sPodSecurityBaseline` template that denies containers with `allowPrivilegeEscalation: true`, and re-apply `opa/manifests/gatekeeper-pod-security.yaml`.
2. Plant a pod with `allowPrivilegeEscalation: true` and confirm Gatekeeper rejects it.
3. Fix that pod (set `allowPrivilegeEscalation: false`) and confirm it's admitted.

Do not paste the solution into the lesson file.

## Check your work

```bash
kubectl get constrainttemplate k8spodsecuritybaseline
```
lists the template, and
```bash
kubectl get k8spodsecuritybaseline block-privileged-root-pods -o yaml
```
shows the enforced Constraint with `enforcementAction: deny`.

After adding the privilege-escalation rule, a violating pod is rejected with `validation.gatekeeper.sh` and the fixed pod is created.

## Common mistakes

- **Testing with top-level `input` instead of `input.review.object`.** A rule that passes `opa eval --input` locally silently never fires under Gatekeeper, because Gatekeeper nests the reviewed object under `input.review.object.spec`. Always test Gatekeeper rules against the wrapped shape.
- **Forgetting `excludedNamespaces`.** Without it, Gatekeeper audits `kube-system` and `gatekeeper-system` too, and system components that legitimately need privileged containers get blocked.

## Next

[HashiCorp Vault — quick primer](../../vault/notes/0000-primer-vault.md)
