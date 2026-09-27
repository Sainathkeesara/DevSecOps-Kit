---
last_verified: 2026-09-27
tool_version: n/a
sources:
  - https://raw.githubusercontent.com/tenable/terrascan/master/pkg/config/types.go
  - https://raw.githubusercontent.com/tenable/terrascan/master/config/terrascan.toml
  - https://github.com/tenable/terrascan/blob/master/pkg/cli/scan.go
---
# Terrascan scanning pipeline scaffold — usage notes

> First-contact notes for someone copying this scaffold into a project.

## What is in this scaffold

- `config.yaml` — Terrascan scan configuration. The recognized top-level
  keys are `policy`, `rules`, `category`, `severity`, `notifications`, and
  `k8s-admission-control`. There is no `scan:` section — scan targeting
  (IaC type, directory, policy path) comes from CLI flags, not the config file.
- `policies/` — two example custom Rego policies that extend the built-in
  rule set.
- `scripts/run-scan.sh` — thin wrapper that runs Terrascan with the config,
  emits JSON, and prints a per-severity breakdown.
- `.gitignore` — ignores the `terrascan-results/` output directory.

## How to use it

Copy the entire `scanning-pipeline-scaffold/` directory into the root of your
Terraform (or other IaC) project. Then run:

```bash
chmod +x scripts/run-scan.sh
./scripts/run-scan.sh .
```

Edit or replace the policies in `policies/` to match your organization's
guardrails. The two included policies are starting points, not a complete
baseline.

## How the config file is found

Terrascan reads the config as `terrascan.toml` or `terrascan.yaml`, or via the
`TERRASCAN_CONFIG` env var, or the `-c/--config-path` flag. There is no
`--config-file` flag and no `.terrascan.yaml` default name, so pin the path in
your CI command rather than relying on discovery.

## Customising the pipeline

The scaffold assumes Terrascan is already installed locally. To add this to
CI, extend the script with your CI system's artifact-upload step so the JSON
result is preserved between runs. The script exits 0 even when violations are
found; it is a reporting scaffold, not a gate. Add a severity-threshold gate on
top if you want the pipeline to fail.

## Relevant scan flags

| Flag | Purpose |
| --- | --- |
| `-d/--iac-dir` | directory of IaC files to scan |
| `-p/--policy-path` | custom Rego policy directory |
| `-c/--config-path` | config file path |
| `-o/--output` | `human`, `json`, `yaml`, `xml`, `sarif`, `junit-xml`, `github-sarif` |
| `--severity` | minimum severity to report (`low`, `medium`, `high`) |
| `--categories` | list of violation categories to report |
| `--scan-rules` / `--skip-rules` | include or exclude specific rule IDs |
| `--show-passed` | display passed rules alongside violations |

Rule IDs follow the shape `<Resource>.<Category>.<Severity>.<Number>`, e.g.
`AWS.S3Bucket.DS.High.1043`.