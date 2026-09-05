---
last_verified: 2026-09-04
tool_version: n/a
sources: []
---

# Combining Configuration Management with CI/CD Pipeline Concepts

## Purpose

Configuration management tools and CI/CD pipelines solve different problems, but they overlap where infrastructure changes need the same review, test, and approval cadence as application code. This doc walks through the integration patterns that connect the two — primarily how Terraform plan outputs and Ansible playbook runs become first-class citizens in a pipeline.

## When to use this pattern

Use a CM+CI/CD integration when:
- Infrastructure changes require peer review before apply.
- Multiple environments (dev → staging → prod) need promotion gates.
- Drift between declared and actual state must be detected automatically.
- Compliance evidence (who changed what, when, and whether tests passed) must be captured.

## Prerequisites

- A configuration management tool in use (Terraform, Ansible, CloudFormation, or similar).
- A CI platform that can run shell steps and store artifacts (GitHub Actions, GitLab CI, Jenkins).
- State storage accessible from CI runners (remote backend for Terraform, inventory for Ansible).
- Branch protection and required reviews enabled on the infrastructure repository.

## Integration patterns

### Pattern 1 — Terraform plan as a required pipeline check

The most common integration runs `terraform plan` in CI and posts the output as a PR comment or artifact. The plan step never calls `apply`; it only surfaces what would change.

Typical sequence:
1. Checkout infrastructure repository.
2. Initialize Terraform with the remote backend (S3 + DynamoDB lock, or equivalent).
3. Run `terraform plan -out=tfplan` and upload the binary artifact.
4. Require a human reviewer to approve before a separate `apply` job runs — usually gated on a manual approval step or a merge to main.

This pattern keeps the review surface in the PR, where the team is already looking, rather than burying it in a separate dashboard.

### Pattern 2 — Ansible playbook lint and test before deploy

Ansible changes benefit from syntax and idempotency checks before they reach a real environment. CI can run:
- `ansible-lint` against changed playbooks.
- `ansible-playbook --check` (dry-run mode) against a disposable staging inventory.
- A full apply against a dedicated test environment after the lint stage passes.

The key distinction is that `--check` only reports what would change; it does not enforce idempotency against a live system. A separate test environment catches the cases where `--check` gives a false pass because the target already matches the desired state.

### Pattern 3 — Drift detection as a scheduled job

Even with CI gates in place, manual changes or external events can drift infrastructure away from the declared state. A scheduled pipeline job (nightly or weekly) runs `terraform plan` or an Ansible idempotency check against production state and alerts when drift is found. Drift detection does not auto-remediate by default; it opens an incident or a remediation PR so the team can decide whether to import the change or re-apply the declaration.

### Pattern 4 — Promotion gates across environments

Infrastructure changes typically flow through dev → staging → prod. The pipeline promotes the same plan artifact (or Ansible playbook version) through each stage. Each promotion step re-runs the plan against the target environment's state before applying. This catches environment-specific drift early — a plan that was clean in dev may surface resource conflicts in staging that weren't visible before.

## Verify

After setting up the integration:
- Open an infrastructure PR and confirm the plan step runs and surfaces changes.
- Verify that the apply step is gated (manual approval or branch rule) and does not fire automatically on PR open.
- Introduce a deliberate drift change manually in a test environment and confirm the drift detection job reports it.
- Check that plan artifacts are retained for the audit window your compliance framework requires.

## Common errors

- **Running apply in the same job as plan.** Separate the two with an explicit gate; otherwise a reviewer can approve the PR and accidentally approve the apply in the same workflow run.
- **Backend initialization failures in CI.** Remote state backends require credentials (AWS keys, GCP service account JSON) injected as CI secrets. A missing or misconfigured secret causes `terraform init` to fail silently or prompt for input, which hangs the runner.
- **Ansible inventory drift in CI.** The inventory used by `--check` in CI must match production's structure. A simplified test inventory can hide errors that only surface against the real inventory.
