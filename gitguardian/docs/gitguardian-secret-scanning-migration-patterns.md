---
last_verified: 2026-10-03
tool_version: n/a
sources: []
---

# GitGuardian secret scanning migration patterns

## Purpose

This document describes common migration scenarios when adopting or upgrading
GitGuardian secret scanning in a repository or organization. It covers
configuration format migrations, tool migrations, and organizational rollout
patterns that preserve scan coverage while reducing false positives.

## When to use this approach

Use these patterns when:

- Migrating from the deprecated v1 configuration format to the current v2 format
- Replacing another secret scanner (TruffleHog, Gitleaks, detect-secrets) with GitGuardian
- Consolidating multiple per-repo configurations into an organizational baseline
- Rolling out scanning across a monorepo with incremental team adoption
- Upgrading CI integration from legacy scan commands to the current `ci` subcommand

## Prerequisites

- `ggshield` installed and authenticated with a GitGuardian API token
- Access to modify CI/CD pipeline definitions in the target platforms
- Existing scanner configuration files (if migrating from another tool)

## Migration patterns

### Pattern 1: v1 configuration format to v2 format

The v2 format is required when `version: 2` is present. It changes the top-level
structure and nests several keys under `secret`.

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
version: 2

secret:
  ignored_paths:
    - "vendor/"
  ignored_detectors:
    - "generic_api_key"
  ignored_matches:
    - name: "test fixtures"
      match: "test/fixtures/**"
```

**Migration steps:**

1. Change `version: 1` to `version: 2` (integer, not string)
2. Move path excludes under `secret.ignored_paths`
3. Move detector slugs under `secret.ignored_detectors`
4. Move known secrets under `secret.ignored_matches` with `name` + `match`
5. Validate the migrated config: `ggshield --config-path .ggshield.yaml secret scan path . --recursive`

**Common issues:**

- Detector slugs that worked in v1 may have been renamed; verify each entry against
  the GitGuardian dashboard detector list
- `ignored_matches` requires both `name` and `match` fields; a bare string is rejected
- The v2 format is detected from the `version: 2` line; an absent or `version: 1`
  file is treated as the legacy v1 format

### Pattern 2: Migrating from TruffleHog to GitGuardian

TruffleHog and GitGuardian both detect secrets but use different configuration
models and detector catalogs.

**Configuration mapping:**

| TruffleHog concept | GitGuardian equivalent |
|---|---|
| `--exclude-paths` | `secret.ignored_paths` |
| `--allowlist` (regex-based) | `secret.ignored_matches` with `match` |
| `--detector` disable | `secret.ignored_detectors` with exact slug |
| `--fail` / `--no-fail` | CI gate: `ggshield secret scan ci` exits non-zero on findings |

**Detector differences:**

TruffleHog uses detector names like `AWS`, `GitHub`, `Generic`. GitGuardian
uses slugs like `aws_access_key`, `github_token`, `generic_api_key`. There is
no 1:1 mapping; compare findings from a baseline scan and adjust
`secret.ignored_detectors` per slug.

**Migration steps:**

1. Export the current TruffleHog allowlist and exclude patterns
2. Run a baseline GitGuardian scan on the same repo:
   `ggshield secret scan path . --recursive --json > baseline.json`
3. Compare findings and identify detectors that produce different results
4. Build the `.gitguardian.yaml` by translating each TruffleHog rule:
   - Global path excludes go to `secret.ignored_paths`
   - Per-path allowlist entries go to `secret.ignored_matches`
   - Disabled detectors go to `secret.ignored_detectors`
5. Run both scanners in parallel for one sprint; require GitGuardian to pass before merging
6. After validation, remove TruffleHog from CI and update documentation

**Rollback:**

Keep the TruffleHog CI job disabled but present for two release cycles. If
GitGuardian misses a class of secrets TruffleHog caught, re-enable TruffleHog
and file a detector gap with GitGuardian support.

### Pattern 3: Migrating from Gitleaks to GitGuardian

Gitleaks uses a TOML configuration with rule-based allowlists. GitGuardian uses
YAML with path-based ignores.

**Configuration mapping:**

| Gitleaks concept | GitGuardian equivalent |
|---|---|
| `[[rules]]` with `allowlist` | `secret.ignored_matches` with `match` |
| `path` in rule | `secret.ignored_paths` for hard skips |
| `regex` custom rules | Not directly supported; use the dashboard detector list or request a custom detector |

**Migration steps:**

1. Extract all `allowlist` entries from `gitleaks.toml`
2. Convert each to a GitGuardian `ignored_matches` entry:
   - Gitleaks regex allowlist becomes a GitGuardian `match` value
   - Gitleaks `path` allowlist becomes a GitGuardian `ignored_paths` entry
3. Move path exclusions to `secret.ignored_paths`
4. Custom Gitleaks rules with no GitGuardian equivalent require either:
   - Accepting the `generic_api_key` detector and ignoring specific paths, or
   - Requesting a custom detector from GitGuardian (paid plans)
5. Validate by running both scanners on a corpus of known-good and known-bad commits

### Pattern 4: Organizational baseline rollout with per-repo narrowing

An organization establishes a baseline policy that teams narrow for their
repositories.

**Baseline policy (org level):**

```yaml
version: 2

secret:
  ignored_paths:
    - "node_modules/"
    - "vendor/"
    - "dist/"
    - "build/"
  ignored_detectors: []
```

**Per-repo narrowing (team level):**

Each repo copies the baseline and adds:

```yaml
version: 2

secret:
  ignored_detectors:
    - "slack_webhook"  # Only if legacy webhook format is used in tests
  ignored_paths:
    - "tests/fixtures/**"
  ignored_matches:
    - name: "test fixtures"
      match: "tests/fixtures/**"
```

**Rollout steps:**

1. Publish the baseline as a template in the org's template repo
2. New repos initialize with the template; existing repos adopt on a schedule
3. Track adoption via a dashboard that scans for the baseline policy name
4. Quarterly review: each team presents their `ignored_matches` entries with
   review dates; entries older than 90 days without review are flagged

### Pattern 5: Monorepo incremental team adoption

A monorepo adopts GitGuardian team-by-team without a big-bang config change.

**Phase 1: Root config only (global noise reduction):**

```yaml
# .gitguardian.yaml at repo root
version: 2

secret:
  ignored_paths:
    - "**/node_modules/**"
    - "**/vendor/**"
    - "**/.terraform/**"
    - "**/__pycache__/**"
```

All teams scan with the root config. No per-team overrides yet.

**Phase 2: First team adds override:**

Team Payments adds `services/payments/.gitguardian.yaml`:

```yaml
version: 2

secret:
  ignored_paths:
    - "test/fixtures/**"
  ignored_matches:
    - name: "test fixtures"
      match: "test/fixtures/**"
```

The scanner applies the nearest config. Other teams are unaffected.

**Phase 3: All teams have overrides; CI routes by team:**

CI script post-processes findings by directory prefix and routes to team
channels. See `gitguardian/docs/monorepo-ci-per-team-exclusions.md` for the
routing implementation.

**Phase 4: Organizational policy replaces root config:**

The root config becomes the org baseline (Pattern 4). Team overrides remain as
narrowing layers.

**Verification at each phase:**

- Phase 1: Full repo scan produces fewer than 10 findings (all false positives from known noise)
- Phase 2: Team scan on their directory produces zero findings on clean commits
- Phase 3: Routing script correctly tags 100% of findings to a team
- Phase 4: No repo scans without an ownership entry; all `ignored_matches` entries have a review date within 90 days

### Pattern 6: Legacy `secret scan repo` to `secret scan ci` in CI pipelines

Older pipelines used `ggshield secret scan repo` or `ggshield secret scan path .`
for PR checks. The `ci` subcommand automatically detects the PR commit range
from the CI environment.

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
2. Remove any manual `COMMIT_RANGE` or `GITHUB_SHA` logic; `ci` reads the CI environment automatically
3. Verify the job fails on a test PR with a seeded secret in the diff
4. Verify the job passes on a PR without secrets
5. Update scheduled full-repo scans to continue using `ggshield secret scan path . --recursive`

**Compatibility note:**

`ggshield secret scan ci` requires a supported CI environment (GitHub Actions,
GitLab CI, Bitbucket Pipelines, Azure Pipelines, CircleCI, Jenkins). For
unsupported CIs, fall back to `secret scan commit-range` with an explicit range.

## Verify

1. **Config validity:** Every migrated `.gitguardian.yaml` passes
   `ggshield --config-path .gitguardian.yaml secret scan path . --recursive`
   with exit code 0
2. **Coverage parity:** A corpus of 50 historical commits with known secrets
   produces findings in GitGuardian that are a superset of the previous
   scanner's findings (no regressions)
3. **False positive reduction:** The same corpus produces fewer false positive
   findings than the previous configuration
4. **CI gate enforcement:** A test PR with a seeded secret is blocked; the
   required status check appears in branch protection
5. **Team routing:** In monorepo mode, findings are tagged with the correct
   team prefix for 100% of test findings placed in team directories
6. **Allowlist freshness:** All `ignored_matches` entries in active configs
   have a review date within the last 90 days

## Common errors

- **Ignoring a detector instead of a path:** Adding a slug to
  `secret.ignored_detectors` silences an entire class of secrets globally. Use
  `secret.ignored_matches` with a narrow `match` value instead.
- **Allow entries without expiry:** An `ignored_matches` entry without a review
  date becomes a permanent blind spot. Require a review date on every entry.
- **Ownership gaps:** A directory prefix with no ownership entry means findings
  in that path have no default route. Always include a fallback entry.
- **Version drift:** Teams pin different ggshield versions. Standardize on a
  single version in CI and document the minimum version in the config header.
- **CI environment detection failure:** `ggshield secret scan ci` run outside a
  supported CI (e.g., local terminal with `CI=true`) falls back to a full diff
  scan. Document this behavior for developers running pre-push hooks.
- **Scheduled scan blocking:** Configuring scheduled full-repo scans to block
  (exit non-zero) creates noise on historical findings. Scheduled scans should
  report only; PR scans should block.

## References

- ggshield configuration reference: https://docs.gitguardian.com/ggshield-docs/configuration
- ggshield secret scan path reference: https://docs.gitguardian.com/ggshield-docs/reference/secret/scan/path
- ggshield secret scan overview: https://docs.gitguardian.com/ggshield-docs/reference/secret/scan/overview
- ggshield config list reference: https://docs.gitguardian.com/ggshield-docs/reference/config/list
- GitGuardian CI integration guide: https://docs.gitguardian.com/ggshield-docs/integrations/ci
- Existing CI/CD integration doc: `gitguardian/docs/cicd-secret-scanning-integration.md`
- Monorepo per-team exclusions: `gitguardian/docs/monorepo-ci-per-team-exclusions.md`
- Incident response workflow: `gitguardian/docs/gitguardian-incident-response-workflow.md`
- Org policy template: `gitguardian/configs/policy-configuration.yaml`
- Monorepo allowlists example: `gitguardian/configs/monorepo-allowlists.yaml`
- Base config template: `gitguardian/configs/.gitguardian.yaml`
- Incident response pipeline script: `gitguardian/scripts/gg-incident-response-pipeline.sh`
