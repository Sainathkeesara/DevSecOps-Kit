---
last_verified: 2026-10-07
tool_version: n/a
---

# Exploring the Snyk CLI — what commands are there

I spent some time poking at the Snyk CLI to see what's in it beyond `snyk test`.

The two commands I keep coming back to are `snyk test` and `snyk monitor`. `test` scans and reports; `monitor` pushes a snapshot to the dashboard so I can track the same project over time. The primer mentions both, but I hadn't tried them side by side until now.

Things I tried:

- `snyk --version` — quick sanity check before a CI run.
- `snyk auth <token>` — logs the CLI in once; after that `SNYK_TOKEN` in the environment works too.
- `snyk test --json` — machine-readable output, pipes straight into `jq`.
- `snyk test --all-projects` — walks a monorepo instead of just the root manifest.
- `snyk test --severity-threshold=high --fail-on=upgradable` — the gating combo from the CI workflow.
- `snyk container test <image>` — same idea as `test` but for container images.
- `snyk monitor --project-name=my-api` — names the dashboard project instead of deriving it.

What surprised me: `snyk test` exits non-zero when findings are above the threshold, so the exit code itself is the gate — no need to parse output just to fail a build. And the `--json` output has a `.vulnerabilities[]` array with `id`, `title`, and `severity` fields, which is handy for custom reporting.

Still unsure about: the full `snyk iac` subcommand surface, and what other output formats exist besides JSON. Next step is to try `snyk iac test` on a Terraform directory.
