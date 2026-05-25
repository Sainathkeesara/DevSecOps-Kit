# Checkov — quick primer

> First-day notes for someone who's never used Checkov. Personal voice, plain language.

## What is it?

I'd heard Checkov mentioned as "that IaC scanner" a few times at meetups. Turns out it's a static analysis tool for Infrastructure as Code — Terraform, CloudFormation, Kubernetes manifests, ARM templates. It checks your infrastructure definitions against hundreds of built-in security policies. If you've used `semgrep` for code scanning, Checkov is the same idea but aimed at infra files instead of application code.

The key difference I noticed: Semgrep matches code patterns with YAML rules you write yourself, while Checkov ships with a big library of pre-written policies focused on cloud provider misconfigurations. You can write custom policies for Checkov too (it uses a Python API called `graph_checks`), but the main draw is the built-in coverage — hundreds of checks for AWS, Azure, and GCP out of the box.

## What does it do?

I point Checkov at a directory of Terraform files (or a K8s manifest), and it runs all those built-in policies against them. It flags resources that are misconfigured — like an S3 bucket with public ACLs, a security group open to 0.0.0.0/0 on SSH, or a pod running as root. It tells me which policy fired, its severity, and a fix suggestion.

It can also output results in JSON or SARIF format, which I could feed into a CI/CD pipeline tool or a dashboard like DefectDojo. There's even a `--quiet` flag that only prints failed checks — nice for keeping CI logs clean.

## Why does it exist?

Before Checkov, catching infrastructure misconfigurations meant manual code review — or finding out after deploy when a bucket leaked data. Checkov shifts IaC security left: I can catch problems while writing the Terraform, not after it's live. Platform engineers use it as part of their CI pipeline to stop bad config before it reaches a live environment.

## Key terminology

- **Policy** — a single check for a specific misconfiguration. Example: `CKV_AWS_20` checks an S3 bucket isn't publicly readable.
- **Resource** — an infrastructure component like `aws_s3_bucket` or `Pod`. Checkov maps each finding to the resource that triggered it.
- **Severity** — `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`. Helps me decide what to fix first.
- **Skip** — a way to suppress a known false-positive using a comment like `checkov:skip=CKV_AWS_20:reason`.
- **--compact** — CLI flag to group results by resource instead of by policy. Helpful when one resource fails dozens of checks.
- **--quiet** — only prints failed checks in the output. I'd use this in CI to keep logs readable.
- **--framework** — tells Checkov which IaC framework to scan: `terraform`, `kubernetes`, `cloudformation`, `arm`, `all`.

## A tiny example

```bash
pip install checkov
echo 'resource "aws_s3_bucket" "example" {
  bucket = "my-public-bucket"
  acl    = "public-read"
}' > bucket.tf
checkov --framework terraform --file bucket.tf
```

This writes a tiny Terraform file with a publicly readable S3 bucket and runs Checkov against it. The output flags `CKV_AWS_20` and explains the risk.

## What I'll cover next

Now that I've seen what Checkov is and how the CLI works, I'll install it for real and scan a Terraform plan. After that I want to try running it against a Kubernetes manifest and see how the findings differ.
