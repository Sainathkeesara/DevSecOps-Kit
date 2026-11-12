---
last_verified: 2026-11-12
tool_version: 3.4.4
sources:
  - https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html
  - https://www.checkov.io/4.Integrations/GitHub%20Actions.html
  - https://www.checkov.io/2.Basics/Hard%20and%20soft%20fail.html
  - https://www.checkov.io/3.Custom%20Policies/YAML%20Custom%20Policies.html
  - https://github.com/bridgecrewio/checkov/releases/tag/3.4.4
---

# Block the public bucket with Checkov

You can promote infrastructure from dev to prod through a CI gate, but nothing in that gate stops a misconfigured resource from shipping. This lesson adds a Checkov scan to the pipeline: you'll plant a public S3 bucket in Terraform, catch it with Checkov, then write a custom policy and fix the resource so the pull request passes. It builds on the promotion workflow from the previous lesson, where a PR plans prod and a merge applies it.

## What you'll learn
- Run Checkov in CI and find the planted public bucket
- Write a custom policy and fix the resource so the PR passes

## Before you start
- [Plan, apply and destroy with remote state](03-terraform-plan-apply-destroy.md) — you can initialize, plan, apply, and destroy, and you know state lives in a `terraform.tfstate` file
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — you know how a pull-request workflow gates a merge on a green run
- `checkov` must be installed. Confirm it with `checkov --version` (install with `pip install checkov`).

## Walkthrough

1. Create a small Terraform project with a planted public S3 bucket. Save it as `main.tf` ([companion file](../../checkov/configs/public-bucket/main.tf)):

   ```hcl
   resource "aws_s3_bucket" "web_assets" {
     bucket = "my-company-web-assets"
     acl    = "public-read"
   }
   ```

   `public-read` exposes the bucket to anyone on the internet — exactly the kind of misconfiguration Checkov is built to catch.

2. Install Checkov and confirm the version:

   ```bash
   pip install checkov
   checkov --version
   ```

   You should see: `3.4.4`.

3. Scan the project with Checkov:

   ```bash
   checkov --directory checkov/configs/public-bucket --framework terraform
   ```

   You should see: a `FAILED` finding for `CKV_AWS_20` on `aws_s3_bucket.web_assets`, flagging the public-read ACL. That's the planted public bucket.

4. Add Checkov to CI so the bucket is caught on every pull request. Create `.github/workflows/checkov-pr.yml`:

   ```yaml
   name: Checkov IaC scan

   on:
     pull_request:
       branches: [master]

   jobs:
     checkov:
       name: Checkov infrastructure scan
       runs-on: ubuntu-latest
       steps:
         - name: Checkout the repository
           uses: actions/checkout@v4
         - name: Set up Python
           uses: actions/setup-python@v5
           with:
             python-version: "3.12"
         - name: Install Checkov
           run: pip install checkov
         - name: Run Checkov
           uses: bridgecrewio/checkov-action@master
           with:
             directory: checkov/configs/public-bucket
             framework: terraform
   ```

   On a pull request, the `checkov` job runs and reports the `CKV_AWS_20` failure; a reviewer sees the finding before the merge. The kit already carries a SARIF-based PR gate at [`checkov/manifests/checkov-sarif-pr-blocking.yaml`](../../checkov/manifests/checkov-sarif-pr-blocking.yaml) if you prefer uploading results to GitHub Code Scanning.

5. Write a custom policy that flags public-read buckets, following Checkov's `CKV2_<provider>_<number>` ID form ([companion file](../../checkov/policies/ckv2-no-public-bucket/no_public_bucket.yaml)):

   ```yaml
   metadata:
     id: CKV2_AWS_1
     name: "Ensure S3 buckets do not allow public read ACLs"
     category: general
     guideline: "A public-read ACL exposes bucket contents to anyone on the internet."
     severity: HIGH
   scope:
     provider: aws
   definition:
     cond_type: attribute
     resource_types:
       - aws_s3_bucket
     attribute: acl
     operator: equals
     value: "public-read"
   ```

   Run Checkov with the custom policy directory:

   ```bash
   checkov --directory checkov/configs/public-bucket --framework terraform --external-checks-dir checkov/policies/ckv2-no-public-bucket
   ```

   You should see: the built-in `CKV_AWS_20` failure plus your custom `CKV2_AWS_1` failure on the same bucket.

6. Fix the resource so the PR passes. Change `acl = "public-read"` to `acl = "private"` in `main.tf`, then re-run the scan:

   ```bash
   checkov --directory checkov/configs/public-bucket --framework terraform --external-checks-dir checkov/policies/ckv2-no-public-bucket
   ```

   You should see: no `FAILED` findings and exit code `0`. If some findings are accepted, use `--soft-fail-on <check-id>` so they don't fail CI — an un-soft-failed non-zero exit is a common reason a Checkov scan breaks the build.

## Exercise
Working alone, in a fresh directory:

1. Copy the public-bucket project and add an `aws_security_group_rule` open to `0.0.0.0/0` on port 22.
2. Run Checkov and record the built-in finding.
3. Write a custom `CKV2_` policy that flags world-open SSH security groups, load it with `--external-checks-dir`, and confirm it fires.
4. Fix both resources so `checkov` exits `0` with no `FAILED` findings.
5. Add a Checkov step to a pull-request workflow so the scan gates the merge.

Do not paste the solution into the lesson file.

## Check your work
```bash
checkov --directory <your-project> --framework terraform
checkov --directory <your-project> --framework terraform --external-checks-dir <your-policies-dir>
```
Both exit `0` with no `FAILED` findings, and the custom policy appears in the output.

## Common mistakes
- Custom policy ID not using the `CKV2_<provider>_<number>` prefix — Checkov will not load the check.
- Running Checkov in CI without `--soft-fail-on` for accepted findings — one tolerated failure fails the pipeline.
- Forgetting `--framework terraform` — Checkov may skip the Terraform checks entirely.

## Next
[Scan IaC with Trivy config](../../00_index/learning-path.md)
