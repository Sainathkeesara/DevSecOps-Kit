---
last_verified: 2026-08-19
tool_version: n/a
---

# Gatekeeper constraint template library — Kubernetes security baseline

A small, reusable set of `ConstraintTemplate` + `Constraint` manifests for a
pod/namespace security baseline. I built these after getting the single
hostNetwork example (`opa/configs/tried-a-gatekeeper-constraint.yaml`) working,
to turn one-off policies into a real library other clusters can reuse.

## Purpose

Gatekeeper policies live in two layers: a `ConstraintTemplate` is the reusable
rego + schema, and a `Constraint` instantiates it with scope (match) and
parameters. This library ships several related security checks together so a new
team can apply one baseline instead of assembling templates from scratch.

## Library contents

| Template | What it enforces | Constraint instance |
|---|---|---|
| `K8sDisallowCapabilities` | containers must `drop: ["ALL"]` capabilities | `disallow-all-capabilities` |
| `K8sRunAsNonRoot` | containers must set `runAsNonRoot: true` | `run-as-non-root` |
| `K8sDisallowPrivilegeEscalation` | containers must set `allowPrivilegeEscalation: false` | `no-privilege-escalation` |
| `K8sRequiredLabels` | namespaces must carry a parameterised label set | `require-environment-team-labels` |

The label template is the parameterised one — its rego reads `input.parameters`,
so you can reuse it for any label/pair without editing the rego.

## Steps

1. Apply the templates first (the Constraint CRDs don't exist until their
   template is installed):

   ```bash
   kubectl apply -f constraint-templates.yaml
   ```

   A `ConstraintTemplate` takes a few seconds to compile; if a Constraint is
   applied too soon you'll hit `no matches for kind "K8sRunAsNonRoot"`.

2. Apply the constraints that scope and enforce them:

   ```bash
   kubectl apply -f constraints.yaml
   ```

3. Give the baseline room to stabilise: each Constraint has
   `enforcementAction: deny`; switching that to `dryrun` turns Gatekeeper into
   an auditor that records violations without blocking, which is how I'd roll
   this out on a shared cluster before flipping to deny.

## Verify

Check constraint status — the audit controller fills this even for resources
that already exist:

```bash
kubectl get constraint disallow-all-capabilities -o yaml
kubectl get constraint require-environment-team-labels -o yaml
```

Then try to create a violating pod and expect the webhook to deny it:

```bash
kubectl -n default run nope --image=busybox --restart=Never \
  -- sh -c 'sleep 3600'
# denied: Container nope must drop ALL capabilities
```

## Gotchas I hit building this

- **`input.review.object`, not `input`** — Gatekeeper wraps the reviewed object
  under `input.review.object`, while `opa eval --input` puts it at the root. I
  kept writing `input.object` and the rego silently matched nothing.
- **`not <field> == true` flags unset fields too** — `runAsNonRoot` isn't set in
  most examples, and `not container.securityContext.runAsNonRoot == true` treats
  both `false` and unset as a violation. That's what I want for a baseline, but
  it surprises people who expect only an explicit `false` to be caught.
- **Ordering matters** — templates compile asynchronously after apply, so apply
  both files a few seconds apart and check `kubectl get constrainttemplates`
  (status should show `Created`) before debugging a "no matches for kind" error.