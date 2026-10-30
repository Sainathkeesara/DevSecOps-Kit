---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Terraform Module Registry — Publish and Consume Pattern

## Purpose

Reusable template showing how to consume a published module from the Terraform Registry and structure a module for publishing.

## Consume

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  ...
}
```

Pin the `version` argument to avoid unexpected upgrades.

## Publish

1. Place module source in a GitHub repo named `terraform-<provider>-<name>`.
2. Tag releases with semantic versions (`v1.0.0`).
3. Register the repo in the Terraform Registry; the registry imports tags automatically.
4. Add a `README.md`, `LICENSE`, and `examples/` directory for discoverability.

## Layout

- `main.tf` — resource definitions and module calls
- `variables.tf` — inputs
- `outputs.tf` — outputs for consumers
- `versions.tf` — provider/version constraints
