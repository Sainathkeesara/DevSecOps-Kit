---
last_verified: 2026-08-30
tool_version: n/a
sources: []
---

# Checkov Multi-Repository Drift Detection and Auto-PR Remediation Scaffold

A project scaffold for detecting infrastructure drift across multiple repositories using Checkov and automatically opening pull requests with remediation. Designed for organizations managing Infrastructure-as-Code across many repositories who need consistent drift detection and automated remediation workflows.

## Purpose

Provide a reusable, configurable scaffold that:
- Scans multiple repositories on a schedule for IaC drift against a baseline
- Runs Checkov with custom drift-detection policies
- Automatically creates pull requests with suggested fixes for common drift patterns
- Integrates with GitHub Code Scanning via SARIF upload

## When to use

- An organization manages Terraform, Kubernetes, or CloudFormation across 10+ repositories
- Drift detection must run on a schedule (not just on PR) to catch out-of-band changes
- Remediation for common drift patterns (tag drift, security group rule changes, public access modifications) should be automated
- Teams want a consistent drift detection baseline without duplicating workflow configuration per repository

## Prerequisites

- GitHub organization with admin access to configure repository secrets and Actions permissions
- Checkov 3.x compatible with the IaC frameworks in use (Terraform, Kubernetes, CloudFormation, ARM, Dockerfile, Helm)
- A baseline branch or tag per repository representing the "known good" state
- GitHub App or Personal Access Token with `repo`, `workflow`, and `security-events` scopes for cross-repository PR creation and SARIF upload
- Python 3.10+ available on GitHub Actions runners (for the remediation script)

## Steps

### 1. Deploy the central workflow repository

Create a dedicated repository (e.g., `iac-drift-detection`) to host the reusable workflow and shared policies:

```bash
cp -r multi-repo-drift-auto-pr-remediation /path/to/iac-drift-detection
cd /path/to/iac-drift-detection
git init && git add . && git commit -m "Initial drift detection scaffold"
git remote add origin https://github.com/your-org/iac-drift-detection.git
git push -u origin main
```

### 2. Configure organization secrets

In the GitHub organization settings, add the following secrets:

| Secret name | Description |
|-------------|-------------|
| `DRIFT_DETECTION_TOKEN` | GitHub App installation token or PAT with `repo`, `workflow`, `security-events` scopes |
| `CHECKOV_BASELINE_REFS` | JSON map of `repository: baseline-ref` pairs (e.g., `{"repo-a": "main", "repo-b": "v2.1.0"}`) |
| `REMEDIATION_PR_LABELS` | Comma-separated labels to apply to auto-generated PRs (default: `drift,auto-remediation`) |

### 3. Customize drift detection policies

Edit the policy files in `drift-policies/` to match organizational requirements. Each policy targets a specific drift pattern:

```yaml
# drift-policies/tag_drift.yaml
metadata:
  id: CKV_DRIFT_TAG_001
  name: "Detect missing required tags on AWS resources"
  category: "DRIFT"
scope:
  provider: aws
definition:
  cond_type: attribute
  resource_types:
    - aws_instance
    - aws_s3_bucket
    - aws_ebs_volume
  attribute: tags
  operator: has_key
  value: "Environment"
```

### 4. Configure repository list

Edit `repositories.yaml` to list all repositories to scan:

```yaml
repositories:
  - name: your-org/infra-aws-prod
    baseline_ref: main
    frameworks:
      - terraform
      - kubernetes
    drift_policies:
      - tag_drift
      - sg_rule_drift
      - public_access_drift
  - name: your-org/infra-azure-staging
    baseline_ref: main
    frameworks:
      - terraform
      - arm
    drift_policies:
      - tag_drift
      - public_access_drift
```

### 5. Enable the scheduled workflow

The workflow `.github/workflows/drift-detection.yml` runs on a cron schedule (default: daily at 02:00 UTC). Adjust the schedule in the workflow file if needed:

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 02:00 UTC
  workflow_dispatch:     # Manual trigger
```

### 6. Review and merge auto-generated PRs

When drift is detected, the workflow:
1. Runs Checkov with drift policies against each repository's baseline
2. Generates a SARIF report uploaded to GitHub Code Scanning
3. For supported drift patterns, creates a branch with fixes and opens a PR
4. Applies configured labels and assigns reviewers via `CODEOWNERS`

Review the PR, verify the changes, and merge. The workflow re-runs on the merged PR to confirm remediation.

## Verify

- Trigger the workflow manually via **Actions → Drift Detection → Run workflow**
- Confirm the workflow completes with a matrix of repository scans
- Check the **Security → Code Scanning** tab for SARIF results from each repository
- Verify auto-generated PRs appear in target repositories with correct fixes
- Merge a test PR and confirm the next scheduled run shows the drift as resolved

## Common errors

| Error | Likely cause |
|-------|--------------|
| `Resource not accessible by integration` | `DRIFT_DETECTION_TOKEN` lacks `repo` or `workflow` scope for the target repository |
| `No such file or directory: drift-policies` | The `drift-policies/` directory was not committed or the path in the workflow is incorrect |
| SARIF upload succeeds but no results appear | The SARIF `category` must match the Code Scanning configuration; workflow uses `checkov-drift-detection` |
| Checkov exits 0 but drift exists | The drift policy YAML may have a syntax error; run `checkov --external-checks-dir drift-policies --list` to verify |
| Auto-PR creation fails with `422 Validation Failed` | The target repository has branch protection requiring reviews; add the GitHub App to bypass or adjust protection rules |
| Remediation script produces invalid Terraform | The script uses regex-based fixes; complex drift requires manual intervention — the PR description notes limitations |

## File structure

```
multi-repo-drift-auto-pr-remediation/
├── README.md
├── repositories.yaml
├── drift-policies/
│   ├── tag_drift.yaml
│   ├── sg_rule_drift.yaml
│   ├── public_access_drift.yaml
│   └── encryption_drift.yaml
├── scripts/
│   └── remediate_drift.py
├── .github/
│   └── workflows/
│       ├── drift-detection.yml
│       └── reusable-checkov-drift.yml
└── example-caller-workflow.yml
```

## References

- Checkov custom policies documentation
- GitHub reusable workflows documentation
- GitHub Code Scanning SARIF upload documentation
- GitHub REST API for pull requests documentation