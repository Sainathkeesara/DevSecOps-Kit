---
last_verified: 2026-09-29
tool_version: n/a
sources: []
---

# Environments quickstart — what tripped me up

> Walking the per-environment quickstart for `environments/` and writing down the three things that actually stopped me.

## The quickstart itself

The loop is short: pick a directory, initialise, validate, plan.

```bash
cd environments/dev
terraform init
terraform validate
terraform plan -out=dev.tfplan
```

Each of `environments/dev`, `environments/staging` and `environments/prod` is a self-contained root module — same four files (`main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`) pointed at the shared module in `templates/terraform/multi-env/vpc-module.tf`. So "switching environments" means changing directory, not editing values.

One caveat before the trip-ups: the Terraform CLI isn't installed in this container, so I traced all of this by reading the config rather than by running `init`/`validate`. The findings below come from reading the files and comparing them against each other, not from captured command output.

## Got stuck on: init stops at the S3 backend

`environments/dev/main.tf` declares a `backend "s3"` block pointing at bucket `terraform-state-123456789012-multi-env` with `dynamodb_table = "terraform-state-lock"`. `terraform init` needs working AWS credentials and both of those resources to already exist, and there's no bootstrap for them anywhere in the repo. That's the first wall: the state store has to be created out of band before the quickstart can even start.

The good bit is that `key` differs per directory (`dev/terraform.tfstate`, and the same pattern in the other two), so the three environments never overwrite each other's state — as long as you always `init` from inside the directory.

## Got stuck on: duplicated output blocks

`main.tf` and `outputs.tf` both define five of the same outputs in every environment directory: `environment`, `vpc_id`, `vpc_cidr`, `public_subnet_ids` and `private_subnet_ids`. Terraform rejects duplicate output definitions, so `validate` fails before it ever reaches the module. The fix is mechanical — keep `outputs.tf` (it has the descriptions and the two security group outputs) and delete the copies at the bottom of `main.tf`.

## Got stuck on: which directory the plan ran from

`terraform.tfvars` is only picked up automatically from the directory you run the command in. Running `terraform plan` from the repo root finds no environment values at all and quietly falls back to the defaults in `variables.tf`, which are dev's values. That's a nasty way to think you planned staging.

## What I'd try next

- A small bootstrap that creates the state bucket and the lock table once, documented next to `environments/`.
- Fold the outputs into `outputs.tf` only, across all three directories.
- A per-environment wrapper so I stop typing the same four commands with a different directory each time.

For reference, the minimal per-tier settings are captured in `environments/configs/2026-09-29-minimal-environments-config.yaml`, and the first single-environment variable set I wrote is still in `environments/configs/2026-09-19-first-variable-set.yaml`.
