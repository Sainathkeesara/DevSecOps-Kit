---
last_verified: 2026-10-10
tool_version: n/a
sources: []
---

# Syft format migration guide

## Purpose

Syft's SBOM output format vocabulary changed between 0.x and 1.x, and the short flag spellings shifted with it. This guide covers what to change when a pipeline that worked against an older Syft stops producing the format it expects, and how to land on a format that the downstream consumer actually accepts.

## When to use

- A CI pipeline that pinned a Syft output flag and a Syft upgrade silently changed what that flag emits.
- Migrating a script from the short `-o` spellings to the long names, or vice versa.
- Choosing between CycloneDX and SPDX when the downstream tool has started rejecting one of them.
- A scan that produces an empty or malformed SBOM and the format flag is the first thing to check.

## Prerequisites

- Syft installed and available on `PATH`.
- The existing pipeline script or command that is failing.
- The downstream consumer (vulnerability scanner, license tool, dependency graph) that the SBOM feeds.

## Steps

### 1. Check what the installed Syft accepts

Run the format help for the target:

```bash
syft <target> -o help
```

This lists every format the installed binary can emit. Do not assume the spellings from an older version carried over.

### 2. Map the old short flag to the current name

The long format names are stable across 1.x releases; the short spellings are what drift. Common mappings:

| Old short flag | Current long name | Notes |
|---|---|---|
| `-o syft-json` | `syft-json` | Native format, still available |
| `-o cyclonedx-json` | `cyclonedx-json` | JSON CycloneDX |
| `-o cyclonedx-xml` | `cyclonedx-xml` | XML CycloneDX |
| `-o spdx-json` | `spdx-json` | JSON SPDX |
| `-o spdx-tag-value` | `spdx-tag-value` | Line-oriented SPDX |
| `-o github-json` | `github-json` | GitHub dependency graph schema |
| `-o table` | `table` | Human-readable, no downstream parsing |

If a flag you are using is not in the help output, that is the migration signal.

### 3. Update the pipeline script

Replace the deprecated flag with the current long name. Prefer the long name in scripts — it is the form the format's documentation uses and it survives short-flag renames:

```bash
# Before (older Syft)
syft alpine:latest -o cdx-json > sbom.json

# After (1.x)
syft alpine:latest -o cyclonedx-json > sbom.json
```

### 4. Validate the output shape after the change

Confirm the emitted JSON actually carries the keys the consumer expects:

```bash
syft alpine:latest -o cyclonedx-json | jq '.bomFormat'
syft alpine:latest -o spdx-json | jq '.spdxVersion'
syft alpine:latest -o github-json | jq '.packageVersion'
```

An empty result means the format flag is wrong, not that the image is clean.

### 5. Pin the Syft version in CI

A migration is only stable if the pipeline cannot drift again. Pin Syft to the exact version the script was tested against, either via a versioned container image or a pinned install command.

## Verify

1. Run `syft <target> -o help` and confirm the target format is listed.
2. Run the updated command and confirm the output parses as the expected schema (`bomFormat`, `spdxVersion`, `packageVersion`).
3. Diff the new output against a previously good SBOM from the old format to confirm package coverage is unchanged.

## Common errors

- **Flag not recognised**: the short spelling was retired. Switch to the long name from the help output.
- **Empty SBOM**: the format flag was accepted but emits a schema the consumer ignores. Check the consumer's expected keys, not just whether the file is non-empty.
- **`bomFormat` missing in CycloneDX output**: the flag emitted a non-CycloneDX format under an old short name. Re-check the flag against `syft -o help`.
- **SPDX `spdxVersion` absent**: the flag emitted Syft JSON or table, not SPDX. The schema check catches this immediately.

## References

- Syft output format help: `syft <target> -o help`
- Syft integration reference: `syft/docs/syft-integration-reference.md`
- SBOM output formats reference: `syft/docs/sbom-output-formats-reference.md`
- Output format selection guide: `syft/docs/output-format-selection-guide.md`