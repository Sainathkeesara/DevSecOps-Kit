# How I wired OPA into admission control

Local testing, ConfigMap deployment, and Gatekeeper constraint templates.

## Purpose

This walks through the full flow of writing and deploying OPA policies as
Kubernetes admission controllers with Gatekeeper — from iterating locally
to shipping constraints via ConfigMaps.

## Steps

### 1. Write and test the Rego policy locally

Start with a standalone Rego file that denies privileged containers and
hostNetwork access.  Testing locally avoids the deploy-wait-fail loop.

```bash
# Create a minimal input payload that mimics the admission review
cat > test-input.json <<'EOF'
{
  "metadata": { "name": "bad-pod" },
  "containers": [
    {
      "name": "app",
      "securityContext": { "privileged": true }
    }
  ],
  "hostNetwork": true
}
EOF

# Evaluate the policy against that input
opa eval --format pretty \
  --data deny-privileged-hostnetwork.rego \
  --input test-input.json \
  --fail-defined \
  "data.k8s.security_baseline.deny"
```

Expected output — two violations, one for the privileged container and one
for hostNetwork:

```
Container app is privileged -- not allowed
Pod bad-pod uses host networking -- not allowed
```

If `--fail-defined` returns zero results the policy passed (no violations).
Wrap this in a shell script to avoid typing the long command each time.

### 2. Wrap the Rego in a Gatekeeper ConstraintTemplate

Once the Rego logic is stable, wrap it in a `ConstraintTemplate` CRD.
The Rego lives inside the template's `targets[*].rego` field and references
`input.review` instead of bare `input`.

```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8ssecuritybaseline
spec:
  crd:
    spec:
      names:
        kind: K8sSecurityBaseline
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8s.security_baseline

        # The Gatekeeper input is under input.review.object
        # instead of the top-level input used by opa eval.
        # Easy to forget — this mismatch is a common first-deploy gotcha.

        deny[msg] {
          container := input.review.object.spec.containers[_]
          container.securityContext.privileged == true
          msg := sprintf("Container %v is privileged", [container.name])
        }

        deny[msg] {
          input.review.object.spec.hostNetwork == true
          msg := "hostNetwork is not allowed"
        }
```

The key difference: Gatekeeper nests the reviewed object under
`input.review.object` while `opa eval --input` puts it at the top level.
A local build step that rewrites the path lets you test the same logic both ways.

### 3. Create a Constraint from the template

A `Constraint` instantiates the template and scopes it with a `match` block.

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sSecurityBaseline
metadata:
  name: block-privileged-hostnetwork
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
```

The match block tells Gatekeeper which resources to audit.  Exclude
system namespaces because kube-system runs components that sometimes
need hostNetwork (CNI plugins, kube-proxy, etc.).

### 4. Deploy via ConfigMap

For environments where Gatekeeper constraints are managed declaratively,
bundle the template and constraint into a ConfigMap and apply it.

```bash
kubectl apply -f constraint-template.yaml
kubectl apply -f constraint.yaml
```

Or, to keep everything in one ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: security-baseline-constraints
  namespace: gatekeeper-system
data:
  template.yaml: |
    # contents of constraint-template.yaml
  constraint.yaml: |
    # contents of constraint.yaml
```

Gatekeeper watches for ConstraintTemplate and Constraint CRDs directly,
so the ConfigMap approach is mainly for backup or GitOps workflows that
sync manifests from a single source.

## Verify

Deploy a pod that violates the constraint:

```bash
kubectl run nope --image=nginx --privileged
# Error: admission webhook "validation.gatekeeper.sh" denied the request:
# Container nope is privileged
```

Check audit results (Gatekeeper audits existing resources even without
the webhook):

```bash
kubectl get k8ssecuritybaseline block-privileged-hostnetwork -o yaml
```

The status block lists all violations found by the audit scanner.
This is useful for discovering existing policy violations without
blocking workloads during rollout.

## What tripped me up

- **`input` path mismatch** — Rego tested with `opa eval --input` uses
  the payload at the root, but Gatekeeper wraps it under
  `input.review.object.spec`.  A small script that strips the wrapper
  for local testing lets you use the same Rego everywhere.
- **ConstraintTemplate CRD version** — `v1beta1` vs `v1` depends on
  the Gatekeeper release.  Newer Gatekeeper (3.12+) uses `v1` for
  both templates and constraints.  Check `kubectl api-resources` if
  apply fails with "no matches for kind".
- **ExcludedNamespaces silently ignored** — If the namespace doesn't
  exist yet the exclusion is applied but nothing breaks; the pod just
  doesn't get audited.  Worth verifying exclusions with a test pod.
