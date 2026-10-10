---
last_verified: 2026-10-10
tool_version: n/a
sources: []
---

# Terrascan scan configuration migration patterns

## Purpose

Terrascan's configuration surface has shifted between releases: top-level keys come and go, the policy source location changes, and the severity-gating behavior is not always what the flag name suggests. This guide covers how to move an existing Terrascan scan configuration from one release's shape to another without losing coverage, and how to land on a configuration the installed binary actually accepts.

## When to use

- A Terrascan upgrade silently ignored part of the old config and scans started reporting a different set of findings.
- The policy source moved from a remote repo to a local path (or the reverse).
- Severity gating needs to be made explicit because the default exit behavior is not reliable across releases.
- A scan configuration needs to be shared across environments that target different IaC types.

## Prerequisites

- Terrascan installed and available on `PATH`.
- The existing scan configuration that is being migrated.
- Access to the policy source the configuration points at, local or remote.

## Steps

### 1. Identify the recognized top-level keys

Terrascan reads its configuration from `terrascan.toml` / `terrascan.yaml`, via the `TERRASCAN_CONFIG` environment variable, or with `terrascan scan -c <path>`. There is no `--config-file` flag and no `.terrascan.yaml` default name.

The recognized top-level keys are `policy`, `notifications`, `rules`, `category`, `severity`, and `k8s-admission-control`. Any other key, such as a `scan:` section, is silently ignored. Confirm the keys the installed binary accepts by checking the config schema for the installed release before editing.

### 2. Move the policy source

The `policy` block controls where Terrascan looks for rules:

- `path` — a local repo path.
- `rego_subdir` — the local cache directory.
- `repo_url` / `branch` — a remote policy repo; leave blank to use the default.
- `environment` / `access_token` — authentication against the remote repo.

To migrate from a remote repo to a local path, set `path` to the local directory and blank out `repo_url`. To migrate the other way, populate `repo_url` and `branch` and remove `path`. Keep `rego_subdir` pointing at a writable cache directory in both cases.

### 3. Re-express severity gating explicitly

Terrascan's severity flag and exit-code behavior have varied across releases. The robust pattern is to parse the JSON output, count findings at or above the threshold severity, and fail the step explicitly rather than relying on the flag's exit behavior:

```bash
terrascan scan -d . -o json > terrascan.json
count=$(jq '[.results[] | select(.severity == "HIGH" or .severity == "MEDIUM")] | length')
if [ "$count" -ne 0 ]; then
  echo "Found $count findings at or above the threshold"
  exit 1
fi
```

Set the `severity.level` key in the config to the minimum level to report — one of `low`, `medium`, `high`.

### 4. Migrate include and exclude rules

The `rules` block controls which rule IDs run:

- `scan-rules` — overrides the policy path; only these rules run.
- `skip-rules` — removes rules globally.

When migrating, carry over every rule ID that was previously excluded by name. A silent drop of a `skip-rules` entry is the most common way a migration changes coverage without anyone noticing.

### 5. Carry the notifications and admission-control blocks unchanged

The `notifications` block holds named notifiers, each with a `type` and a `config` carrying its parameters. The `k8s-admission-control` block controls deny rules for the webhook. Both blocks are stable across recent releases; copy them as-is and only change values that the new environment requires.

## Verify

1. Confirm the installed binary accepts the config by running `terrascan scan -c <path> -d .` and checking it does not error on an unknown key.
2. Run a scan against a directory of known-misconfigured Terraform and confirm the expected rule IDs appear in the output.
3. Compare the finding count before and after the migration; a migration that changes the count without a deliberate rule change is a signal something was dropped.

## Common errors

- **A key in the config is silently ignored**: the top-level key is not in the recognized set. Remove it or move it into a recognized block.
- **Findings disappear after a policy-source migration**: `path` and `repo_url` were both set, or `repo_url` was left pointing at an unreachable repo. Check which source Terrascan actually loaded.
- **Severity gating does not fail the step**: the exit-code behavior changed in the installed release. Parse the JSON output and fail explicitly.
- **A `skip-rules` entry was dropped**: re-check every rule ID in the old config against the new one.

## References

- Terrascan config template: `terrascan/configs/terrascan-config-template.yaml`
- IaC pipeline integration: `terrascan/docs/iac-pipeline-integration.md`
- Terrascan vs Checkov comparison: `terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md`