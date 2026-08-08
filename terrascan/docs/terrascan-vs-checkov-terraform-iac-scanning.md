---
last_verified: 2026-08-08
tool_version: n/a
sources:
  - https://www.checkov.io/7.Scan%20Examples/Terraform%20Plan%20Scanning.html
  - https://docs.terrateam.io/integrations/external-tools/checkov
  - https://www.checkov.io/4.Integrations/GitHub%20Actions.html
  - https://dev.to/ikers/applying-sast-to-infrastructure-as-code-without-tfsec-4b3d
  - https://hams.tech/blog/terraform-ci-cd-2026-automated-testing-infracost-terratest.html
  - https://github.com/bridgecrewio/checkov/releases/tag/3.3.9
---

# Terrascan vs Checkov: comparing IaC scanning for Terraform

> A side-by-side comparison of where each scanner adds value in a Terraform pipeline. This is one way to stage both tools together — Terrascan's own docs and Checkov's docs each tell a fuller story for the tool alone.

## Purpose

Terrascan and Checkov overlap sharply on Terraform: both are static analyzers for Infrastructure as Code that ship rule libraries for cloud providers and both support custom policies. The differences matter for where you place each in a pipeline. Terrascan leans into policy-as-code with Rego-based custom rules and multi-format coverage (Terraform, CloudFormation, Kubernetes); Checkov leans into plan-file scanning (findings on the resolved resource graph), SARIF for the GitHub Security tab, and baseline mode for gradual adoption on an established codebase. Use this doc as a decision aid, not a replacement for either tool's docs.

Checkov's current release is 3.3.9; Terrascan ships as a standalone binary — see the [in-repo primer](../notes/0000-primer-terrascan.md) for install options.

## Steps

### 1. Scan Terraform configuration files

Both tools scan a directory of `.tf` files directly, with different flag shapes:

- Checkov selects the IaC framework explicitly: `checkov -d . --framework terraform`. It can emit SARIF via `--output sarif` for the GitHub Security tab.
- Terrascan scans with auto-detection of the IaC type: `terrascan scan -d .`.

### 2. Scan the Terraform plan

A generated plan evaluates what will actually be created after variable and module resolution — a raw-file scan can't see that. The plan-file workflow is `terraform show -json tfplan.binary > tfplan.json`, then `checkov -f tfplan.json`. Plan-enriched scans merge source `.tf` file paths back in with `--repo-root-for-plan-enrichment`, and `--deep-analysis` resolves locals and connections the plan alone leaves incomplete.

Terrascan also has a plan-based workflow — see the notes on [plan-based scanning](../notes/2026-07-10-terrascan-getting-started-trip-ups.md). One caveat shared by both tools: plan files may contain dynamically injected secrets, so this step should run inside a secure CI environment, not on a developer workstation.

### 3. Bring custom policy-as-code

Custom rules are where the authoring models diverge most clearly.

- Checkov loads external checks from a directory as Python classes or YAML definitions. An inline `# checkov:skip=<check_id>:<reason>` comment on a resource suppresses a specific check in place.
- Terrascan loads custom policies written in Rego. A policy is defined with `apiVersion: v1, kind: policy`, a `metadata` block carrying the rule name, severity, and category, and a `spec.rego` block holding the Rego logic. Example policy definitions live in the [custom S3 rule config](../configs/tried-custom-s3-rule.yaml).

### 4. Gate the build on severity

- Checkov gates via a repo-root `.checkov.yaml` with `hard-fail-on`/`soft-fail-on` to break the build on critical/high while only reporting medium/low. Its GitHub Action feeds the Security tab with `output_format: cli,sarif`, and `soft_fail` controls whether findings fail the step.
- Terrascan gates via its severity flag and exit behavior. Because Terrascan's exit-code behavior has varied across releases, the robust pattern — used in the [policy-as-code workflow script](../scripts/policy-as-code-workflow.sh) — is to parse the JSON output, count findings at or above the threshold severity, and fail the step explicitly.

### 5. Adopt on an existing codebase

- Checkov's baseline mode (`--create-baseline`) accepts the current state and only blocks new violations, which makes it practical to add policy checking to an established project without a triage sprint. Terrateam also embeds Checkov as a plan-scan step via a `workflows` entry in `.terrateam/config.yml`, returning findings inline with the plan diff.
- Terrascan has no single baseline flag; gradual adoption is done by scanning a directory incrementally and treating the custom policy set as the source of truth, tightening severity over time.

## Verify

Run both scanners against a directory of known-misconfigured Terraform (for example, the deliberately insecure template in [snippets/insecure-terraform.tf](../snippets/insecure-terraform.tf)) and compare the rule IDs and severities each surfaces. The two tools use different rule libraries, so they will not agree on every finding — run both and treat the union as the baseline while you tune custom rules.
