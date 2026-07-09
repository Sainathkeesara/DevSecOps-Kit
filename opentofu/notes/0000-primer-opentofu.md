---
last_verified: 2026-07-09
tool_version: n/a
---

# OpenTofu — quick primer

> First-day notes for someone who's never used OpenTofu. Personal voice, plain language.

## What is it?

OpenTofu is an open-source infrastructure-as-code tool forked from Terraform after HashiCorp switched licenses in 2023. If you know Terraform, you already know OpenTofu — same HCL syntax, same workflow. The difference is OpenTofu is fully open (MPL 2.0) under the Linux Foundation.

## What does it do?

You write `.tf` files declaring cloud resources — VMs, databases, DNS records. OpenTofu figures out the creation order, provisions through provider plugins, and stores state so it tracks what it manages. `tofu plan` previews changes, `tofu apply` executes them.

## Why does it exist?

Managing cloud resources through a web console doesn't scale. OpenTofu treats infrastructure as code — version-controlled, reviewable, repeatable. The fork kept the tool truly open when the original went source-available.

## Key terminology

- **Provider** — plugin talking to a cloud API. Example: `hashicorp/aws`.
- **Resource** — a managed cloud object. Example: `aws_instance.web_server`.
- **State** — JSON file mapping config to real resources. Example: `terraform.tfstate`.
- **Module** — reusable resource group. Example: a `vpc` module.
- **Plan** — diff showing what changes. Example: `tofu plan`.

## A tiny example

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data" {
  bucket = "my-tofu-bucket-001"
}
```

Run `tofu init` then `tofu apply`. The bucket appears in AWS and the state file records it.

## What I'll cover next

I want to learn modules for multi-environment setups and remote state backends for team collaboration.
