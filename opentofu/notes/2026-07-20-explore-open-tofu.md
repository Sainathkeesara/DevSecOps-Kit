---
last_verified: 2026-07-20
tool_version: n/a
sources: []
---

# Explore OpenTofu — state, providers, modules, and CLI

I ran `tofu init`, `tofu plan`, and `tofu apply` against the first config I wrote. Here's what stood out compared to reading the docs.

## What worked

- `tofu init` pulled the AWS provider without me touching a `plugins` directory. The lock file it wrote (`.terraform.lock.hcl`) is new to me — I'm used to `package-lock.json` style locks, but this one pins provider versions too.
- `tofu plan` showed a clean `+` for the new bucket. The diff is readable enough that I can forward it to a teammate and they'll know what's about to change.
- `tofu apply` asked for explicit `yes` before touching anything. I kept waiting for a `--auto-approve` flag like `npm install --yes`, but the docs say typing `yes` is the default gate.

## Got stuck on

- **State file location.** I assumed `tofu.tfstate` would appear next to my `.tf` file. It does, but when I ran `tofu destroy` from a sibling directory it complained "no state" because state is tied to the working directory, not the config file. I had to `cd` back into the project folder.
- **Provider version constraints.** I wrote `version = "5"` and it errored. The docs say `~> 5.0` is the safe constraint for "any 5.x" — exact major without patch pins is not valid syntax.

## What I'd try next

Remote state in S3 so I can share the bucket list with teammates, and a module for the bucket + IAM role so I'm not copy-pasting the same block across environments.
