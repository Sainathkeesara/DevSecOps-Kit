---
last_verified: 2026-08-07
tool_version: n/a
sources:
  - https://pypi.org/project/checkov
  - https://docs.terrateam.io/integrations/external-tools/checkov
  - https://dev.to/ikers/applying-sast-to-infrastructure-as-code-without-tfsec-4b3d
  - https://hams.tech/blog/terraform-ci-cd-2026-automated-testing-infracost-terratest.html
  - https://oneuptime.com/blog/post/2026-02-12-checkov-terraform-security-scanning/view
---

# Terrascan vs Checkov: comparing IaC scanning for Terraform

## Purpose

Terrascan and Checkov overlap most sharply on Terraform: both are static
analyzers for Infrastructure as Code that ship rule libraries for cloud
providers and both support custom policies. This comparison is a decision aid for
placing each tool in a Terraform pipeline, not a replacement for either tool's
docs. The two differ in where they add the most value — Terrascan as a
policy-as-code engine with Rego-based custom rules, and Checkov for plan-file
scanning, build-time gates, and GitHub Security integration.

## When to use

- Use **Checkov** when the pipeline already produces Terraform plans and you
  want findings on the resolved resource graph, when you need SARIF in the
  GitHub Security tab, or when you want gradual adoption on an existing codebase
  via baseline mode.
- Use **Terrascan** when custom policy-as-code is the priority and you want a
  single scan to cover multiple IaC formats (Terraform, CloudFormation,
  Kubernetes, etc.) with severity-based gating.

## Prerequisites

- A Terraform project (configuration directory or generated plan).
- One of the two scanners installed. Checkov installs from PyPI; the current
  release is 3.3.9. Terrascan is a standalone binary — see the in-repo primer at
  [`terrascan/notes/0000-primer-terrascan.md`](../notes/0000-primer-terrascan.md)
  for install options.
- Optional: a `.terrascan-policies/` directory of custom policy files for
  Terrascan, or an `--external-checks-dir` directory for Checkov.

## Steps

### 1. Scan Terraform configuration files

Both tools scan a directory of `.tf` files directly. The invocations differ in
flag shape but are equivalent in intent:

- Checkov selects the IaC framework explicitly and scans the directory:
  `checkov -d . --framework terraform`. Output formats include CLI, JSON,
  CycloneDX, JUnit XML, CSV, and SARIF.
- Terrascan scans with auto-detection of the IaC type:
  `terrascan scan -d .`.

### 2. Scan the Terraform plan

Scanning a generated plan evaluates what will actually be created after
variables and module resolution, which a raw-file scan cannot see.

- Checkov reads the plan JSON and evaluates it as a graph. The plan is produced
  with `terraform show -json tfplan.binary`, then passed in:
  `checkov -f tfplan.json --framework terraform_plan`. Plan-enriched scans merge
  source `.tf` file paths back in with `--repo-root-for-plan-enrichment`, and
  `--deep-analysis` resolves locals and connections that the plan alone leaves
  incomplete.
- Terrascan can also evaluate a generated plan rather than raw files — see
  [`terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md`](../notes/2026-07-10-terrascan-getting-started-trip-ups.md)
  for the plan-based workflow. A note of caution shared by both tools: plan
  files may contain dynamically injected secrets, so this step should run inside
  a secure CI environment, not on a developer workstation.

### 3. Bring custom policy-as-code

Custom rules are where the two tools diverge most clearly in authoring model.

- Checkov loads external checks from a directory (`--external-checks-dir`) as
  Python classes or YAML definitions. A built-in `checkov:skip=<check_id>:<reason>`
  comment on a resource suppresses a specific check in place.
- Terrascan loads custom policies written in Rego. A policy is defined with
  `apiVersion: v1, kind: policy`, a `metadata` block carrying the rule name,
  severity, and category, and a `spec.rego` block holding the Rego logic. Example
  policy definitions live in [`terrascan/configs/tried-custom-s3-rule.yaml`](../configs/tried-custom-s3-rule.yaml).

### 4. Gate the build on severity

- Checkov gates via the repo-root `.checkov.yaml` config, which supports
  `hard-fail-on` and `soft-fail-on` to break the build on critical/high while
  only reporting medium/low. The official `bridgecwerio/checkov-action` GitHub
  Action surfaces these as `soft_fail` / `fail-on-severity` for CI.
- Terrascan gates via its severity flag and exit behavior. Because the exit-code
  semantics are inconsistent across releases, the robust pattern (used in
  [`terrascan/scripts/policy-as-code-workflow.sh`](../scripts/policy-as-code-workflow.sh)
  and the companion GitHub Actions manifest) is to parse the JSON output and
  count findings at or above the threshold severity, then fail the step
  explicitly.

### 5. Adopt on an existing codebase

- Checkov's baseline mode (`--create-baseline`) accepts the current state and
  only blocks new violations, which makes it practical to add policy checking to
  an established project without a triage sprint.
- Terrascan has no single baseline flag; gradual adoption is done by scanning a
  directory incrementally and treating the custom policy set as the source of
  truth, tightening severity over time.

## Verify

Run both scanners against a directory of known-misconfigured Terraform (for
example, the deliberately insecure template in
[`terrascan/snippets/insecure-terraform.tf`](../snippets/insecure-terraform.tf))
and compare the rule IDs and severities each surfaces. The two tools use
different rule libraries, so they will not agree on every finding — run both and
treat the union as the baseline while you tune custom rules.

## Common errors

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Plan scan misses an unused resource | Plan-based scanning only evaluates resources referenced by the deployment graph | Run a raw-file scan (`-d .`) as a second pass |
| Custom rule silently has no effect | Exception/field names do not match fields the rule condition actually uses | Read the original rule definition and match fields exactly |
| CI gate does not break on HIGH findings | Severity filter applied to display output, not to the pass/fail logic | Parse the JSON results and count threshold findings explicitly |
| Baseline shows too many findings | Policy set too strict for the current state | Narrow to critical/high first, then relax the baseline threshold |

## References

- [Checkov on PyPI (release 3.3.9)](https://pypi.org/project/checkov)
- [Checkov plan scanning guide (Terratream)](https://docs.terrateam.io/integrations/external-tools/checkov)
- [Scan-gated PR pattern with `.checkov.yaml`](https://dev.to/ikers/applying-sast-to-infrastructure-as-code-without-tfsec-4b3d)
- [Checkov + Trivy pairing for Terraform CI/CD](https://hams.tech/blog/terraform-ci-cd-2026-automated-testing-infracost-terratest.html)
- [Checkov GitHub Actions integration and SARIF](https://oneuptime.com/blog/post/2026-02-12-checkov-terraform-security-scanning/view)
- [Terrascan primer (in-repo)](../notes/0000-primer-terrascan.md)
