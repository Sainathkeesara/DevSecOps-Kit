# 2026-05-27: Following the official Checkov quickstart — what tripped me up

I went through the Checkov quickstart at https://www.checkov.io/ to see how far I'd get before something broke.

## Steps I followed

1. `pip install checkov` — worked fine, same as last time
2. `checkov --directory .` on a fresh terraform dir — found nothing because there was no .tf file yet
3. Created a simple `main.tf` with an open S3 bucket (no block_public_policy):
   ```hcl
   resource "aws_s3_bucket_public_access_block" "example" {
     bucket = aws_s3_bucket.example.id
   }
   ```
   Wait — that's actually a *good* resource. I had to make one that was *bad* on purpose:
   ```hcl
   resource "aws_s3_bucket" "example" {
     bucket = "my-example-bucket"
     acl    = "public-read"
   }
   ```
4. `checkov --directory .` — this time it found CKV2_AWS_6 (S3 bucket should have public access block)

## Got stuck on

- The quickstart's example command `checkov --directory .` expects files to already exist. I wasted five minutes wondering why zero results came back from an empty dir. Would be nice if Checkov warned "no IaC files found" instead of silently returning zero checks.
- The docs at quickstart page assume you already have Terraform configs. There's no "here's a sample bad config to copy-paste" section. I ended up writing my own intentionally insecure S3 bucket to see a failure.
- `--compact` flag is mentioned in one example but not explained. Tried it — just makes per-resource output less chatty. Should be in the quickstart flags table.

## What I'd try next

- Feed it a big real-world Terraform module and see how long the scan takes
- Try the `--skip-check` flag to exclude noisy rules like CKV_AWS_21 (S3 bucket versioning)
- Run against K8s manifests — the quickstart is very Terraform-heavy
