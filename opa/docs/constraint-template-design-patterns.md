---
last_verified: 2026-08-27
tool_version: n/a
sources: []
---
# OPA Gatekeeper constraint template design patterns for pod security

## Purpose

ConstraintTemplates are the reusable blueprints that turn Rego policies into
Kubernetes admission control rules.  For pod security, a well-structured
template lets you enforce baseline guardrails — privileged containers,
hostNetwork, read-only root filesystems, and registry restrictions — across
every namespace without rewriting Rego for each constraint.

## When to use

Write a ConstraintTemplate when the same policy logic needs to be enforced
in multiple namespaces, clusters, or environments with different parameters.
A single template paired with multiple Constraint instances lets you tune
`match` rules and `parameters` per environment while keeping the Rego in
one place.

Use an off-the-shelf policy library (e.g., the Gatekeeper library) when
your requirements match an existing template.  Write a custom template when
you need organization-specific logic — such as enforcing a private registry
domain or requiring a specific seccomp profile.

## Prerequisites

- Gatekeeper installed in the target cluster with the `templates.gatekeeper.sh/v1beta1`
  CRD available
- `kubectl` configured with permissions to create CRDs and ConstraintTemplates
- Rego policies tested locally with `opa eval`

## Steps

### 1. Start with a standalone Rego policy

Write and validate the Rego logic outside Gatekeeper first.  The input shape
differs between `opa eval` and Gatekeeper:

- `opa eval --input` — payload at the top level
- Gatekeeper — payload nested under `input.review.object`

A small wrapper that rewrites the path lets you test the same Rego both
ways:

```bash
opa eval --format pretty \
  --data deny-privileged-containers.rego \
  --input <(jq '.review.object' test-input.json) \
  "data.k8s.security_baseline.deny"
```

### 2. Wrap the Rego in a ConstraintTemplate

Move the Rego into the `targets[*].rego` field of a `ConstraintTemplate`
CRD.  The template defines the `crd.spec.names.kind` that will appear in
matching `Constraint` resources.

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

        deny[msg] {
          container := input.review.object.spec.containers[_]
          container.securityContext.privileged == true
          msg := sprintf("Container %v is privileged -- not allowed", [container.name])
        }
```

### 3. Design the match and parameters block

Constraints control where the template applies.  A pod-security template
typically matches Pods across all namespaces, with system namespaces
excluded:

```yaml
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
```

If the template accepts `parameters`, define the schema in the `crd.spec.versions[*].schema.openAPIV3Schema`
field so consumers get validation feedback when they create Constraints.

### 4. Apply and audit

```bash
kubectl apply -f constraint-template.yaml
kubectl get constrainttemplates
```

Create a Constraint to activate the template:

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sSecurityBaseline
metadata:
  name: block-privileged-containers
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
```

Gatekeeper audits existing resources immediately.  Check violations with:

```bash
kubectl get k8ssecuritybaseline block-privileged-containers -o yaml
```

## Verify

- Deploy a privileged pod in a test namespace and confirm the admission
  webhook rejects it with the expected violation message.
- Remove the `privileged: true` flag and confirm the pod deploys cleanly.
- Inspect the Constraint's `status.violations` list to verify existing
  non-compliant pods are reported even when the webhook is not blocking.

## Common errors

- **Input path mismatch** — The most common gotcha.  Rego written and tested
  with `opa eval --input` uses the payload at the root; Gatekeeper wraps it
  under `input.review.object`.  Forgetting this causes every rule to silently
  pass because the fields are never found.
- **CRD version drift** — `v1beta1` is available in Gatekeeper 3.x but was
  promoted to `v1` in later releases.  Applying a template with the wrong
  version produces `no matches for kind "ConstraintTemplate"`.  Verify with
  `kubectl api-resources | grep constrainttemplate`.
- **ExcludedNamespaces only works if the namespace exists** — If a namespace
  listed in `excludedNamespaces` has not been created yet, the exclusion is
  stored but has no effect until the namespace appears.  This is harmless but
  can mask misconfiguration during initial setup.
- **Parameters not passed through** — A Constraint that omits a required
  `parameters` field silently falls back to the template's `default` values.
  Always define explicit defaults in the Rego to avoid unexpected behavior.

## References

- OPA Gatekeeper documentation on ConstraintTemplates
- Rego policy authoring guide
