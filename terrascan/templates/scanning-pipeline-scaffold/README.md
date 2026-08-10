---
last_verified: 2026-08-09
tool_version: n/a
sources: []
---
# Terrascan scanning pipeline scaffold — usage notes

> First-contact notes for someone copying this scaffold into a project.

## What is in this scaffold

- `config.yaml` — Terrascan scan configuration pointing at the local
  IaC directory and loading custom policies from `policies/`.
- `policies/` — two example custom Rego policies that extend the
  built-in rule set.
- `scripts/run-scan.sh` — thin wrapper that runs Terrascan with the
  config, emits JSON, and prints a per-severity breakdown.
- `.gitignore` — ignores the `terrascan-results/` output directory.

## How to use it

Copy the entire `scanning-pipeline-scaffold/` directory into the root
of your Terraform (or other IaC) project. Then run:

```bash
chmod +x scripts/run-scan.sh
./scripts/run-scan.sh .
```

Edit or replace the policies in `policies/` to match your organization's
guardrails. The two included policies are starting points, not a complete
baseline.

## Customising the pipeline

The scaffold assumes Terrascan is already installed locally. To add this
to CI, extend the script with your CI system's artifact-upload step so
the JSON result is preserved between runs. The script exits 0 even when
violations are found; it is a reporting scaffold, not a gate. Add a
severity-threshold gate on top if you want the pipeline to fail.
