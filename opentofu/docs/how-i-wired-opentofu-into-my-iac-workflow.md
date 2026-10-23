---
last_verified: 2026-10-23
tool_version: "1.8.0"
sources: []
---

# How I wired OpenTofu into my IaC workflow

## Purpose

This document describes how OpenTofu was integrated into an existing infrastructure-as-code workflow that previously used Terraform. It covers the migration path, CI/CD integration, state management, and team collaboration patterns that worked for a mid-sized team managing AWS and Kubernetes resources.

## When to use

- Migrating from Terraform to OpenTofu with minimal disruption
- Teams needing a drop-in Terraform-compatible workflow with open-source licensing
- Projects requiring OpenTofu-specific features (e.g., `tofu fmt` improvements, provider cache)
- Environments where HashiCorp's BUSL license creates compliance concerns

## Prerequisites

- OpenTofu 1.8.0+ installed (`tofu version` to verify)
- Existing Terraform configuration (0.12+ syntax compatible)
- Remote state backend configured (S3 + DynamoDB, Azure Storage, GCS, or Consul)
- CI/CD system with pipeline-as-code (GitHub Actions, GitLab CI, Azure Pipelines)
- Team familiarity with Terraform workflow (`init`, `plan`, `apply`, `destroy`)

## Steps

### 1. Verify compatibility and inventory

Run `tofu fmt -check -recursive` and `tofu validate` across all modules. OpenTofu 1.8.0 maintains full HCL compatibility with Terraform 1.5.x. Most configurations pass validation without changes. Note any provider version constraints in `required_providers` blocks — OpenTofu uses the same provider registry protocol.

```bash
# Dry-run validation across all workspaces
find . -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
  echo "Validating $dir"
  (cd "$dir" && tofu init -backend=false && tofu validate) || exit 1
done
```

### 2. Migrate state backend (if needed)

If using a remote backend, the existing state is compatible. No migration step is required — point the backend configuration to the same endpoint. For S3 backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}
```

Run `tofu init -migrate-state` once to reinitialize the backend with OpenTofu. This preserves all existing state and lock tables.

### 3. Update CI/CD pipelines

Replace `hashicorp/setup-terraform` with `opentofu/setup-opentofu` in GitHub Actions:

```yaml
- name: Setup OpenTofu
  uses: opentofu/setup-opentofu@v1
  with:
    tofu_version: "1.8.0"
    tofu_wrapper: true
```

The `tofu_wrapper: true` option creates a `terraform` symlink, allowing existing scripts that call `terraform` to work unchanged during transition.

Update plan/apply steps:

```yaml
- name: OpenTofu Plan
  id: plan
  run: |
    tofu fmt -check -recursive
    tofu init
    tofu plan -out=tfplan -detailed-exitcode
  continue-on-error: true

- name: OpenTofu Apply
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: |
    tofu apply -auto-approve tfplan
```

### 4. Configure provider cache (optional but recommended)

OpenTofu 1.7+ supports a shared provider cache to speed up `init` in CI:

```bash
export TOFU_PROVIDER_CACHE_DIR="/tmp/.tofu-providers"
tofu init -plugin-dir=$TOFU_PROVIDER_CACHE_DIR
```

In GitHub Actions, cache this directory between runs:

```yaml
- name: Cache OpenTofu providers
  uses: actions/cache@v4
  with:
    path: ~/.tofu.d/plugin-cache
    key: tofu-providers-${{ runner.os }}-${{ hashFiles('**/.terraform.lock.hcl') }}
```

### 5. Adopt OpenTofu-specific enhancements

- **`tofu fmt` improvements**: Stricter formatting rules catch inconsistencies Terraform's formatter misses. Run in pre-commit hooks.
- **`tofu graph` enhancements**: Better module dependency visualization for documentation.
- **Provider installation via `tofu providers mirror`**: Useful for air-gapped environments.

### 6. Team onboarding and documentation

Update internal runbooks to reference `tofu` commands. Key differences to communicate:

| Terraform | OpenTofu | Notes |
|-----------|----------|-------|
| `terraform` | `tofu` (or `terraform` with wrapper) | Wrapper enables gradual migration |
| `terraform providers mirror` | `tofu providers mirror` | Same flags, better progress output |
| `terraform fmt` | `tofu fmt` | Stricter, more consistent output |
| Registry: `registry.terraform.io` | Same registry | No provider changes needed |

## Verify

1. **Plan parity**: Run `tofu plan` on a feature branch and compare output with the last Terraform plan. Resource changes should be identical (zero diff).
2. **State integrity**: After `tofu init -migrate-state`, run `tofu state list` and verify resource count matches pre-migration.
3. **CI pipeline**: Trigger a pull request — `tofu plan` should pass with exit code 0 (no changes) or 2 (changes pending). Exit code 1 indicates error.
4. **Apply test**: In a staging workspace, run `tofu apply` and verify resources deploy correctly.
5. **Drift detection**: Run `tofu plan -refresh-only` to confirm no drift introduced by the migration.

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `Error: Failed to install provider` | Network/registry timeout in CI | Increase timeout, use provider cache, or mirror providers locally |
| `Error: Backend reinitialization required` | Backend config changed | Run `tofu init -migrate-state` or `tofu init -reconfigure` |
| `Error: Provider produced inconsistent result` | Provider bug or version mismatch | Pin provider version in `required_providers`, upgrade provider |
| `tofu: command not found` | Wrapper not enabled | Add `tofu_wrapper: true` to setup action or install `tofu` binary directly |
| `Error: Invalid legacy provider address` | Old provider source format | Update `required_providers` to use `source = "hashicorp/aws"` format |

## References

- `opentofu/notes/0000-primer-opentofu.md` — quick primer
- `opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md` — quickstart walkthrough
- `opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md` — test workflow notes
- `opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl` — minimal config example