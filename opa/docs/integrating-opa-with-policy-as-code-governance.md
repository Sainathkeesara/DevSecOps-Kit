---
last_verified: 2026-10-05
tool_version: 3.23.1
sources:
  - https://open-policy-agent.github.io/gatekeeper/website/docs/failing-closed/
  - https://open-policy-agent.github.io/gatekeeper/website/docs/sync
  - https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/
  - https://pkg.go.dev/github.com/open-policy-agent/gatekeeper
  - https://api.github.com/repos/open-policy-agent/gatekeeper/releases/latest
  - https://api.github.com/repos/open-policy-agent/opa/releases/latest
---

# Integrating OPA with policy-as-code governance

Parameterizing one policy estate across dev, staging and prod, ordering its
promotion, and gating the Terraform plan with the same Rego that admission
will run.

## Purpose

A policy estate becomes hard to operate at the moment it has more than one
environment. The ConstraintTemplate stops changing; the Constraint values
start changing — which registries are acceptable, which checks are on, which
namespaces are skipped — and each of those values is enforcement surface. This
doc covers the three decisions that follow from that: what the parameter
surface looks like, what order the policy objects are promoted in, and what
runs before anything reaches the cluster.

The mechanics of authoring a template, deploying it and testing it live in
the three artifacts listed under Prerequisites. This doc starts where those
end and does not repeat them.

## When to use

- One ConstraintTemplate is shared by dev, staging and prod Constraints, and
  the environments need different answers from it.
- The policy objects are applied by a GitOps controller and the CRD-creation
  ordering is producing sync failures.
- Enforcement is being switched from audit to fail-closed and the blast radius
  of that switch needs to be bounded.
- A policy violation is currently discovered as a rejected apply and should
  instead fail at plan time.

## Prerequisites

Three artifacts in this folder cover the authoring and deployment flow and
are referenced, not restated:

- [`wired-opa-admission-control.md`](wired-opa-admission-control.md) — local
  evaluation → ConstraintTemplate → Constraint → ConfigMap deployment.
- [`constraint-template-design-patterns.md`](constraint-template-design-patterns.md)
  — `match` block and `openAPIV3Schema` design.
- [`../templates/gatekeeper-policy-library-scaffold/`](../templates/gatekeeper-policy-library-scaffold/README.md)
  — library Rego modules, two ConstraintTemplates, per-environment
  Constraints, and a CI test workflow.

The API group/versions used in the examples below
(`templates.gatekeeper.sh/v1beta1`, `constraints.gatekeeper.sh/v1beta1`,
`config.gatekeeper.sh/v1beta1`) are the ones the scaffold in this folder
ships. Confirm what a given cluster serves before copying, since the served
versions depend on the installed release:

```bash
kubectl api-resources | grep -i -E 'constraint|gatekeeper'
```

The enforcement engine this doc was verified against is Gatekeeper v3.23.1
(OPA v1.21.1).

## Steps

### 1. Design the parameter surface before writing the Constraints

A parameter exists in three places, and only the third one enforces anything:

| Tier | Object | Effect |
|---|---|---|
| Declared | `spec.crd.spec.versions[*].schema.openAPIV3Schema` on the ConstraintTemplate | Validates the Constraint's values and populates editor completion. Nothing more. |
| Supplied | `spec.parameters` on the Constraint | Reaches the policy as `input.parameters`. Nothing more. |
| Consumed | a `deny` rule inside `spec.targets[*].rego` | Changes what is admitted. |

A value that stops at the first two tiers is silently ignored: the Constraint
applies cleanly, its `status` reports no violations, and nothing is enforced.
The check for this is mechanical — for every key in the schema, name the rule
that reads it. A key with no matching read is dead configuration.

Two parameter shapes cover most pod-security estates:

```rego
package k8s.governance

# The single extraction point. Every rule below reads `resource`, never a
# bare `input.spec...`. See "one envelope, two callers" in Step 4.
resource := input.review.object

# --- registry tier: a list parameter with a default ------------------------
default allowed_registries = ["docker.io", "gcr.io", "quay.io"]

allowed_registries = input.parameters.allowedRegistries {
  input.parameters.allowedRegistries
}

registry(img) = r {
  parts := split(img, "/")
  r := parts[0]
}

deny[msg] {
  container := resource.spec.containers[_]
  reg := registry(container.image)
  not reg == allowed_registries[_]
  msg := sprintf("Image %v uses unapproved registry %v", [container.image, reg])
}

# --- boolean tier: a rule that reads the flag before it denies --------------
deny[msg] {
  container := resource.spec.containers[_]
  input.parameters.requireReadOnlyRootFilesystem
  not container.securityContext.readOnlyRootFilesystem == true
  msg := sprintf("Container %v must set readOnlyRootFilesystem=true", [container.name])
}
```

The boolean rule is written as an unconditional positive reference to
`input.parameters.requireReadOnlyRootFilesystem`. In Rego a body expression
that is undefined makes the whole rule undefined rather than false, so an
absent parameter silently disables the rule — which is exactly the wanted
behaviour for an environment that has not opted in yet. Nothing here needs a
`default` for the same reason: the absence of the key *is* the "off" value.

Namespace exemption does **not** belong in `parameters`. It is a scope
decision and belongs in the `match` block's `excludedNamespaces` — the same
`match` shape covered in
[`constraint-template-design-patterns.md`](constraint-template-design-patterns.md),
which scopes admission rather than adding a condition inside the policy:

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

The per-environment split is then one template, three Constraints:

| Parameter | dev | staging | prod | Read by |
|---|---|---|---|---|
| `allowedRegistries` | defaults + internal mirrors | defaults + internal mirrors | defaults only | `allowed_registries` |
| `requireReadOnlyRootFilesystem` | absent (check off) | `true` | `true` | second `deny` rule |
| namespaces excluded | `kube-system`, `gatekeeper-system` | same | same | `match.excludedNamespaces` |

Name the Constraints `<kind>-<env>` (`k8sgovernance-dev`,
`k8sgovernance-staging`, `k8sgovernance-prod`) so a single `kubectl get
constraints` distinguishes an estate from a single deployment. Keeping all
three on the same template kind is the point: a change to the Rego is
validated once and reaches all three environments, and only the values differ.

### 2. Promote in dependency order, never environment order backwards

Within an environment the policy objects have a fixed order:

1. `Config` — the singleton that carries the engine-level knobs. It must be
   named exactly `config`; the engine ignores a `Config` resource under any
   other name, so a misnamed object applies cleanly and changes nothing.
   `spec.match` here is where process exclusion (`[audit, webhook, sync]`) and
   `excludedNamespaces` are set.
2. `ConstraintTemplate` — which brings its Constraint CRD into existence with
   it.
3. `Constraint` — the per-environment values.

Step 2 is not a formality. The Constraint CRD is created out-of-band, in
response to a user-defined ConstraintTemplate, so a sync that reaches
Constraints before templates fails with `the server could not find the
requested resource`. Two things follow. The ordering above is the fix, and
the sync option `argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true`
— settable per resource or app-wide via `spec.syncPolicy.syncOptions` — is
the safety net for the case where the CRD is genuinely created out of band.
Its scope is narrow: the dry run still executes if the CRD is already present
in the cluster, so it does not replace waiting for the template.

Across environments the order is always dev → staging → prod, for both rule
changes and parameter changes. Parameter changes are the more frequent case
and carry the same risk, because a registry list is enforcement surface. Two
guardrails belong to that promotion:

- **Gate the sync.** Run the plan-stage policy job as a `PreSync` hook: "Apply
  all the resources marked as PreSync hooks. If any of them fails the whole
  sync process will stop and will be marked as failed." Its limitation is worth
  writing into the runbook — hooks do not run during a selective sync
  operation, so re-syncing one Constraint by hand bypasses the gate entirely.
  That is why the plan gate in Step 4 also runs on every pull request.
- **Keep the three environments in separate Applications.** By default the
  controller applies all manifests found in the configured git path regardless
  of whether the resources are already applied by another Application, so
  dev/staging/prod Constraints sharing one path fight over the same objects.
  `spec.syncPolicy.syncOptions` with `FailOnSharedResource=true` makes the
  sync fail on that overlap instead of silently overwriting.

Tearing an environment down follows the reverse dependency order:
Constraints → ConstraintTemplates → `Config`, then Gatekeeper, then prune. The
sync finalizers Gatekeeper adds to synced resources have to be able to remove
them from state before termination, and a prune that runs before that leaves
objects stuck `Terminating`.

### 3. Switch to fail-closed last, and only after observing the audit trail

The engine defaults to `failurePolicy: Ignore` for admission-request webhook
errors, and the documented impact is that "when the webhook is down, or
otherwise unreachable, constraints will not be enforced. Audit is expected to
pick up any slack in enforcement by highlighting invalid resources that made
it into the cluster." The practical consequence for a policy estate is that a
broken policy engine looks exactly like a passing one — which is the reason
audit-mode observation has to precede the switch, not follow it.

Fail-closing is a one-field edit: set `failurePolicy` to `Fail` on the
ValidatingWebhookConfiguration named
`gatekeeper-validating-webhook-configuration` (for manifest installs; Helm and
operator installs use their own docs). Within each environment that is the
last promotion step, after the Constraints have been live in audit mode
against real workloads long enough for the violation list to be believed.

The cost is stated in the same source and belongs in the change record. The
webhook is called for all API server requests under the default
configuration, with `timeoutSeconds: 3`, so the availability of the control
plane becomes subject to the availability of the webhook. The documented
admission deadlock: delete every Node, all Gatekeeper servers die, and a
request to add a Node cannot succeed until the webhook can serve, while the
webhook cannot serve until a Node is added. The stated mitigation is deleting
the ValidatingWebhookConfiguration — so if that object is a managed resource
in a GitOps repo with `selfHeal: true`, the recovery action is undone by the
controller that is itself wedged. **The ValidatingWebhookConfiguration used
for emergency recovery must not be an Argo CD-managed resource.**

One further trade-off applies to availability rather than correctness:
increasing the number of webhook pods may increase the time it takes for a
constraint to be enforced by all pods in the system, so replicas only help if
they are not in a shared failure domain.

### 4. Gate the Terraform plan with the same modules

The parameter contract in Step 1 has a second consumer. Because every rule
reads `resource`, and `resource` resolves from a single expression, the same
module runs in two places from one definition:

| Caller | Input document | `resource` resolves to |
|---|---|---|
| Admission (Gatekeeper) | the engine's admission review | `input.review.object` |
| Plan gate (CI) | `{"review": {"object": <resource>}}` | the wrapped resource |

The gate does not need a second copy of the rules or an adapter layer — it
produces the same envelope admission does and evaluates the same Rego against
the resources the plan is about to create. The local evaluation path is
already in this folder: [`../scripts/how-i-test-policies-locally.sh`](../scripts/how-i-test-policies-locally.sh)
wraps one policy file and one input document, and the scaffold's
`.github/workflows/ci-test.yml` runs its test harness on every pull request
that touches `policies/` or `constraint-templates/`.

Three properties make the gate worth running before promotion rather than
after:

- **It evaluates against the parameters that will be live.** Load the
  environment's Constraint values as the parameter set. A gate that judges with
  dev's permissive registry list and a cluster running prod's narrow one
  reports green for work prod will reject; the divergence between the gate's
  parameters and the deployed Constraint is the defect this closes.
- **It runs where selective sync cannot reach it.** Pull-request checks are not
  affected by the selective-sync limitation on `PreSync` hooks.
- **It fails before infrastructure exists.** A rejected plan is a failed check;
  a rejected apply is a half-finished promotion with the environment's
  enforcement state already changed.

Ordering across the whole estate is then: plan gate → promote dev → promote
staging → promote prod → flip fail-closed in prod last.

## Verify

- `kubectl get constrainttemplates` lists the templates before any Constraint
  in the same promotion references them, and `kubectl get constraints` shows
  one Constraint per environment with the same template kind.
- `kubectl get constraint k8sgovernance-prod -o yaml` shows the production
  parameter values, and the same command against the dev Constraint shows the
  wider registry list — the two differ only in `spec.parameters` and
  `spec.match`.
- For every key in a template's `openAPIV3Schema`, a rule in
  `spec.targets[*].rego` reads `input.parameters.<key>`. A key with no reader
  is dead configuration and is the check to run first.
- A deliberately non-compliant resource is rejected by the plan gate before
  promotion, and is also rejected by the webhook after the fail-close step in
  that environment.
- `kubectl get validatingwebhookconfiguration gatekeeper-validating-webhook-configuration -o yaml`
  shows the `failurePolicy` each environment is meant to be at for its current
  stage.
- The ValidatingWebhookConfiguration is not listed as a resource in any
  application, and dev/staging/prod Constraints are not in the same
  application path.

## Common errors

1. **Parameters declared but never read.** The Constraint applies, `status`
   reports nothing, and no rule changes behaviour. Confirm each schema key has
   a reader before trusting an estate.
2. **Rules written against a bare resource.** A rule reading `input.spec...`
   is undefined inside an admission template, where the object is at
   `input.review.object`, so every `deny` is undefined and the template admits
   everything. The template and its unit tests pass. Extract the object once,
   as `resource` in Step 1, and point both callers at the same envelope.
3. **Constraints synced before ConstraintTemplates.** The sync fails with
   `the server could not find the requested resource`; promote in the order in
   Step 2, and use `SkipDryRunOnMissingResource=true` for CRDs created out of
   band.
4. **A `Config` not named `config`.** It is ignored. The symptom is exemption
   and process-exclusion settings that never take effect and no error to
   explain why.
5. **Fail-closing before the audit trail has been believed.** Rejected applies
   with no record of what would have been rejected, which is the one moment
   the default `failurePolicy: Ignore` is doing useful work.
6. **One application path for all three environments.** Without
   `FailOnSharedResource=true`, overlapping objects are applied by whichever
   application syncs last.
7. **Relying on a `PreSync` hook as the only gate.** Hooks do not run during a
   selective sync operation, so a hand-triggered re-sync of a single Constraint
   reaches the cluster ungated.

## References

- [Gatekeeper: failing closed](https://open-policy-agent.github.io/gatekeeper/website/docs/failing-closed/)
- [Gatekeeper: sync and data replication](https://open-policy-agent.github.io/gatekeeper/website/docs/sync)
- [Argo CD: sync options](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)
- [Argo CD: sync phases and waves](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/)
- [open-policy-agent/gatekeeper module reference](https://pkg.go.dev/github.com/open-policy-agent/gatekeeper)