---
last_verified: 2026-11-11
tool_version: n/a
---

# Plan, apply and destroy with remote state

You can describe infrastructure in HCL and preview changes with `terraform plan`. Now you'll run the full loop — initialize a project, apply the infrastructure, confirm a second plan reports no changes, then destroy everything cleanly. You'll also see how to keep the state file remote so a team shares one source of truth, and why state locking prevents two runs from corrupting that state at the same time.

## What you'll learn
- Apply the sample app's infrastructure and show a second plan has no changes
- Keep state remote and explain locking
- Destroy everything cleanly

## Before you start
- [Terraform — quick primer](../../terraform/notes/0000-primer-terraform.md) — providers, resources, state, and the init/plan/apply loop
- [Infrastructure as code — concepts](../../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — declarative configuration, the state file, and drift
- [YAML, JSON, jq and regex for security tooling](../01-foundations/06-yaml-json-jq-regex.md) — jq and python3 to validate structured output such as state files
- `terraform` must be installed. Confirm it with `terraform --version`.

## Walkthrough

1. Create a working directory and a small infrastructure config. Save it as `main.tf`:

   ```hcl
   resource "null_resource" "sample_app" {
     provisioner "local_exec" {
       command = "echo 'sample-app-configured' > app-config.txt"
     }
   }
   ```

   `null_resource` is built into Terraform, so this runs without downloading any provider.

2. Initialize the working directory. This reads the config and sets up state storage:

   ```bash
   terraform init
   ```

   You should see: `Terraform has been successfully initialized.`

3. Preview what Terraform will create:

   ```bash
   terraform plan
   ```

   You should see a plan that will add one resource (`null_resource.sample_app`).

4. Apply the configuration:

   ```bash
   terraform apply -auto-approve
   ```

   You should see `null_resource.sample_app: Creating...`, then `Creation complete`, then `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`

   Confirm `app-config.txt` now exists and contains `sample-app-configured`.

5. Run `terraform plan` again. Because the infrastructure already matches the configuration, Terraform reports nothing to change:

   ```bash
   terraform plan
   ```

   You should see: `No changes. Your infrastructure matches the configuration.`

   That's idempotence — applying the same config twice doesn't create duplicate resources.

6. Keep state remote with locking. Create `backend.hcl`:

   ```hcl
   bucket         = "my-team-terraform-state"
   region         = "us-east-1"
   key            = "sample-app/terraform.tfstate"
   dynamodb_table = "terraform-state-locks"
   encrypt        = true
   ```

   This stores `terraform.tfstate` in an S3 bucket and uses a DynamoDB table for locking. Locking means only one `apply` or `destroy` can run at a time — if a teammate starts an apply, your run waits or fails instead of both writing state at once and corrupting it.

   To switch to remote state you would run `terraform init -backend-config=backend.hcl` (and provide AWS credentials). The commands above keep state local so you can run them offline; swap in the backend block when you share state with a team. See `terraform/scripts/state-management-workflow.sh` for the full remote-state workflow including `lock = true` checks.

7. Destroy everything cleanly:

   ```bash
   terraform destroy -auto-approve
   ```

   You should see `null_resource.sample_app: Destroying...`, then `Destruction complete`, then `Destroy complete! Resources: 1 destroyed.`

   Confirm `app-config.txt` is gone and `terraform plan` now shows one resource to add again.

## Exercise
Working alone, in a fresh directory:

1. Write a `main.tf` that creates two `null_resource` resources, each using `local_exec` to write a different file.
2. Run `terraform init`, `terraform plan`, and `terraform apply -auto-approve`.
3. Run `terraform plan` again and confirm it reports no changes.
4. Add a `backend.hcl` with an S3 bucket, region, key, DynamoDB lock table, and `encrypt = true`, then explain in one sentence what the DynamoDB table is for.
5. Run `terraform destroy -auto-approve` and confirm both files are removed.

Do not paste the solution into the lesson file.

## Check your work
```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform plan
terraform destroy -auto-approve
```
`terraform init` initializes; `terraform plan` before apply shows resources to add; `terraform apply -auto-approve` creates them; the second `terraform plan` reports `No changes.`; `terraform destroy -auto-approve` removes everything and reports `Destroy complete!`.

## Common mistakes
- Forgetting `terraform init` before `terraform plan` — plan fails until the backend and providers are initialized.
- Editing `terraform.tfstate` by hand — state is Terraform's private record; change infrastructure through config and apply, never by editing state directly.
- Running two applies at once against remote state without locking — both can write state simultaneously and corrupt it; always configure a lock table when sharing state.

## Next
[Promote a change from dev to prod](04-environments-promotion.md)
