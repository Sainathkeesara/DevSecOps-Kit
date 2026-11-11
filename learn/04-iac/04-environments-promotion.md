---
last_verified: 2026-11-11
tool_version: n/a
sources: []
---

# Promote a change from dev to prod

You can describe infrastructure once in a module and deploy it to many environments. This lesson shows how to split that infrastructure into a `dev` and a `prod` environment that share the same module, make a change in `dev`, and promote it to `prod` through a CI gate — so nothing reaches production without a reviewed, green run. It builds on the remote-state and apply/destroy workflow from the previous lesson.

## What you'll learn
- Structure dev and prod environments that share modules
- Promote a reviewed change from dev to prod through CI

## Before you start
- [Plan, apply and destroy with remote state](03-terraform-plan-apply-destroy.md) — you can initialize, plan, apply, and destroy, and you know state lives in a `terraform.tfstate` file
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — you know how a pull-request workflow gates a merge on a green run
- [Terraform module composition patterns](../../terraform/docs/terraform-module-composition.md) — modules are the unit of reuse and environment containers wire them together
- `terraform` must be installed. Confirm it with `terraform --version`.

## Walkthrough

1. Create the shared module that both environments consume. Save it as `modules/sample-app/main.tf` ([companion file](../../terraform/configs/environments-promotion/modules/sample-app/main.tf)):

   ```hcl
   variable "environment" {
     description = "The environment name: dev or prod."
     type        = string
   }

   variable "instance_count" {
     description = "How many app replicas to deploy."
     type        = number
     default     = 1
   }

   resource "null_resource" "sample_app" {
     count = var.instance_count

     provisioner "local_exec" {
       command = "echo \"sample-app deployed to ${var.environment} (replica ${count.index})\" > app-deployed-${var.environment}-${count.index}.txt"
     }
   }

   output "instance_count" {
     value       = var.instance_count
     description = "Number of replicas deployed."
   }
   ```

   The module owns one concern — deploying the sample app — and takes everything that varies between environments (`environment`, `instance_count`) as variables. That variable set is the contract the module keeps stable.

2. Create the `dev` environment container that consumes the module with dev-sized values, plus its own backend config so dev state is stored separately from prod:

   ```hcl
   # environments/dev/main.tf
   module "sample_app" {
     source         = "../../modules/sample-app"
     environment    = "dev"
     instance_count = 1
   }
   ```

   ```hcl
   # environments/dev/backend.hcl
   bucket         = "mycompany-terraform-state"
   key            = "environments/dev/terraform.tfstate"
   region         = "us-east-1"
   dynamodb_table = "terraform-locks"
   encrypt        = true
   ```

3. Create the `prod` environment container with the same module but prod-sized values and its own backend:

   ```hcl
   # environments/prod/main.tf
   module "sample_app" {
     source         = "../../modules/sample-app"
     environment    = "prod"
     instance_count = 3
   }
   ```

   ```hcl
   # environments/prod/backend.hcl
   bucket         = "mycompany-terraform-state"
   key            = "environments/prod/terraform.tfstate"
   region         = "us-east-1"
   dynamodb_table = "terraform-locks"
   encrypt        = true
   ```

   Each environment has its own backend (its own state file and lock table), so a lock or corruption in dev never blocks prod, and vice versa — the separation the module-composition doc recommends.

4. Initialize and apply in `dev`. From `environments/dev/`:

   ```bash
   terraform init -backend-config=backend.hcl
   terraform plan
   terraform apply -auto-approve
   ```

   `terraform plan` shows one `null_resource` to add; `apply` creates it and reports `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`

5. Make a change in `dev`: raise `instance_count` from `1` to `2` in `environments/dev/main.tf`. Then plan and apply:

   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

   The plan now shows one resource to add (the second replica). Confirm `app-deployed-dev-1.txt` appears alongside `app-deployed-dev-0.txt`.

6. Promote the change to `prod` through CI. Open a pull request that updates `environments/prod/main.tf` to `instance_count = 2` (matching what dev now runs). CI runs the promotion workflow ([companion file](../../terraform/configs/environments-promotion/promote-ci.yml)):

   ```yaml
   name: Promote dev to prod

   on:
     pull_request:
       branches: [master]
     push:
       branches: [master]

   jobs:
     plan-prod:
       name: Plan prod
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: hashicorp/setup-terraform@v3
         - run: terraform init -backend-config=environments/prod/backend.hcl
           working-directory: environments/prod
         - run: terraform plan
           working-directory: environments/prod

     apply-prod:
       name: Apply prod
       needs: plan-prod
       if: github.event_name == 'push' && github.ref == 'refs/heads/master'
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: hashicorp/setup-terraform@v3
         - run: terraform init -backend-config=environments/prod/backend.hcl
           working-directory: environments/prod
         - run: terraform apply -auto-approve
           working-directory: environments/prod
   ```

   The `plan-prod` job runs on every pull request so a reviewer can see exactly what will change. The `apply-prod` job only runs on a push to master, after the PR is merged and `plan-prod` is green — that's the promotion gate.

   You should see: a PR run where `plan-prod` completes and `apply-prod` is skipped; after merge, a master run where `apply-prod` runs and reports `Apply complete!`.

## Exercise
Working alone, in a copy of `terraform/configs/environments-promotion/`:

1. Add a `staging` environment directory that consumes the same `modules/sample-app` module with `instance_count = 2` and its own `backend.hcl`.
2. Initialize, plan, and apply in `staging`, and confirm it creates two replicas without touching `dev` or `prod` state.
3. Add `staging` to the promotion workflow so a PR plans staging and a merge to master applies it.

Do not paste the solution into the lesson file.

## Check your work
```bash
cd environments/staging
terraform init -backend-config=backend.hcl
terraform plan
```
`terraform init` reports the backend is configured and `terraform plan` shows two `null_resource.sample_app` instances to add. Then confirm the other environments are unchanged:
```bash
cd ../dev && terraform plan
cd ../prod && terraform plan
```
Both report `No changes. Your infrastructure matches the configuration.`

## Common mistakes
- Sharing one `terraform.tfstate` across dev and prod — then a dev apply can overwrite prod state; give each environment its own backend and state file.
- Hardcoding `instance_count` in the module instead of passing it as a variable — then dev and prod can't differ, and you lose the point of sharing a module.
- Running `terraform apply` in prod directly from your laptop instead of through the PR gate — promotion should happen through CI after review, not as a local manual step.

## Next
[Block the public bucket with Checkov](../../00_index/learning-path.md)
