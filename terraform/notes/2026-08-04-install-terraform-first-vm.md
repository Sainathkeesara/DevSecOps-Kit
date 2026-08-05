---
last_verified: 2026-08-04
tool_version: n/a
---

# Terraform — Install Terraform, run `terraform init`, and deploy my first VM — what tripped me up

> First-day notes on getting Terraform running and deploying a VM. What I learned, and where I got stuck.

## What is it?

Terraform is a tool for defining infrastructure as code. You write declarative config files that describe what you want, and Terraform figures out how to make that happen. I compare it to writing a recipe — you describe the desired dish, not the step-by-step cooking process.

## What does it do?

I installed Terraform, ran `terraform init` to pull in the provider plugins, wrote a small config with a virtual machine resource, ran `terraform plan` to see what changes it would make, and then ran `terraform apply` to create the VM. The plan output showed me exactly what Terraform would do before it did it.

## Why does it exist?

Before Terraform, provisioning infrastructure meant clicking through cloud consoles or writing fragile shell scripts. Terraform lets you version-control your infrastructure the same way you version-control code, and it tracks state so it knows what already exists.

## Key terminology

- **Provider** — A plugin Terraform uses to interact with a platform. Example: `provider "aws" { region = "us-east-1" }`.
- **Resource** — A building block in Terraform config. Example: `resource "aws_instance" "web" { ami = "ami-12345" }`.
- **State** — Terraform's record of what it has created. Example: `.terraform/terraform.tfstate`.
- **Plan** — A dry-run showing what Terraform will do. Example: `terraform plan`.
- **Init** — Downloads provider plugins and sets up the working directory. Example: `terraform init`.

## A tiny example

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "hello" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

This defines a single EC2 instance. Run `terraform init` then `terraform plan` to see what it would create.

## What I'll cover next

I plan to try multi-region deployments next, then look at remote state management.