---
last_verified: 2026-07-15
tool_version: n/a
---

# Terraform — quick primer

> First-day notes for someone who's never used Terraform. Personal voice, plain language.

## What is it?

Terraform is an Infrastructure as Code (IaC) tool made by HashiCorp. Instead of clicking around a cloud console to spin up servers, networks, and databases, you write text files describing what you want, and Terraform makes it real.

If you've used `git` for code, Terraform is the same idea for infrastructure: you describe the end state in a file, keep it in version control, and let the tool figure out how to get there. The difference is that `git` manages file history, while Terraform manages actual cloud resources (VMs, buckets, load balancers).

## What does it do?

It reads your configuration, compares it to what already exists, and applies the changes needed to match your description. You run three commands in a loop: `terraform init` (set up), `terraform plan` (preview changes), and `terraform apply` (make them). It tracks everything it created in a state file so it knows what to change next time.

## Why does it exist?

Before IaC, teams provisioned infrastructure by hand in web consoles or with one-off scripts. That's slow, error-prone, and impossible to review. Two people building "the same" environment would end up with subtle differences, and tearing things down was a manual chore nobody enjoyed. Terraform makes infrastructure repeatable, diffable, and disposable — you can stand up a whole environment from a file and destroy it just as easily.

## Key terminology

- **Provider** — the plugin that talks to a specific platform (AWS, Azure, GCP, etc.). Example: `provider "aws" {}` tells Terraform to use the AWS API.
- **Resource** — a single piece of infrastructure you want to manage. Example: `aws_instance` creates a virtual machine.
- **Configuration** — the `.tf` files where you describe your desired infrastructure in HCL.
- **State** — Terraform's record of what it actually created, used to plan future changes. Example: `terraform.tfstate`.
- **Plan** — a dry preview of what `apply` would do. Example: `terraform plan` shows "will add 3 resources".
- **Apply** — the step that actually creates, updates, or deletes resources. Example: `terraform apply`.
- **Module** — a reusable bundle of configuration, like a function for infrastructure. Example: a "vpc" module you drop into many projects.
- **Variable** — an input you pass in to avoid hardcoding values. Example: `variable "region" { default = "us-east-1" }`.

## A tiny example

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "my-first-terraform-bucket"
}
```

This is the smallest real configuration: it declares an AWS provider and asks for one S3 bucket. Running `terraform init` then `terraform apply` creates that bucket for you.

## What I'll cover next

I want to actually run `init`/`plan`/`apply` on a real provider, learn how `variables` and `outputs` work, and figure out what the state file is really doing behind the scenes. After that, modules and remote state feel like the natural next step.
