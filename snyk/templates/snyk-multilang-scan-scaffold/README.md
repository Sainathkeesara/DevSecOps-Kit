---
last_verified: 2026-09-02
tool_version: n/a
sources:
---

# Snyk Multi-Language Project Scanning Scaffold

A reusable project scaffold for running Snyk scans across a polyglot codebase
(Node.js, Python, Java, Go, Ruby) with a single shared `.snyk` policy file and
per-language scan scripts wired into one CI entry point.

## Purpose

Most real repositories don't ship in a single language. They have a Node.js
frontend, a Python API, maybe a Java service and a Go worker. Running
`snyk test` once covers only the manifest nearest to the working directory, so
a single-project scan silently misses vulnerabilities in the rest of the tree.

This scaffold gives every contributor the same scanning surface — one config,
one policy file, one Makefile — so a vulnerability in any subsystem shows up
in the same PR check.

## When to use

- Your repo contains manifests for two or more ecosystems
  (`package.json`, `requirements.txt`, `pom.xml`, `go.mod`, `Gemfile`).
- You want one shared `.snyk` policy file that applies to all of them.
- You need the same severity/exit-code thresholds in CI across services.

## Structure

```
├── README.md                  # This file
├── Makefile                   # Common scan targets
├── .snyk                      # Shared policy (severity thresholds, ignores)
├── policies/
│   └── severity-policy.json   # Machine-readable severity rules
├── scripts/
│   ├── scan-all.sh            # Multi-language scan entry point
│   ├── scan-node.sh           # Node.js subscan
│   ├── scan-python.sh         # Python subscan
│   ├── scan-java.sh           # Java subscan
│   ├── scan-go.sh             # Go subscan
│   └── scan-ruby.sh           # Ruby subscan
└── .github/workflows/
    └── snyk-multilang-ci.yml  # CI workflow that runs scan-all.sh
```

## Prerequisites

- Snyk CLI installed and authenticated (`snyk auth`).
- The matching language toolchains present on the runner (Node, Python, Java,
  Go, Ruby) — only the ones your repo actually uses are required.

## Quick start

1. Copy this scaffold into the repo root.
2. Edit `.snyk` to reflect your severity threshold and acknowledged issues.
3. Run `make scan` locally to scan every detected language subdir.
4. Push to GitHub — the CI workflow runs `scan-all.sh` on every PR.

## Configuration

### `.snyk` policy file

The shared policy is the source of truth. It defines:

| Field | Description |
|-------|-------------|
| `severity-threshold` | Minimum severity that fails the build (`low`, `medium`, `high`, `critical`) |
| `ignore` | Per-vulnerability ignores, scoped by path or package |
| `patch` | Snyk-recommended patches (deprecated — prefer upgrades) |

Severity thresholds apply across all language scans invoked from the same
policy. Per-language overrides belong in `policies/severity-policy.json`.

### `policies/severity-policy.json`

A separate JSON file lets CI gate each language's exit code independently
(useful when a Java service has a known dependency on a deprecated library
but the rest of the stack should still block).

## Verify

After running `make scan`:

- Each subscan prints a summary line `<lang>: <vuln_count> issues,
  threshold=<severity>`. The exit code is non-zero if any subscan reports a
  vulnerability at or above its threshold.
- A combined JSON report is written to `snyk-results/snyk-multilang.json`.

## Rollback

The scaffold is additive — copy files in, remove them with `git rm`. No
runtime state lives outside the repo.