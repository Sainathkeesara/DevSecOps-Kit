---
last_verified: 2026-09-21
tool_version: n/a
sources: []
---

# Follow the official OpenTofu quickstart — what tripped me up

I followed the official OpenTofu quickstart to get a feel for the workflow.
This is what worked and where I got stuck.

## What I followed

I started with a minimal configuration: a single `null_resource` that does
nothing but let me run `tofu plan` and `tofu apply` end to end. I kept it
in one file so I could focus on the command flow rather than module
structure.

## What worked

- `tofu init` pulled the null provider without any extra flags — I did not
  need a provider block for the first run.
- `tofu plan` showed exactly what would change before I committed anything,
  which gave me confidence to proceed.
- `tofu apply -auto-approve` let me skip the interactive prompt while I was
  iterating quickly.

## Got stuck on

- **Provider pinning** — My first config left the provider version unconstrained.
  `tofu plan` then pulled a newer version than I expected and changed some
  output formatting. Pinning the provider version in the `required_providers`
  block fixed the drift.
- **Output visibility** — I defined outputs but forgot that `tofu output`
  shows them only after apply. Running `tofu output` before apply gave me
  blank results, which I mistook for a configuration error.
- **State location** — I did not realize the default state file
  (`terraform.tfstate`) lives in the working directory. I accidentally
  committed it to a shared repo before learning about remote backends.

## What I'd try next

Split the configuration into separate files for variables and outputs, then
experiment with a remote backend so the state is not sitting in the working
directory.
