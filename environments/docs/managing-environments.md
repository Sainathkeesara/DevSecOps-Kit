---
last_verified: 2026-10-25
tool_version: n/a
sources:
  - /work/DevSecOps-Kit/environments/configs/2026-09-30-minimal-environments-config.yaml
  - /work/DevSecOps-Kit/environments/notes/2026-09-30-environments-quickstart-trip-ups.md
---

# Managing dev/staging/prod with the environments tool

## Purpose

This document describes how to manage infrastructure across dev, staging, and production environments using the `environments/` directory structure. It covers the promotion workflow, configuration patterns, and common operational tasks.

## Environment Structure

Each environment lives in its own subdirectory under `environments/`:

```
environments/
├── configs/                 # Shared YAML configuration
├── dev/                     # Development environment
│   ├── main.tf              # Backend + module call
│   ├── variables.tf         # Input variable definitions
│   ├── outputs.tf           # Output value definitions
│   └── terraform.tfvars     # Environment-specific values
├── staging/                 # Staging environment (same structure)
├── prod/                    # Production environment (same structure)
├── scripts/                 # Automation scripts
│   └── 2026-10-25-promote-environment.sh
└── docs/                    # This documentation
```

The three environment directories are **byte-identical** in `main.tf` and `variables.tf`. Only `terraform.tfvars` differs per environment. This means switching environments is a `cd` operation, not an editing operation.

## Configuration

Per-environment values are defined in two places:

1. **`environments/configs/2026-09-30-minimal-environments-config.yaml`** — canonical source for all environment-specific values (VPC CIDRs, AZs, subnet ranges, promotion gates)
2. **`environments/<env>/terraform.tfvars`** — Terraform-consumable subset of the above

The YAML config includes promotion gates:

| Environment | Apply Mode | Verification |
|-------------|------------|--------------|
| dev         | auto       | smoke tests  |
| staging     | auto       | integration tests |
| prod        | manual-approval | post-deploy verification |

## Promotion Workflow

The promotion script `environments/scripts/2026-10-25-promote-environment.sh` automates the dev → staging → prod flow.

### Basic Usage

```bash
# Full promotion to staging (runs dev then staging)
./environments/scripts/2026-10-25-promote-environment.sh -e staging -s promote

# Full promotion to production (runs dev, staging, then prod with manual approval)
./environments/scripts/2026-10-25-promote-environment.sh -e prod -s promote

# Single environment validation only
./environments/scripts/2026-10-25-promote-environment.sh -e dev -s validate

# Plan without applying
./environments/scripts/2026-10-25-promote-environment.sh -e staging -s plan
```

### Promotion Steps

Each environment goes through:

1. **Validate** — `terraform fmt -check` + `terraform validate`
2. **Plan** — `terraform init` (with correct backend key) + `terraform plan -out=<env>.tfplan`
3. **Apply** — `terraform apply <env>.tfplan` (with approval gate for prod)
4. **Verify** — Run environment-appropriate verification (smoke/integration/post-deploy)

The script enforces order: you cannot promote to staging without dev passing, and cannot promote to prod without staging passing.

## Backend Configuration (Critical)

**All three `main.tf` files currently declare the same S3 backend key:**

```hcl
backend "s3" {
  bucket         = "terraform-state-123456789012-multi-env"
  key            = "dev/terraform.tfstate"  # Same in all three!
  region         = "us-east-1"
  encrypt        = true
  dynamodb_table = "terraform-state-lock"
}
```

This is a known issue. Before running any real deployment, update each environment's `main.tf`:

- `dev/main.tf` → `key = "dev/terraform.tfstate"` (already correct)
- `staging/main.tf` → `key = "staging/terraform.tfstate"`
- `prod/main.tf` → `key = "prod/terraform.tfstate"`

The promotion script passes the correct key via `-backend-config` during `terraform init`, but the on-disk `main.tf` should match to avoid confusion.

## Common Operations

### Add a New Variable

1. Add the variable to `environments/dev/variables.tf` (with description and type)
2. Copy the same variable block to `staging/variables.tf` and `prod/variables.tf`
3. Add environment-specific values to each `terraform.tfvars`
4. Update `configs/2026-09-30-minimal-environments-config.yaml` with the new values
5. Run validation: `./scripts/2026-10-25-promote-environment.sh -e dev -s validate`

### Modify an Existing Value

1. Update `configs/2026-09-30-minimal-environments-config.yaml`
2. Update the corresponding `terraform.tfvars` in the target environment(s)
3. Plan and review: `./scripts/2026-10-25-promote-environment.sh -e <env> -s plan`
4. Promote through the chain

### Debug a Failed Plan

```bash
cd environments/staging
terraform init -backend-config="key=staging/terraform.tfstate"
terraform plan -out=staging.tfplan
terraform show staging.tfplan | less
```

### Rollback

Terraform state is the source of truth. To rollback:

```bash
cd environments/prod
terraform init -backend-config="key=prod/terraform.tfstate"
terraform state list
terraform plan -destroy -out=rollback.tfplan
# Review, then apply if correct
terraform apply rollback.tfplan
```

## Known Issues & Workarounds

| Issue | Workaround |
|-------|------------|
| Shared backend key across envs | Update each `main.tf` key before first real deployment |
| Duplicate outputs in `main.tf` + `outputs.tf` | Delete output blocks from `main.tf`; keep only `outputs.tf` |
| `terraform init` needs pre-existing S3 bucket + DynamoDB table | Create state bucket and lock table out-of-band first |
| Running `terraform plan` from repo root uses dev defaults | Always `cd` into the environment directory first |

## Extending the Model

To add a new environment (e.g., `qa`):

1. Create `environments/qa/` with the four standard files (copy from `dev/`)
2. Add `qa` entry to `configs/2026-09-30-minimal-environments-config.yaml`
3. Add `qa` to `TERRAFORM_DIRS` and `PROMOTION_ORDER` in the promotion script
4. Define its position in the promotion chain (e.g., between staging and prod)
5. Update verification types in the script for the new environment