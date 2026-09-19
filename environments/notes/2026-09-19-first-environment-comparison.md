---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# My first environment comparison

> I opened dev, staging, and prod side by side to see what changed in my first setup.

## What I checked

I compared `environments/dev/terraform.tfvars`, `environments/staging/terraform.tfvars`, and `environments/prod/terraform.tfvars`. The shared Terraform files stayed mostly the same, while the variable files carried the environment-specific values.

## What changed

- Dev uses `10.0.0.0/16`, two availability zones, and one NAT gateway.
- Staging moves to `10.1.0.0/16`, three availability zones, and more than one NAT gateway.
- Prod uses `10.2.0.0/16`, three availability zones, and more than one NAT gateway.
- Tags change with the environment; prod also has an extra compliance tag.

## What surprised me

The `main.tf` files still pointed at the same state key, and each variables file defaulted the environment to `dev`. I need to verify those defaults before treating the folders as fully isolated.

## Next

I want to make each environment's state and variable defaults match its folder, then compare plans without applying anything.
