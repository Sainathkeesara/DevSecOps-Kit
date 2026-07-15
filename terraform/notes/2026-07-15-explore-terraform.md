---
last_verified: 2026-07-15
tool_version: n/a
---

# Exploring Terraform — state, providers, variables, and modules

> First-person notes poking at Terraform's core ideas for the first time. Just trying to build a mental model.

I read the primer and then actually ran things to see how the pieces fit. Here's what clicked and what's still fuzzy.

## State

I ran `terraform apply` on a tiny config and a `terraform.tfstate` file appeared. Opening it, it's just JSON describing the bucket Terraform made — the ID, the ARN, the region. My takeaway: state is Terraform's memory. Without it, Terraform can't tell "this bucket already exists, leave it alone" from "I need to create it." I'm a little worried about where that file lives; for now it's local, which feels fragile.

## Providers

The `provider` block is what connects my config to a real platform. I only tried one (AWS), but the docs show the same shape for Azure, GCP, and dozens more. The `required_providers` block pins *where* the provider comes from (`hashicorp/aws`), which I think is how Terraform knows which plugin to download during `init`. That `init` step did a bunch of downloading the first time — now I get why it's step one.

## Variables

I started hardcoding the bucket name, then moved it into a `variable` block. Big difference: now the value lives in one place and I can pass it in with `-var` or a `.tfvars` file. The `type = string` bit feels like a guardrail — if I pass a number, it should complain. `output` is the opposite direction: it prints a value (the bucket ID) after apply so other tooling could consume it.

## Modules

I haven't built one yet, but the idea landed: a module is a folder of `.tf` files you can call from elsewhere with `module "..." {}`. It's basically a function for infrastructure — write the VPC logic once, reuse it ten times. This is the part I most want to try next, because copy-pasting buckets across projects is exactly the pain Terraform should remove.

## What tripped me up

- Forgetting `terraform init` and getting "provider not found" errors. It has to run after writing (or changing) providers.
- Editing a resource by hand in the cloud console — Terraform didn't know, so the next `plan` wanted to "fix" my change back. State is the source of truth, not the console.
- The state file sitting next to my config felt wrong; I'll learn about remote state later.

## What I'd try next

Write a small module (a reusable bucket), use a `.tfvars` file for variables, and read what `terraform plan` actually proposes before every `apply`.
