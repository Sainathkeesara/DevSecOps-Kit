---
last_verified: 2026-09-04
tool_version: n/a
sources: []
---

# Explore the TruffleHog CLI — what's there

I just installed TruffleHog and wanted to understand what the CLI actually offers before running a real scan. I started with `trufflehog --help`.

The top-level help shows several subcommands: `git`, `filesystem`, `github`, `gitlab`, `http`, and `s3`. Each targets a different source type. `git` scans a repo's full commit history, `filesystem` scans a local directory without git, `github` and `gitlab` hit those APIs, `http` scans web responses, and `s3` scans object storage buckets.

I dug into `trufflehog filesystem --help` to see the local scan options. Key flags: `--path` for the directory (defaults to current), `--only-verified` to skip unverified candidates, `--no-verification` to skip live checks entirely, `--json` for machine-readable output, and `--only-detector` to limit detector types.

The `config` subcommand is interesting too — `trufflehog config generate` creates a `.trufflehog/config.yaml` you can customize with your own regex patterns and detector settings. And `trufflehog config lint` validates your config before running.

What surprised me: there's no generic `scan` command. The subcommand name IS the source type — you choose `git` or `filesystem` or `github`. Coming from tools with a generic scan verb, that felt odd at first.

Next I want to try `trufflehog git` on a throwaway repo with a planted fake key to see what the output looks like in practice.
