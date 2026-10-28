---
last_verified: 2026-10-28
tool_version: n/a
sources:
  - https://opentofu.io/docs/
  - https://developer.hashicorp.com/terraform/docs/cloud
---
# OpenTofu vs Terraform: migration decision matrix

> First-day notes on evaluating OpenTofu as a Terraform replacement. Personal voice, plain language.

## What is it?

I've been using Terraform for infrastructure provisioning for several years, and recently started hearing about OpenTofu as a community-driven fork. The motivation is straightforward: Terraform's commercial restrictions around Terraform Cloud features have pushed many teams to look for alternatives that offer the same workflow without the vendor lock-in. OpenTofu takes the last open-source version of Terraform and continues development under the Linux Foundation, adding community-driven features and improvements.

What makes this evaluation interesting is that OpenTofu aims to be a drop-in replacement — most Terraform configurations work out of the box, but there are edge cases around provider compatibility and Cloud API interactions that can trip you up.

## Why does it exist?

The existence of OpenTofu is a direct response to HashiCorp's shift to the Business Source License (BSL) for Terraform 1.5+. Previously, Terraform's open-source model meant anyone could fork and continue the project. After the BSL shift, the community felt compelled to create a truly open alternative. OpenTofu was born from this need, with contributions from former Terraform maintainers, cloud providers, and the broader infrastructure community.

Who uses it day-to-day? Teams that require guaranteed open-source access to their IaC tooling, regulated environments that prohibit BSL-licensed software, and organizations looking to avoid Terraform Cloud pricing tiers for features like private workers and Sentinel policy as code.

## Key terminology

- **OpenTofu** — A community-driven fork of Terraform that maintains open-source compatibility with the last fully OSS version of Terraform, governed by the Linux Foundation.
- **Terraform Cloud** — HashiCorp's hosted SaaS platform for managing Terraform workspaces, state, and runs; certain features are behind paywalls or the BSL.
- **Provider compatibility** — The degree to which a cloud provider's API can be provisioned using a given IaC tool's configuration language without modification.
- **State migration** — The process of moving Terraform state from one version/tool to another, often requiring `terraform state migrate` or manual conversion.
- **Sentinel** — HashiCorp's policy-as-code engine for Terraform Cloud; not available in OpenTofu, which uses OPA/Gatekeeper instead.

## A tiny example

The smallest demonstration of OpenTofu workflow:

```hcl
variable "instance_type" {
  type = string
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
```

This configuration runs identically in both Terraform and OpenTofu, illustrating the goal of drop-in compatibility. The key difference appears when you try to use Cloud API features that require Sentinel or Terraform Cloud-specific variables.

## What I'll cover next

I plan to test a simple EC2 provisioning workflow in OpenTofu and document any provider version mismatches or state migration steps needed. The goal is to determine whether our existing Terraform configurations can transition without rewriting.