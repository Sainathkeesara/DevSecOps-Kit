---
last_verified: 2026-08-27
tool_version: n/a
sources: []
---
# Gatekeeper policy library scaffold

A starting point for teams that want a version-controlled OPA Gatekeeper
policy library with a CI test harness.  Copy the scaffold into your repo,
drop Rego policies into `policies/`, register them as ConstraintTemplates
in `constraint-templates/`, and let the GitHub Actions workflow catch
regressions before they reach the cluster.

## Prerequisites

- Gatekeeper installed in a Kubernetes cluster (or `opa` CLI for local testing)
- `kubectl` configured against the target cluster
- A GitHub repository with Actions enabled

## What is in this scaffold

```
gatekeeper-policy-library-scaffold/
├── README.md
├── .github/
│   └── workflows/
│       └── ci-test.yml            # runs policy tests on every PR
├── constraint-templates/
│   ├── k8ssecuritybaseline.yaml   # pod security constraints
│   └── k8sallowedregistries.yaml  # container image registry restrictions
├── policies/
│   ├── deny-privileged-containers.rego
│   ├── deny-host-network.rego
│   ├── require-read-only-root-filesystem.rego
│   └── enforce-image-registry.rego
└── tests/
    └── test-policies.sh           # local + CI test runner
```

## Steps

### 1. Copy the scaffold into your repo

```bash
cp -r gatekeeper-policy-library-scaffold /your/repo/policy-library
cd /your/repo/policy-library
```

### 2. Review the Rego policies

Each file in `policies/` is a standalone Rego module that can be evaluated
with `opa eval` or bundled into a ConstraintTemplate.  The four included
policies cover the most common pod-security guardrails:

- `deny-privileged-containers.rego` — blocks containers with
  `securityContext.privileged: true`
- `deny-host-network.rego` — blocks pods that request `hostNetwork: true`
- `require-read-only-root-filesystem.rego` — requires
  `securityContext.readOnlyRootFilesystem: true`
- `enforce-image-registry.rego` — restricts container images to an
  allowlisted registry domain

Edit the `allowed_registries` list in `enforce-image-registry.rego` to
match your organization's container registry.

### 3. Apply the ConstraintTemplates

```bash
kubectl apply -f constraint-templates/
```

Gatekeeper registers each template as a new CRD.  Verify with:

```bash
kubectl get constrainttemplates
```

### 4. Create Constraints from the templates

A `Constraint` instantiates a template and scopes it with `match` rules.
The scaffold does not ship Constraints — you create those per environment
(namespace, label selectors, enforcement action).

Example:

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
  parameters:
    enforceReadOnlyRootFilesystem: true
```

### 5. Run the test harness locally

```bash
chmod +x tests/test-policies.sh
./tests/test-policies.sh
```

The script runs `opa test` against every `*_test.rego` file in the
`policies/` directory and exits non-zero if any test fails.

### 6. CI integration

The `.github/workflows/ci-test.yml` file runs on every pull request that
touches `policies/` or `constraint-templates/`.  It installs `opa`,
executes the test harness, and reports the result as a check on the PR.

Push the scaffold to your repo and open a test PR to confirm the workflow
fires.

## Verify

- Run `./tests/test-policies.sh` locally — all tests should pass (exit 0).
- Push a change that breaks a policy (e.g., remove a deny rule) and confirm
  the GitHub Action marks the check as failed.
- Apply the ConstraintTemplates to a test namespace and deploy a pod that
  violates one of the constraints to confirm the admission webhook blocks it.

## Customising

- Add new Rego files to `policies/` and matching unit tests in the same
  directory (name them `<policy>_test.rego`).
- Add new ConstraintTemplates to `constraint-templates/` when a policy
  needs to be enforced cluster-wide via admission control.
- Extend `.github/workflows/ci-test.yml` to publish test results as an
  artifact or to comment on the PR with a summary of violations.
