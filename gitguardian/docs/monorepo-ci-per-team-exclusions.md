# How I wired GitGuardian into a monorepo CI and configured per-team exclusions

## Purpose

This doc covers how I set up GitGuardian's `ggshield` to scan a monorepo with multiple teams, each owning different service directories. The goal was to let each team manage their own exclusion rules without stepping on each other's configs, while keeping a single CI pipeline that catches real secrets across the whole repo.

## When to use this approach

This pattern works when:
- The repo has multiple language ecosystems (npm, pip, Go, etc.)
- Different teams own different subdirectories and need different allowlists
- You want a single CI scan that covers everything but respects per-directory overrides
- The alternative — one `.ggshield.yaml` at the root with a giant global allowlist — becomes unmanageable

## Prerequisites

- `ggshield` installed (pip or brew) and authenticated with a GitGuardian API token
- A monorepo with at least two distinct service directories
- Basic familiarity with YAML config structure for ggshield

## Steps

### 1. Create a base config at the repo root

Start with a minimal `.ggshield.yaml` that sets sane defaults. This catches secrets in every subdirectory:

```yaml
version: 2
paths-ignore:
  - "**/node_modules/**"
  - "**/vendor/**"
  - "**/.terraform/**"
  - "**/__pycache__/**"
  - "**/*.min.js"
  - "**/*.generated.go"
```

Nothing team-specific here — just the universal noise sources every monorepo has.

### 2. Add per-team override configs

Each team puts a `.ggshield.yaml` inside their service directory with their own allowlist. ggshield applies the *nearest* config when you pass `--recursive` or scan a specific path:

```yaml
# services/payments/.ggshield.yaml
version: 2
paths-ignore:
  - "test/fixtures/**"
  - "docs/examples/**"
  - "migrations/**"
detectors-ignore:
  - "generic_api_key"
```

```yaml
# services/auth/.ggshield.yaml
version: 2
paths-ignore:
  - "test/**"
  - "mock/**"
allow:
  - path: "examples/**/*.yaml"
    diff-start-line: 1
```

The root config still applies to directories that don't have their own `.ggshield.yaml`.

### 3. Structure the CI pipeline

The CI pipeline does two passes:

**Pass 1 — Full repo scan (scheduled):** Catches regressions anywhere. This runs daily or weekly against `HEAD`, producing JSON output for the dashboard.

```bash
ggshield secret scan path . --recursive --json
```

**Pass 2 — PR diff scan (on each PR):** Only checks changed files. This is the gate that blocks secrets from merging.

```bash
ggshield secret scan ci
```

The `ci` command reads the git context from the CI environment (GitHub Actions, GitLab CI, etc.) and automatically limits the scan to the commit range.

### 4. Wire per-team alert routing

The JSON output includes the file path, so a post-processing step can route findings to the right team based on directory prefix:

```bash
ggshield secret scan ci --json | jq -c '.[] | {file: .filename, team: (.filename | split("/")[1])}'
```

I used a simple script that parses the JSON and posts a Slack message per team channel. The mapping is just a `team -> directory prefix` lookup.

## Verify

1. **Check per-config isolation:** Place a test secret file (e.g. `sk_test_xxx`) inside `services/auth/test/` and verify that only the `auth` team is notified, not the entire pipeline — the `auth/.ggshield.yaml` `paths-ignore` should suppress the test directory, not the root config.

2. **Check CI pass/fail on actual secrets:** Add a real-looking secret (tokens, API keys) outside any ignored path and confirm the pipeline exits non-zero.

3. **Check team routing:** Parse the JSON output and confirm findings are tagged with the correct team prefix.

## Common errors

- **Config not picked up:** ggshield looks for `.ggshield.yaml` in the current directory or `--config-path`. If you're scanning from the repo root with `--recursive`, subdirectory configs are applied per-path. If you're scanning a single path, use `-c` to point at the team config explicitly.
- **`detectors-ignore` not respected by all scan modes:** The `detectors-ignore` key works in `secret scan path` but some older ggshield versions ignore it in `secret scan ci`. I had to pin to ggshield >=1.18.
- **Overlapping path-ignore rules:** If the root config ignores `test/**` and a team config allows it, the team config wins for files under that team's directory. But ggshield doesn't warn about overlaps — worth verifying manually.
- **Recursive scan misses files:** `--recursive` scans all subdirectories, but if a subdirectory has its own `.ggshield.yaml`, the root config's `paths-ignore` may still apply to files *not* matched by the sub-config. I ended up using explicit `--exclude` flags per team layer in the pipeline script instead of relying on recursive behavior.

## References

- [ggshield configuration documentation](https://docs.gitguardian.com/ggshield-docs/config)
- [GitGuardian CI integration guide](https://docs.gitguardian.com/ggshield-docs/integrations/ci)
