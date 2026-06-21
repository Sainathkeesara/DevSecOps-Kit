# Checkov — Reusable GitHub Actions workflow for custom policies

A GitHub Actions reusable workflow that runs Checkov with support for external custom policies written in Checkov's graph-based YAML format. Designed for teams that need organization-specific compliance checks beyond the built-in rule set.

## Purpose

This workflow enables consistent Checkov scanning across repositories by centralising the scan configuration into a reusable action. Teams define custom policies once in a known directory structure and invoke the workflow from any repository that stores Infrastructure-as-Code. The workflow produces SARIF output for GitHub Code Scanning integration and supports configurable severity thresholds for CI gating.

## When to use

- Multiple repositories in an organisation need the same set of custom Checkov policies.
- A team maintains organisation-specific compliance rules (e.g. mandatory tags, internal network constraints) that the built-in Checkov rule set does not cover.
- CI pipelines require SARIF output for GitHub Code Scanning ingestion alongside standard CLI output.
- Policy definitions should live in a central repository and be reused without copying workflow files.

## Prerequisites

- Python 3.12 or later available on the runner (the workflow installs it via `actions/setup-python`).
- Checkov installed (the workflow installs it with `pip install checkov`).
- Custom policies written in Checkov's graph-based YAML format placed in a directory within the repository (default: `custom-policies/`).
- For SARIF upload: the calling workflow must grant `security-events: write` permission.

## Steps

### 1. Add the reusable workflow to your repository

Copy the `.github/workflows/reusable-checkov-custom-policies.yml` file into the repository that will host the reusable workflow.

### 2. Define custom policies

Create policy YAML files under a directory (default: `custom-policies/`) using Checkov's graph-based policy format:

```yaml
metadata:
  id: CKV_CUSTOM_S3_001
  name: "Ensure S3 buckets do not allow public ACLs"
  category: "NETWORKING"
scope:
  provider: aws
definition:
  cond_type: attribute
  resource_types:
    - aws_s3_bucket
  attribute: acl
  operator: not_equals
  value: private
```

### 3. Create a caller workflow

In any repository that should run Checkov with these policies, create a workflow that references the reusable workflow:

```yaml
name: IaC scan

on:
  push:
    branches: [master, main]
  pull_request:
    branches: [master, main]

jobs:
  checkov:
    uses: your-org/your-repo/.github/workflows/reusable-checkov-custom-policies.yml@main
    with:
      scan-directory: .
      frameworks: terraform,kubernetes,dockerfile
      custom-policy-dir: custom-policies
      severity-threshold: HIGH
      output-sarif: true
```

### 4. Commit and verify

Commit both the reusable workflow and the caller workflow. Push a PR that introduces a resources violating one of the custom policies. The workflow should fail the check and upload a SARIF report visible under the Security > Code Scanning tab.

## Verify

- Run Checkov locally against a test directory with the same custom policies to confirm the expected violations fire: `checkov --directory . --external-checks-dir custom-policies --framework terraform -o cli --compact`
- Confirm the SARIF file contains results with the correct rule IDs matching the custom policy metadata IDs.
- Trigger the caller workflow on a PR that fixes the violations and confirm the workflow exits successfully.

## Common errors

| Error | Likely cause |
|---|---|
| `No such file or directory: custom-policies` | The `custom-policy-dir` input points to a path that does not exist. Verify the directory is committed and the path is relative to the repository root. |
| SARIF upload succeeds but no results appear under Code Scanning | The SARIF `category` in both the upload step and the Code Scanning configuration must match. The workflow uses `checkov-custom-policies` as the default category. |
| Checkov exits 0 even though custom policies are present | The custom policy YAML may have a syntax error. Run `checkov --external-checks-dir custom-policies --list` to verify the policies are loaded. |
| Reusable workflow not found | The caller workflow references a path or branch that does not contain the reusable workflow file. Use the full repository reference `org/repo/.github/workflows/...@ref`. |

## References

- [Checkov custom policies documentation](https://www.checkov.io/7.Scan%20Configuration/Custom%20Policies.html)
- [GitHub reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Uploading SARIF data to GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/uploading-a-sarif-file-to-github)
