---
last_verified: 2026-11-12
tool_version: n/a
sources: []
---

# Scan IaC with Trivy config

You can gate infrastructure on vulnerabilities, but infrastructure can also ship misconfigured — a public bucket, an unencrypted volume, an open security group. This lesson adds a Trivy configuration scan to the IaC workflow: you scan a small Terraform file with `trivy config`, watch it flag a deliberately misconfigured resource, then fix it so the scan passes. It builds on the Checkov lesson, where you caught the same class of issue (a public S3 bucket) with Checkov — here you'll see how Trivy's config scan covers the same ground and how the two compare. It also covers what happened to tfsec and where its checks now live.

## What you'll learn

- Scan a Terraform directory with `trivy config` and read the misconfiguration findings
- Compare Trivy's config scan with Checkov's Terraform scan
- Explain what happened to tfsec and where its checks went

## Before you start

- [Block the public bucket with Checkov](05-checkov-iac-scan.md) — you can run Checkov against a Terraform file, interpret a failed check such as `CKV_AWS_20`, and fix the resource so Checkov exits `0`
- [Gate the image on Trivy findings in CI](../03-shift-left/09-trivy-ci-gate.md) — you've run Trivy against an image and seen a non-zero exit code on findings
- `trivy` installed. Confirm it with `trivy --version`. If it is missing, install it per the Trivy installation docs.

## Walkthrough

Work from `learn/04-iac/`, so the relative paths below resolve correctly.

1. Create a small Terraform file with a deliberately misconfigured resource. Save it as `bucket.tf`:

   ```hcl
   resource "aws_s3_bucket" "public_bucket" {
     bucket = "my-public-bucket"
     acl    = "public-read"
   }
   ```

2. Run Trivy's configuration scan against the directory:

   ```bash
   trivy config .
   ```

   You should see: a misconfiguration finding on the bucket's public ACL, with a Trivy check ID, the affected resource, and a short description of why it fails. Trivy exits non-zero when findings are present, so this is what would block a CI pipeline.

   Trivy scans a directory, not a single file, and understands several IaC formats — Terraform, Kubernetes manifests, Dockerfiles, and more — so one command covers your whole `deploy/` or `infrastructure/` tree.

3. Fix the resource so the check passes. Change the bucket's ACL from `public-read` to `private`:

   ```hcl
   resource "aws_s3_bucket" "public_bucket" {
     bucket = "my-public-bucket"
     acl    = "private"
   }
   ```

   Re-run the scan:

   ```bash
   trivy config .
   ```

   You should see: no misconfiguration findings, and Trivy exits `0`.

4. Compare with Checkov. In the previous lesson you ran:

   ```bash
   checkov --framework terraform -f bucket.tf --external-checks-dir ../../checkov/policies/no-public-s3-buckets
   ```

   Both tools catch the public bucket, but they differ in shape: Checkov targets a single file with built-in check IDs like `CKV_AWS_20` plus custom policies you point at with `--external-checks-dir`; Trivy scans a directory, bundles misconfiguration rules out of the box (no separate policy directory needed), and can emit the same SARIF format Checkov uses for PR gating — see the kit's [Trivy CI gate config](../../trivy/configs/trivy-ci-gate.yml) and [minimal Trivy config](../../trivy/configs/2026-10-19-minimal-trivy-config.yaml) for reference configs. Use Checkov when you want custom Rego policies per check; use Trivy config when you want one scanner for images, filesystems, and IaC misconfigurations together.

5. What happened to tfsec. tfsec was a standalone Terraform security scanner. Aqua Security (the makers of Trivy) acquired tfsec, and its Terraform misconfiguration checks were folded into Trivy's config scanner. If you have an old `tfsec` pipeline, replace it with `trivy config` — Trivy scans the same IaC types (Terraform, Kubernetes, Dockerfile) and can fail the run on findings just like tfsec did. You don't need to install or maintain tfsec separately anymore.

## Exercise

Working alone, in a copy of your `bucket.tf`:

1. Add a second misconfigured resource — for example, another `aws_s3_bucket` with `acl = "public-read"`, or an `aws_security_group` open to `0.0.0.0/0`.
2. Run `trivy config .` against the directory and confirm it flags the new resource.
3. Fix the resource so `trivy config .` reports no misconfiguration findings and exits `0`.

Do not paste the solution into the lesson file.

## Check your work

```bash
trivy config .
```

`trivy config` prints no misconfiguration findings and exits with status `0`. Confirm with `echo $?` — it prints `0`.

For the comparison objective, you should be able to state one way Trivy's config scan differs from Checkov's (directory scan vs. single file, built-in rules vs. external policy dir, shared SARIF output).

## Common mistakes

- Running `trivy config` on a single `.tf` file instead of a directory — Trivy config scans directories; point it at the folder that holds your Terraform.
- Expecting Checkov-style `CKV_` IDs from Trivy — Trivy uses its own check IDs for misconfigurations; the finding class (public bucket) is the same, the ID format differs.
- Forgetting that `trivy config` exits non-zero on findings — that's intentional, it's the gate behavior you want in CI.

## Next

[Configuration Management — concepts](../../docs/concepts/configuration-management/0000-primer-configuration-management.md)