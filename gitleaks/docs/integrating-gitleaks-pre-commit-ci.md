---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# Integrating gitleaks into pre-commit and CI

## Purpose

Run gitleaks locally before every commit and in CI so leaked secrets never land on the default branch.

## When to use

- New repo bootstrap.
- Adding secret scanning to an existing pipeline.
- Standardising scans across a monorepo.

## Prerequisites

- gitleaks installed (`gitleaks version`).
- A `.gitleaks.toml` ruleset (see `scripts/build-custom-gitleaks-ruleset.sh`).

## Steps

1. Install pre-commit: `pip install pre-commit`.
2. Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: <pin-to-reviewed-version>
    hooks:
      - id: gitleaks
```

3. Run `pre-commit install`.
4. In CI, add a job:

```yaml
- name: gitleaks
  run: gitleaks detect --source . --config .gitleaks.toml --no-git
```

## Verify

```bash
pre-commit run gitleaks --all-files
gitleaks detect --source . --config .gitleaks.toml --no-git
```

## Common errors

- **Config not found**: ensure `.gitleaks.toml` is committed and path matches.
- **False positives**: extend `[allowlist]` with paths/regexes.

## References

- gitleaks docs.
EOF