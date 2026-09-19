---
last_verified: 2026-09-19
tool_version: n/a
sources:
  - /work/DevSecOps-Kit/environments/dev/main.tf
---

# Environments — quick primer

> First-day notes for someone who's never used `environments/`. Personal voice, plain language.

## What is it?

I found that `environments/` is where I keep config that separates infrastructure setups by environment — dev, staging, and prod. It's not a tool you install; it's a folder full of Terraform config files that define different settings for each place I deploy to.

## What does it do?

It lets me define per-environment variables and backends so I can run the same module against dev, staging, and prod without changing a bunch of values each time. Each environment gets its own subdirectory — `dev/`, `staging/`, `prod/`.

## Why does it exist?

Before I had this structure, I was copying config files between environments and occasionally deploying to the wrong one. This directory gives each environment its own isolated folder, so mistakes are harder to make.

## Key terminology

- **Environment** — a named deployment context like dev, staging, or prod.
- **Variable set** — values defining environment-specific parameters like region or instance size.
- **Backend configuration** — remote state storage settings that differ per environment.
- **Subdirectory pattern** — each environment lives in its own folder under `environments/`.

## A tiny example

```hcl
# environments/dev/main.tf
terraform {
  backend "s3" {
    bucket = "my-app-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

The dev backend config points to `dev/terraform.tfstate`. Staging and prod use their own keys.

## What I'll cover next

I plan to dig into variable differences between environments and figure out how to automate switching between them.
