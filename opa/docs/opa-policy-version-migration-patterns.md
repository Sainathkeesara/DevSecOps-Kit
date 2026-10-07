---
last_verified: 2026-10-06
tool_version: n/a
sources: []
---

# OPA policy version migration patterns

Moving a Gatekeeper policy estate across an engine, apiVersion, or Rego
language version change without changing what it enforces.

## Purpose

A policy migration is a compatibility problem with three clocks that do
not tick together. The admission engine (the Gatekeeper controller
image), the CRD apiVersions the cluster serves, and the Rego language
version the engine evaluates under are versioned independently, and a
change in any one of them can alter what a policy matches, what it
reports, or whether it loads at all. This doc covers the patterns for
moving an estate across one of those changes while the enforcement
surface stays constant: inventory the layers separately, migrate one
layer at a time, compare audit output before and after, and keep the
previous definition one apply away.

The worked example throughout is the kit's own policy estate: four
ConstraintTemplates in
[`../manifests/constraint-templates.yaml`](../manifests/constraint-templates.yaml),
their Constraint instances in
[`../manifests/constraints.yaml`](../manifests/constraints.yaml), the
controller overlay in
[`../manifests/gatekeeper-production-deployment.yaml`](../manifests/gatekeeper-production-deployment.yaml),
and the per-environment dryrun/deny split in
[`../configs/opa-policy-configuration-template.yaml`](../configs/opa-policy-configuration-template.yaml).

## When to use

- The engine image is moving to a different release and the served CRD
  versions or the Rego language default may move with it.
- Objects in the estate still carry an older apiVersion than the cluster
  serves.
- Template Rego is written in the classic style — no `rego.v1` import,
  no `if` keyword, as in every `rego:` block in
  `../manifests/constraint-templates.yaml` — and the language version
  the engine evaluates under is changing.
- A migration has already been applied and the open question is how to
  prove nothing drifted, not how to apply it.

## Prerequisites

- The estate inventory: `kubectl get constrainttemplates`,
  `kubectl get constraints -A`, and the served versions from
  `kubectl api-resources | grep -i -E 'constraint|gatekeeper'` — the
  same check `integrating-opa-with-policy-as-code-governance.md` runs
  before any apiVersion is copied, because what a cluster serves depends
  on the installed release.
- Audit running in the target cluster. The controller overlay ships the
  audit ConfigMap (`auditInterval`, `constraintViolationLimit`,
  `auditChunkSize`, `auditFromCache`, `auditMatchKindOnly`) and a
  `config.gatekeeper.sh/v1alpha1` Config with `readiness.statsEnabled`;
  the audit results are the comparison signal for the whole migration.
- The previous definition of every object in version control, so rollback
  is a re-apply rather than a rewrite.
- The enforcement ladder in
  `integrating-opa-with-policy-as-code-governance.md` (dryrun before
  deny, the `Config` → `ConstraintTemplate` → `Constraint` promotion
  order, fail-closed switching). This doc extends that ladder; it does
  not repeat it.

## Steps

### 1. Inventory the three version layers separately

| Layer | Where it lives in the kit | How to read it |
|---|---|---|
| Engine release | container image in `../manifests/gatekeeper-production-deployment.yaml` — deliberately an unpinned placeholder with a "pin to a tested release" comment | the tag actually running in the cluster |
| CRD apiVersion | `apiVersion:` on every object: `templates.gatekeeper.sh/v1beta1`, `constraints.gatekeeper.sh/v1beta1`, `config.gatekeeper.sh/v1alpha1` | `kubectl api-resources` against the target cluster |
| Rego language version | the style of the `rego:` blocks in `../manifests/constraint-templates.yaml` (classic: `violation[{"msg": msg}] { ... }`) | the engine's language default for the release in the first row |

The layers migrate independently. A single "upgrade" that touches all
three at once is the anti-pattern: if the violation set moves, there is
no way to tell which layer moved it.

### 2. Migrate in dependency order, one layer at a time

Apply order is CRD/apiVersion first, then ConstraintTemplates, then
Constraints. A Constraint is an instance of a CRD kind that its
ConstraintTemplate publishes — the kit's configs template states the
rule directly: Constraint CRDs do not exist until their template is
applied. Applying a migrated Constraint against an unmigrated template
either fails with "no matches for kind" or, worse, applies against the
old schema and validates nothing new.

### 3. Introduce the migrated object under a new name, in dryrun

The per-environment pattern in
`../configs/opa-policy-configuration-template.yaml` runs the same check
as `enforcementAction: dryrun` on one cluster and `deny` on another. A
migration reuses that split: add the migrated template and constraint
alongside the old ones under distinct `metadata.name` values, set
`dryrun`, and let audit collect what the new version would have done.
The old object keeps denying while the new one measures; neither is
edited in place.

### 4. Diff the audit output, not the apply

The migration signal is the violation set, not whether `kubectl apply`
succeeded. Compare the audit results of the old and new objects over the
same window: same kinds in scope, same `excludedNamespaces` (the kit's
Pod constraints exempt `kube-system` and `gatekeeper-system`), same
violating workloads, same messages. A non-empty diff is a behavior
change — stop and explain it before promoting anything. Keep
`auditFromCache: "false"` for the comparison window; a cached audit can
serve pre-migration results after the change and hide the diff.

### 5. Promote by switching enforcement, then retire the old object

Once the dryrun object's audit output matches the old object's for a
full audit interval (`auditInterval` in the ConfigMap is the minimum
observation window), promote the new object to `deny` following the
promotion order and fail-closed controls in
`integrating-opa-with-policy-as-code-governance.md`. Only then delete
the old template and constraint. The first clean audit interval after
promotion is the evidence the migrated object runs on its own.

### 6. Roll back by re-applying the previous definition

Rollback is a re-apply of the stored previous objects, in reverse order
(constraints before templates). Because step 3 kept the old object until
step 5 completed, rollback is a `kubectl apply` of a file in version
control, not a rewrite from memory.

## Verify

- `kubectl get constrainttemplates` and `kubectl get constraints -A`
  show the migrated objects with the expected apiVersion and no leftover
  duplicate kinds.
- Audit results for the migrated object match the pre-migration baseline
  for the same window: same violating workloads, same messages.
- `kubectl api-resources | grep -i -E 'constraint|gatekeeper'` lists
  the served versions the objects now use.
- A deliberately violating test object — a Pod without the
  `securityContext` the `K8sDisallowCapabilities` template requires, or
  a Namespace missing the `environment`/`team` labels in
  `../manifests/constraints.yaml` — is reported by the migrated policy
  exactly as the old one reported it.
- The scaffold CI harness in
  `../templates/gatekeeper-policy-library-scaffold/` still passes for
  the migrated Rego, so a behavior change is caught at PR time on the
  next edit.

## Common errors

- **Migrating the Constraint before its ConstraintTemplate.** The
  Constraint's `kind` is a CRD published by the template; an instance
  of a not-yet-migrated kind fails to apply or silently validates
  nothing.
- **Renaming a template during migration.** `metadata.name` on the
  ConstraintTemplate determines the CRD kind Constraints bind to.
  Renaming it orphans every existing Constraint of the old kind.
- **Copying an apiVersion from a doc instead of the cluster.** The kit
  ships `v1beta1` for both the template and constraint groups; what a
  given cluster serves depends on the installed release, which is why
  `kubectl api-resources` is a prerequisite rather than a courtesy.
- **Bumping the engine image and the Rego language in one step.** Two
  changed layers make the audit diff unattributable.
- **Trusting a cached audit for the comparison.** `auditFromCache` can
  report pre-migration results after the change; disable it for the
  comparison window.
- **Retiring the old object before one clean audit interval.** The first
  post-migration audit is the only evidence the new object runs;
  deleting the old object first leaves nothing to compare against and
  nothing to roll back to.

## References

- [`wired-opa-admission-control.md`](wired-opa-admission-control.md) —
  local evaluation through ConstraintTemplate to Constraint deployment.
- [`constraint-template-design-patterns.md`](constraint-template-design-patterns.md)
  — `match` block and `openAPIV3Schema` design.
- [`integrating-opa-with-policy-as-code-governance.md`](integrating-opa-with-policy-as-code-governance.md)
  — parameter contract, promotion order, fail-closed switching,
  plan-time gate.
- [`../manifests/README.md`](../manifests/README.md) — apply ordering
  and rollout notes for the manifest set.
- [`../manifests/constraint-templates.yaml`](../manifests/constraint-templates.yaml),
  [`../manifests/constraints.yaml`](../manifests/constraints.yaml),
  [`../manifests/gatekeeper-production-deployment.yaml`](../manifests/gatekeeper-production-deployment.yaml)
  — the worked estate.
- [`../configs/opa-policy-configuration-template.yaml`](../configs/opa-policy-configuration-template.yaml)
  — per-environment dryrun/deny split.
- [`../templates/gatekeeper-policy-library-scaffold/README.md`](../templates/gatekeeper-policy-library-scaffold/README.md)
  — library scaffold with CI test harness.
