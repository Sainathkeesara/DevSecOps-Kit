---
last_verified: 2026-11-12
tool_version: n/a
sources: []
---

# Block the public bucket with Checkov

You can promote infrastructure from dev to prod through a CI gate, but that gate only protects you if it also rejects misconfigured resources. This lesson adds a Checkov scan to the pipeline: you run Checkov against a Terraform file that contains a deliberately public S3 bucket, watch it fail, then add a custom policy and fix the bucket so the check passes and the PR can merge. It builds on the promotion workflow from the previous lesson, where a PR plans the change and a green run applies it.

## What you'll learn
- Run Checkov in CI and find the planted public bucket
- Write a custom policy and fix the resource so the PR passes

## Before you start
- [Plan, apply and destroy with remote state](03-terraform-plan-apply-destroy.md) — you can initialize, plan, apply, and destroy Terraform, and you know state lives in a `terraform.tfstate` file
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — you know how a pull-request workflow gates a merge on a green run
- `checkov` must be installed. Confirm it with `checkov --version`. If it is missing, install it with `pip install checkov`.

## Walkthrough

Work from `learn/04-iac/`, so the relative paths below resolve correctly.

1. Create a small Terraform file with a publicly readable S3 bucket — the "planted" public bucket this lesson is built around. Save it as `bucket.tf`:

   ```hcl
   resource "aws_s3_bucket" "public_bucket" {
     bucket = "my-public-bucket"
     acl    = "public-read"
   }
   ```

   Run Checkov against it:

   ```bash
   checkov --framework terraform -f bucket.tf
   ```

   You should see: a failed check (`CKV_AWS_20`) flagging the bucket's public ACL, and Checkov exits with a non-zero status — that's what blocks a CI pipeline.

2. Add a custom policy. Checkov ships with built-in checks such as `CKV_AWS_20`, but you can also supply your own. The kit already carries a custom policy that fails any S3 bucket whose ACL is not `private`: see [no-public-s3-buckets policy](../../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml) (check ID `CKV_CUSTOM_1`). Run Checkov with that policy directory:

   ```bash
   checkov --framework terraform -f bucket.tf --external-checks-dir ../../checkov/policies/no-public-s3-buckets
   ```

   You should see: `CKV_CUSTOM_1` fires on the public bucket in addition to the built-in `CKV_AWS_20`.

   The same idea runs in CI: the [Checkov SARIF PR gate](../../checkov/manifests/checkov-sarif-pr-blocking.yaml) scans IaC directories on every pull request and fails the run when Checkov finds issues — that's how a public bucket never reaches production.

3. Fix the resource so the check passes. Change the bucket's ACL from `public-read` to `private`:

   ```hcl
   resource "aws_s3_bucket" "public_bucket" {
     bucket = "my-public-bucket"
     acl    = "private"
   }
   ```

   Re-run Checkov with the custom policy:

   ```bash
   checkov --framework terraform -f bucket.tf --external-checks-dir ../../checkov/policies/no-public-s3-buckets
   ```

   You should see: no failed checks, and Checkov exits `0` — the PR gate would go green.

## Exercise
Working alone, in a copy of your `bucket.tf`:

1. Add a second misconfigured resource — for example, another `aws_s3_bucket` with `acl = "public-read"`, or an `aws_security_group` open to `0.0.0.0/0`.
2. Run Checkov against the file with the custom policy and confirm it flags the new resource.
3. Fix the resource so Checkov reports no failed checks and exits `0`.

Do not paste the solution into the lesson file.

## Check your work
```bash
checkov --framework terraform -f bucket.tf --external-checks-dir ../../checkov/policies/no-public-s3-buckets --quiet
```
`checkov` prints no failed-check lines and exits with status `0`. Confirm with `echo $?` — it prints `0`.

## Common mistakes
- Forgetting `--external-checks-dir`, so the custom policy `CKV_CUSTOM_1` never runs and only the built-in check fires.
- Leaving `acl = "public-read"` on the bucket after "fixing" it — Checkov keeps failing until the ACL is `private`.

## Next
[Scan IaC with Trivy config](../../00_index/learning-path.md)
