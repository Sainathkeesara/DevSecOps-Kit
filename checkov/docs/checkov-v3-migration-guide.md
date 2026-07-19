---
last_verified: 2026-07-19
tool_version: 3.3.8
sources:
  - https://pypi.org/project/checkov
  - https://github.com/bridgecrewio/checkov/releases
  - https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md
  - https://github.com/bridgecrewio/checkov/releases/tag/3.2.532
---

# Checkov v3 migration guide: removed flags, custom-check API changes, and CI updates

## Purpose

Checkov 3.x changed behavior that older pipelines and custom checks depend on. This guide lists the breaking changes between Checkov 2.x and 3.x that affect CI configuration and custom-policy code, so you can upgrade without a broken gate.

## When to use

- You are upgrading a CI pipeline from `checkov` 2.x to 3.x and the scan step starts failing or silently behaving differently.
- You maintain custom Python policies (`--external-checks-dir`) and they no longer load after the upgrade.
- You pin a Checkov version and need to know what 3.x expects that 2.x did not.

## Prerequisites

- Checkov 3.x installed. The current release is **3.3.8** (released 2026-07-09 on PyPI; the prior 3.3.7 shipped 2026-07-07). It requires Python >=3.9 and installs via `pip install checkov`, Homebrew (`brew install checkov`), or the `bridgecrew/checkov` Docker image [source: https://pypi.org/project/checkov].
- Access to the CI configuration (GitHub Actions, GitLab CI, or your runner of choice) that invokes `checkov`.
- Any custom checks you load via `--external-checks-dir` available for review.

## Steps

### 1. Replace removed download/suppression flags

Checkov 3.x removed the `--no-guide`, `--skip-suppressions`, and `--skip-policy-download` flags. All three are consolidated into `--skip-download`. A 2.x command like this:

```bash
checkov -d . --skip-suppressions --skip-policy-download
```

becomes:

```bash
checkov -d . --skip-download
```

If you are still passing the removed flags, Checkov 3.x errors instead of ignoring them, so the CI step fails at startup [source: https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md].

### 2. Remove the "level up" prompt expectation

The v2→v3 migration removed the "level up" flow: bare `checkov` no longer prompts for the Bridgecrew cloud. If your onboarding docs or CI wrapper assumed an interactive prompt, remove that step [source: https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md].

### 3. Pass `--repo-id` when authenticating with an API key

Anyone running `checkov` with an API key must now pass `--repo-id example/example`. A 2.x invocation that relied on implicit repo resolution now requires the explicit flag, otherwise the run fails to associate results with a repository [source: https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md].

```bash
checkov -d . --api-key "$BC_API_KEY" --repo-id my-org/my-repo
```

### 4. Update custom Python checks (removed `entity_type`)

Checkov 3.x simplified the custom-check Python API: `scan_resource_conf` no longer takes the `entity_type` parameter. An old check like this:

```python
# Checkov 2.x — no longer valid
class MyCustomCheck(checkov.BaseResourceCheck):
    def scan_resource_conf(self, conf, entity_type):
        ...
```

becomes:

```python
# Checkov 3.x — entity_type is dropped from the signature
class MyCustomCheck(checkov.BaseResourceCheck):
    def scan_resource_conf(self, conf):
        ...
```

The `entity_type` value is still reachable inside the check via `self.entity_type`, so your logic that branched on the type can read it from the instance rather than the argument [source: https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md].

### 5. Account for hardened custom-check loading (3.2.532+)

From version **3.2.532**, Checkov verifies ECDSA-P256 signatures on external custom checks before loading them. Custom checks distributed from a shared policy repo must now be signed, or loading fails. This is supply-chain protection for org policy repositories [source: https://github.com/bridgecrewio/checkov/releases/tag/3.2.532]. If your pipeline loads unsigned checks via `--external-checks-dir`, sign them or pin a Checkov version below 3.2.532 only as a short-term stopgap.

### 6. Confirm output formats your CI consumes still exist

Checkov 3.x emits CLI, CycloneDX, JSON, JUnit XML, CSV, and SARIF (for GitHub code scanning). If your CI parses a specific format, confirm the flag (e.g. `--output json`, `--output sarif`) is unchanged — these formats are intact across the 2.x→3.x boundary [source: https://pypi.org/project/checkov] [source: https://infrasketch.cloud/blog/checkov-diagram-visualization.html].

## Verify

1. Run the upgraded command locally against a known misconfigured Terraform directory and confirm it still returns a non-zero exit on failures (Checkov's CI-gate behavior is unchanged).
2. Grep your CI config for the removed flags (`--no-guide`, `--skip-suppressions`, `--skip-policy-download`) and confirm none remain.
3. Load your custom checks with `--external-checks-dir` and confirm all expected rule IDs appear; a dropped `entity_type` argument would have raised at import.
4. If you use an API key, confirm `--repo-id` is present and the run associates with the correct repository.

## Rollback

If the upgrade breaks the gate and you need a fast revert, pin the previous 3.x or 2.x line in your install step (e.g. `pip install checkov==2.x.x` or an earlier `3.2.x` for the signature change). Revert the CI flag edits and custom-check signature changes after you confirm the older version. Treat rollback as temporary — the removed flags and the `entity_type` parameter are not coming back.

## Common errors

| Error / symptom | Cause | Fix |
|-----------------|-------|-----|
| `unrecognized arguments: --skip-suppressions` | Removed flag | Replace with `--skip-download` |
| Custom check fails to import with a signature error | Unsigned check on 3.2.532+ | Sign the check with the repo ECDSA-P256 key, or upgrade the signing step |
| `scan_resource_conf() takes 2 positional arguments but 3 were given` | Old `entity_type` parameter | Drop `entity_type` from the method signature; read `self.entity_type` |
| Auth run fails to attribute results | Missing `--repo-id` | Add `--repo-id org/repo` when using `--api-key` |
| No interactive "level up" prompt | Removed in v3 | Remove the prompt step from onboarding/CI wrapper |

## References

- [Checkov on PyPI (version 3.3.8)](https://pypi.org/project/checkov)
- [Checkov releases](https://github.com/bridgecrewio/checkov/releases)
- [Checkov v2 → v3 migration notes](https://github.com/bridgecrewio/checkov/blob/main/docs/1.Welcome/Migration.md)
- [Checkov 3.2.532 release (ECDSA signature verification)](https://github.com/bridgecrewio/checkov/releases/tag/3.2.532)
