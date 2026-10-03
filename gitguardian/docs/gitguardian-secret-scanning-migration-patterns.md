---
last_verified: 2026-10-03
tool_version: n/a
sources:
  - https://docs.gitguardian.com/ggshield-docs/config
  - https://docs.gitguardian.com/ggshield-docs/integrations/ci
---

# GitGuardian secret scanning migration patterns

## Purpose

This document describes common migration scenarios when adopting or upgrading GitGuardian secret scanning in a repository or organization. It covers configuration format migrations, tool migrations, and organizational rollout patterns that preserve scan coverage while reducing false positives.

## When to use this approach

Use these patterns when:

- Migrating from ggshield v1 configuration format to v2
- Replacing another secret scanner (TruffleHog, Gitleaks, detect-secrets) with GitGuardian
- Consolidating multiple per-repo configurations into an organizational baseline
- Rolling out scanning across a monorepo with incremental team adoption
- Upgrading CI integration from legacy scan commands to the current `ci` subcommand

## Prerequisites

- `ggshield` v1.18+ installed (v2 config format requires v1.18 minimum)
- GitGuardian API token with appropriate scope for the target repositories
- Access to modify CI/CD pipeline definitions in the target platforms
- Existing scanner configuration files (if migrating from another tool)

## Migration patterns

### Pattern 1: ggshield v1 → v2 configuration format

The v2 configuration (introduced in ggshield 1.18) changes the top-level structure and renames several keys.

**v1 format (legacy):**

```yaml
version: 1
ignored-matches:
  - "test/fixtures/**"
ignored-detectors:
  - "generic_api_key"
paths-ignore:
  - "vendor/"
```

**v2 format (current):**

```yaml
version: "2"
ignore-known-paths:
  - "vendor/"
ignored-detectors:
  - "generic_api_key"
ignored-paths:
  - "test/fixtures/**"
allow:
  - path: "test/fixtures/**"
    diff-start-line: 1
```

**Migration steps:**

1. Change `version: 1` to `version: "2"` (string, not number)
2. Move `paths-ignore` entries to `ignore-known-paths` for build/vendor directories
3. Move `paths-ignore` entries for test fixtures and examples to `ignored-paths` with corresponding `allow` entries that include `diff-start-line: 1`
4. Keep `ignored-detectors` as-is — the key name is unchanged
5. Validate the migrated config: `ggshield secret scan path . --config-path .ggshield.yaml --dry-run`

**Common issues:**

- Using numeric `version: 2` instead of string `version: "2"` causes a parse error
- Forgetting `allow` entries for paths moved from `paths-ignore` — the v2 scanner treats `ignored-paths` as hard skips without the corresponding `allow`
- Detector slugs that worked in v1 may have been renamed in v2; verify each entry against `ggshield list detectors`

### Pattern 2: Migrating from TruffleHog to GitGuardian

TruffleHog and GitGuardian both detect secrets but use different configuration models and detector catalogs.

**Configuration mapping:**

| TruffleHog concept | GitGuardian equivalent |
|---|---|
| `--exclude-paths` | `ignore-known-paths` + `ignored-paths` |
| `--allowlist` (regex-based) | `allow` with path patterns |
| `--detector` disable | `ignored-detectors` with exact slug |
| `--fail` / `--no-fail` | CI gate: `ggshield secret scan ci` exits non-zero on findings |

**Detector differences:**

TruffleHog uses detector names like `AWS`, `GitHub`, `Generic`. GitGuardian uses slugs like `aws_access_key`, `github_token`, `generic_api_key`. There is no 1:1 mapping — run `ggshield list detectors` and map each enabled TruffleHog detector to the closest GitGuardian slug.

**Migration steps:**

1. Export the current TruffleHog allowlist/exclude patterns
2. Run a baseline GitGuardian scan on the same repo: `ggshield secret scan path . --recursive --json > baseline.json`
3. Compare findings — identify detectors that produce different results
4. Build the `.ggshield.yaml` by translating each TruffleHog rule:
   - Global path excludes → `ignore-known-paths`
   - Per-path allowlist entries → `allow` with `path` and `diff-start-line`
   - Disabled detectors → `ignored-detectors`
5. Run both scanners in parallel for one sprint; require GitGuardian to pass before merging
6. After validation, remove TruffleHog from CI and update documentation

**Rollback:**

Keep the TruffleHog CI job disabled but present for two release cycles. If GitGuardian misses a class of secrets TruffleHog caught, re-enable TruffleHog and file a detector gap with GitGuardian support.

### Pattern 3: Migrating from Gitleaks to GitGuardian

Gitleaks uses a TOML configuration with rule-based allowlists. GitGuardian uses YAML with path-based allows.

**Configuration mapping:**

| Gitleaks concept | GitGuardian equivalent |
|---|---|
| `[[rules]]` with `allowlist` | `allow` entries with `path` glob |
| `path` in rule | `ignored-paths` for hard skips |
| `regex` custom rules | Not directly supported — use `generic_api_key` ignore or request a custom detector |

**Migration steps:**

1. Extract all `allowlist` entries from `gitleaks.toml`
2. Convert each to a GitGuardian `allow` entry:
   - Gitleaks regex allowlist → GitGuardian `path` glob (less precise, broader)
   - Gitleaks `path` allowlist → GitGuardian `allow` with exact path
3. Move `path` exclusions from rules to `ignore-known-paths` (for vendor/build) or `ignored-paths` (for test fixtures)
4. Custom Gitleaks rules with no GitGuardian equivalent require either:
   - Accepting the `generic_api_key` detector and allowing specific paths, or
   - Requesting a custom detector from GitGuardian (paid plans)
5. Validate by running both scanners on a corpus of known-good and known-bad commits

### Pattern 4: Organizational baseline rollout with per-repo narrowing

An organization establishes a baseline policy that teams narrow for their repositories.

**Baseline policy (org level):**

```yaml
version: "2"
policy:
  name: "org-secret-policy-baseline"
  scope: "Org baseline; repos copy and narrow."
ignored-detectors: []
ignore-known-paths:
  - "node_modules/"
  - "vendor/"
  - "dist/"
  - "build/"
```

**Per-repo narrowing (team level):**

Each repo copies the baseline and adds:

```yaml
# Repo-specific additions only
ignored-detectors:
  - "slack_webhook"  # Only if legacy webhook format is used in tests
ignored-paths:
  - path: "tests/fixtures/**"
    reason: "Test fixtures with placeholder tokens"
allow:
  - path: "tests/fixtures/**"
    diff-start-line: 1
    reviewed_on: "2026-10-03"
ownership:
  - prefix: "/"
    owner: "repo-maintainers"
    channel: "#security-findings"
```

**Rollout steps:**

1. Publish the baseline as a template in the org's template repo
2. New repos initialize with the template; existing repos adopt on a schedule
3. Track adoption via a dashboard that scans for `policy.name` containing `org-secret-policy-baseline`
4. Quarterly review: each team presents their `allow` entries with `reviewed_on` dates; entries older than 90 days without review are flagged

### Pattern 5: Monorepo incremental team adoption

A monorepo adopts GitGuardian team-by-team without a big-bang config change.

**Phase 1 — Root config only (global noise reduction):**

```yaml
# .ggshield.yaml at repo root
version: "2"
ignore-known-paths:
  - "**/node_modules/**"
  - "**/vendor/**"
  - "**/.terraform/**"
  - "**/__pycache__/**"
```

All teams scan with the root config. No per-team overrides yet.

**Phase 2 — First team adds override:**

Team Payments adds `services/payments/.ggshield.yaml`:

```yaml
version: "2"
ignored-paths:
  - "test/fixtures/**"
allow:
  - path: "test/fixtures/**"
    diff-start-line: 1
```

The scanner applies the nearest config. Other teams unaffected.

**Phase 3 — All teams have overrides; CI routes by team:**

CI script post-processes findings by directory prefix and routes to team channels. See `gitguardian/docs/monorepo-ci-per-team-exclusions.md` for the routing implementation.

**Phase 4 — Organizational policy replaces root config:**

The root config becomes the org baseline (Pattern 4). Team overrides remain as narrowing layers.

**Verification at each phase:**

- Phase 1: Full repo scan produces fewer than 10 findings (all false positives from known noise)
- Phase 2: Team scan on their directory produces zero findings on clean commits
- Phase 3: Routing script correctly tags 100% of findings to a team
- Phase 4: No repo scans without an ownership entry; all `allow` entries have `reviewed_on` within 90 days

### Pattern 6: Legacy `secret scan repo` → `secret scan ci` in CI pipelines

Older pipelines used `ggshield secret scan repo` or `ggshield secret scan path .` for PR checks. The `ci` subcommand (added in v1.15) automatically detects the PR commit range.

**Legacy PR job:**

```bash
# Scans entire repo on every PR — slow and noisy
ggshield secret scan path . --recursive
```

**Modern PR job:**

```bash
# Scans only the PR diff — fast and precise
ggshield secret scan ci
```

**Migration steps:**

1. Replace the scan command in the CI workflow
2. Remove any manual `COMMIT_RANGE` or `GITHUB_SHA` logic — `ci` reads the CI environment automatically
3. Verify the job fails on a test PR with a seeded secret in the diff
4. Verify the job passes on a PR without secrets
5. Update scheduled full-repo scans to continue using `secret scan path . --recursive`

**Compatibility note:**

`ggshield secret scan ci` requires a supported CI environment (GitHub Actions, GitLab CI, Bitbucket Pipelines, Azure Pipelines, CircleCI, Jenkins). For unsupported CIs, fall back to `secret scan commit-range` with an explicit range.

## Verify

1. **Config validity:** Every migrated `.ggshield.yaml` passes `ggshield secret scan path . --config-path .ggshield.yaml --dry-run` with exit code 0
2. **Coverage parity:** A corpus of 50 historical commits with known secrets produces findings in GitGuardian that are a superset of the previous scanner's findings (no regressions)
3. **False positive reduction:** The same corpus produces fewer false positive findings than the previous configuration
4. **CI gate enforcement:** A test PR with a seeded secret is blocked; the required status check appears in branch protection
5. **Team routing:** In monorepo mode, findings are tagged with the correct team prefix for 100% of test findings placed in team directories
6. **Allowlist freshness:** All `allow` entries in active configs have a `reviewed_on` date within the last 90 days

## Common errors

- **Ignoring a detector instead of a path:** Adding `generic_api_key` to `ignored-detectors` silences an entire class of secrets globally. Use `allow` with a narrow path instead.
- **Allow entries without expiry:** An `allow` entry without `reviewed_on` becomes a permanent blind spot. Require a review date on every entry.
- **Ownership gaps:** A directory prefix with no `ownership` entry means findings in that path have no default route. Always include a fallback `/` entry.
- **Version drift:** Teams pin different ggshield versions. Standardize on a single version in CI and document the minimum version in the config header.
- **CI environment detection failure:** `ggshield secret scan ci` run outside a supported CI (e.g., local terminal with `CI=true`) falls back to full diff scan. Document this behavior for developers running pre-push hooks.
- **Scheduled scan blocking:** Configuring scheduled full-repo scans to `block` (exit non-zero) creates noise on historical findings. Scheduled scans should `report` only; PR scans should `block`.

## References

- GitGuardian CI integration guide: https://docs.gitguardian.com/ggshield-docs/integrations/ci
- ggshield configuration reference: https://docs.gitguardian.com/ggshield-docs/config
- ggshield detector list: `ggshield list detectors`
- Existing CI/CD integration doc: `gitguardian/docs/cicd-secret-scanning-integration.md`
- Monorepo per-team exclusions: `gitguardian/docs/monorepo-ci-per-team-exclusions.md`
- Incident response workflow: `gitguardian/docs/gitguardian-incident-response-workflow.md`
- Org policy template: `gitguardian/configs/policy-configuration.yaml`
- Monorepo allowlists example: `gitguardian/configs/monorepo-allowlists.yaml`
- Base config template: `gitguardian/configs/.ggshield.yaml`
- Incident response pipeline script: `gitguardian/scripts/gg-incident-response-pipeline.sh`