---
last_verified: 2026-10-05
tool_version: n/a
sources: []
---
# Integrating OPA with policy-as-code governance

## Purpose

This document describes how to integrate Open Policy Agent (OPA) and Gatekeeper into a policy-as-code governance framework. It covers the organizational patterns, repository structures, and CI/CD integration points that enable consistent policy enforcement across infrastructure, Kubernetes, and application layers.

## When to use

Adopt this pattern when:

- Multiple teams need shared policy definitions with versioned, auditable changes
- Policy enforcement must span Kubernetes admission control, Terraform plan validation, and CI gate checks
- Compliance requirements demand traceability from policy source to enforcement point
- Existing Gatekeeper or OPA deployments operate in isolation and need unified governance

## Prerequisites

- OPA CLI installed for local policy development and testing
- Gatekeeper deployed in target Kubernetes clusters (v3.x or later)
- Git repository for policy source code with branch protection and review requirements
- CI/CD system capable of running `opa eval`, `opa test`, and `gatekeeper verify` steps
- Basic familiarity with Rego syntax and Gatekeeper CRDs (ConstraintTemplate, Constraint)

## Steps

### 1. Organize policies in a monorepo structure

Structure the policy repository to separate concerns and enable independent lifecycle management:

```
policies/
├── library/                 # Reusable Rego modules (helpers, data models)
│   ├── k8s/
│   │   ├── pod_security.rego
│   │   └── network_policy.rego
│   ├── terraform/
│   │   └── aws_security.rego
│   └── common/
│       └── labeling.rego
├── templates/               # Gatekeeper ConstraintTemplates
│   ├── k8s-security-baseline.yaml
│   └── terraform-plan-check.yaml
├── constraints/             # Constraint instances per environment
│   ├── dev/
│   │   └── k8s-security-baseline.yaml
│   ├── staging/
│   │   └── k8s-security-baseline.yaml
│   └── prod/
│       └── k8s-security-baseline.yaml
├── test/                    # Unit and integration tests
│   ├── unit/
│   │   └── k8s_security_test.rego
│   └── integration/
│       └── gatekeeper_e2e_test.sh
└── ci/
    ├── policy-lint.yaml
    ├── policy-test.yaml
    └── policy-deploy.yaml
```

**Rationale:** This layout isolates reusable logic (`library/`) from deployment artifacts (`templates/`, `constraints/`), enables environment-specific parameterization via `constraints/<env>/`, and keeps CI pipelines co-located with the policies they validate.

### 2. Implement shared library modules

Create reusable Rego modules in `library/` that encode organizational standards. Import them in templates and CI policies to avoid duplication.

Example `library/k8s/pod_security.rego`:

```rego
package org.policies.k8s.pod_security

# Baseline deny rules shared across templates and CI checks
deny_privileged[msg] {
    container := input.spec.containers[_]
    container.securityContext.privileged == true
    msg := sprintf("Container %v runs privileged", [container.name])
}

deny_host_network[msg] {
    input.spec.hostNetwork == true
    msg := "hostNetwork is not permitted"
}

deny_host_path[msg] {
    volume := input.spec.volumes[_]
    volume.hostPath
    msg := sprintf("Volume %v uses hostPath", [volume.name])
}
```

Example `library/common/labeling.rego`:

```rego
package org.policies.common.labeling

required_labels := {"team", "environment", "app"}

missing_labels[label] {
    label := required_labels[_]
    not input.metadata.labels[label]
}
```

### 3. Build ConstraintTemplates that import library modules

Gatekeeper ConstraintTemplates embed Rego directly. Use the `library/` modules by copying them into the template or by mounting them via ConfigMap (advanced). For simplicity and portability, inline the required rules.

Example `templates/k8s-security-baseline.yaml`:

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
      validation:
        openAPIV3Schema:
          type: object
          properties:
            allowedRegistries:
              type: array
              items:
                type: string
            exemptNamespaces:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8s.security_baseline

        import data.org.policies.k8s.pod_security
        import data.org.policies.common.labeling

        # Violation format expected by Gatekeeper
        violation[{"msg": msg, "details": {}}] {
            pod_security.deny_privileged[msg]
            input.review.kind.kind == "Pod"
        }
        violation[{"msg": msg, "details": {}}] {
            pod_security.deny_host_network[msg]
            input.review.kind.kind == "Pod"
        }
        violation[{"msg": msg, "details": {}}] {
            labeling.missing_labels[msg]
            input.review.kind.kind == "Namespace"
        }
```

**Note:** The `import data.org.policies...` paths assume the library modules are installed as ConfigMaps in the `gatekeeper-system` namespace under the same package structure. See step 5 for deployment.

### 4. Parameterize constraints per environment

Constraints in `constraints/<env>/` instantiate templates with environment-specific parameters.

Example `constraints/dev/k8s-security-baseline.yaml`:

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sSecurityBaseline
metadata:
  name: k8s-security-baseline-dev
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
      - apiGroups: [""]
        kinds: ["Namespace"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
  parameters:
    allowedRegistries:
      - "docker.io"
      - "ghcr.io"
    exemptNamespaces:
      - "dev-*"
```

Example `constraints/prod/k8s-security-baseline.yaml`:

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sSecurityBaseline
metadata:
  name: k8s-security-baseline-prod
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
      - apiGroups: [""]
        kinds: ["Namespace"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
  parameters:
    allowedRegistries:
      - "registry.internal.corp"
    exemptNamespaces: []
```

### 5. Deploy library modules as Gatekeeper data

Gatekeeper can load Rego modules as data via ConfigMaps in the `gatekeeper-system` namespace. This makes `library/` modules available to all templates without inlining.

Create a ConfigMap from the `library/` directory:

```bash
kubectl create configmap opa-policy-library \
  --from-file=library/ \
  -n gatekeeper-system \
  --dry-run=client -o yaml > library-configmap.yaml
```

Annotate the ConfigMap so Gatekeeper loads it:

```yaml
metadata:
  annotations:
    gatekeeper.sh/policy-lib: "true"
```

Apply the ConfigMap before deploying ConstraintTemplates that import the library.

### 6. Validate policies in CI before merge

Add a CI pipeline that runs on every pull request:

```yaml
# ci/policy-test.yaml (GitHub Actions example)
name: Policy Tests
on: [pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install OPA
        run: |
          curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
          chmod +x opa
          sudo mv opa /usr/local/bin/
      - name: Run unit tests
        run: opa test ./test/unit -v
      - name: Lint Rego
        run: opa fmt -l ./library ./templates
      - name: Validate ConstraintTemplates
        run: |
          for f in ./templates/*.yaml; do
            gatekeeper verify "$f" || exit 1
          done
      - name: Test against sample resources
        run: |
          opa eval -d ./library -i ./test/fixtures/valid-pod.json "data.org.policies.k8s.pod_security.deny_privileged"
          opa eval -d ./library -i ./test/fixtures/bad-pod.json "data.org.policies.k8s.pod_security.deny_privileged" | grep -q "privileged"
```

**Key checks:**
- `opa test` runs Rego unit tests (files ending in `_test.rego`)
- `opa fmt -l` catches syntax errors and formatting issues
- `gatekeeper verify` validates ConstraintTemplate CRD structure
- Sample resource evaluation confirms policy behavior before deployment

### 7. Promote constraints through environments

Use a promotion pipeline that applies constraints progressively:

```yaml
# ci/policy-deploy.yaml
name: Policy Deploy
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [dev, staging, prod]
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - name: Apply library ConfigMap
        run: kubectl apply -f library-configmap.yaml
      - name: Apply ConstraintTemplates
        run: |
          for f in ./templates/*.yaml; do
            kubectl apply -f "$f"
          done
      - name: Apply Constraints for environment
        run: |
          kubectl apply -f ./constraints/${{ github.event.inputs.environment }}/
      - name: Wait for audit
        run: |
          sleep 30
          kubectl get constraints -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.totalViolations}{"\n"}{end}'
```

**Promotion gates:**
- `dev`: Auto-deploy on merge to main
- `staging`: Manual approval, run audit-only mode first (`enforcementAction: dryrun`)
- `prod`: Manual approval, require zero new violations in staging audit

### 8. Extend to Terraform and CI gate checks

Reuse the same `library/` modules for Terraform plan validation and generic CI gates.

Example Terraform policy `ci/terraform-gate.rego`:

```rego
package org.policies.terraform

import data.org.policies.terraform.aws_security

violation[msg] {
    aws_security.deny_public_s3[msg]
    input.resource_changes[_]
}
```

Run in CI:

```bash
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
opa eval --format pretty --data library/terraform/aws_security.rego --data ci/terraform-gate.rego --input tfplan.json "data.org.policies.terraform.violation"
```

## Verify

- All unit tests pass: `opa test ./test/unit`
- ConstraintTemplates apply without CRD errors: `gatekeeper verify ./templates/*.yaml`
- Constraints create successfully in each target environment
- Audit reports zero unexpected violations in staging before prod promotion
- Terraform plan gate blocks non-compliant changes in CI

## Common errors

- **Library import path mismatch** — ConstraintTemplates import `data.org.policies...` but the ConfigMap mounts modules under a different package path. Verify with `kubectl get configmap opa-policy-library -n gatekeeper-system -o yaml` and ensure the file structure matches the import statements.
- **ConstraintTemplate version drift** — Gatekeeper 3.12+ uses `v1` for ConstraintTemplate and Constraint CRDs; older versions use `v1beta1`. Check `kubectl api-resources | grep constraint` before applying.
- **ExcludedNamespaces not effective** — Namespaces listed in `excludedNamespaces` must exist at apply time. Create system namespaces first or use a post-install hook.
- **Parameters silently ignored** — A Constraint missing a required `parameters` field uses template defaults. Define explicit defaults in the template's `openAPIV3Schema` and validate with `gatekeeper verify`.
- **Audit lag** — Gatekeeper's audit scanner runs periodically (default 60s). New violations may not appear immediately after constraint creation. Wait or trigger manual audit: `kubectl exec -n gatekeeper-system deploy/gatekeeper-controller-manager -- gatekeeper audit`.

## References

- OPA Gatekeeper documentation: ConstraintTemplate and Constraint CRD reference
- Rego policy language specification
- Policy-as-code patterns for multi-environment Kubernetes governance