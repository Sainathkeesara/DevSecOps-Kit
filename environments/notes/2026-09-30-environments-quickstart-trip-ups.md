---
last_verified: 2026-09-30
tool_version: n/a
sources: []
---

# Environments quickstart — what tripped me up

> Walking the per-environment quickstart for `environments/` and writing down the four things that actually stopped me.

## The quickstart itself

The loop is short: pick a directory, initialise, validate, plan.

```bash
cd environments/dev
terraform init
terraform validate
terraform plan -out=dev.tfplan
```

Each of `environments/dev`, `environments/staging` and `environments/prod` is a self-contained root module — the same four files (`main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`) calling the shared module at `templates/terraform/multi-env/vpc-module.tf`. `md5sum` says `main.tf` and `variables.tf` are byte-identical across all three directories and only `terraform.tfvars` differs, so "switching environments" means `cd`, not editing values.

One caveat before the trip-ups: the Terraform CLI isn't installed in this container, so I traced all of this by reading the config rather than by running `init`/`validate`. Everything below comes from reading the files and diffing them against each other, not from captured command output.

## Got stuck on: all three environments share one state key

This is the one that actually stopped me, and it's the opposite of what I expected. I assumed the S3 backend `key` was namespaced per directory. It isn't. All three `main.tf` files declare byte-for-byte the same backend:

```hcl
backend "s3" {
  bucket         = "terraform-state-123456789012-multi-env"
  key            = "dev/terraform.tfstate"
  region         = "us-east-1"
  encrypt        = true
  dynamodb_table = "terraform-state-lock"
}
```

Same bucket, same `dev/terraform.tfstate` key, in `dev/`, `staging/` and `prod/`. So the three root modules are not isolated: a `terraform plan` run in `staging/` reads dev's state file, sees the dev VPC as the current state, and plans to destroy it in favour of staging's. The shared `dynamodb_table` is fine and deliberate — one lock for one bucket — but the key is the hazard. It's one line per directory to fix: `staging/terraform.tfstate` and `prod/terraform.tfstate`.

Worth noting the primer gets this wrong too. `0000-primer-environments.md` says "Staging and prod use their own keys" and shows a `dev/terraform.tfstate` snippet, which is exactly the assumption that sent me down the wrong path.

## Got stuck on: init stops at the S3 backend

Same block, different problem. `terraform init` needs working AWS credentials plus a bucket and a DynamoDB lock table that already exist, and there's no bootstrap for either anywhere in the repo. The state store has to be created out of band before the quickstart can start — and because of the shared key above, whoever creates that bucket has to be careful: the first `init` in any directory decides what that one state object means, and the three environments will fight over it.

## Got stuck on: duplicated output blocks

`main.tf` and `outputs.tf` both define `environment`, `vpc_id`, `vpc_cidr`, `public_subnet_ids` and `private_subnet_ids` in every environment directory. Terraform rejects duplicate output definitions, so `validate` fails before it ever reaches the module. The fix is mechanical — keep `outputs.tf` (it has the descriptions plus `bastion_security_group_id` and `app_security_group_id`) and delete the five copies at the bottom of `main.tf`.

## Got stuck on: which directory the plan ran from

`terraform.tfvars` is only loaded automatically from the directory you run the command in. Running `terraform plan` from the repo root finds no environment values at all and falls back to the defaults in `variables.tf` — and those defaults are dev's values (`environment = "dev"`, `vpc_cidr = "10.0.0.0/16"`). That's a quiet way to think you planned staging.

## What I'd try next

- Fix the two backend keys before anything else touches the bucket.
- Fold the outputs into `outputs.tf` only, across all three directories.
- A per-environment wrapper so I stop typing the same four commands with a different directory each time.

The minimal per-tier settings are in `environments/configs/2026-09-30-minimal-environments-config.yaml`, and the first single-environment variable set I wrote is still in `environments/configs/2026-09-19-first-variable-set.yaml`.
