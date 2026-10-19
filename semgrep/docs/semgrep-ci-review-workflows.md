---
last_verified: 2026-10-18
tool_version: n/a
sources: []
---

# Semgrep CI Review Workflows

## Purpose

This document provides a reference for integrating Semgrep into code review workflows within CI/CD pipelines. It covers PR comment integration, gated merges, review-time feedback loops, and organizational policy enforcement patterns that surface findings directly in the review interface.

## When to Use

Use this reference when:

- Configuring Semgrep to post findings as PR comments rather than (or in addition to) SARIF uploads
- Implementing gated merges that block on severity thresholds
- Setting up organization-wide review policies that apply across repositories
- Integrating Semgrep Cloud Platform for cross-repository finding triage during review
- Building review-time automation that routes findings to code owners

## Prerequisites

- Semgrep CLI or `semgrep/semgrep-action` configured in CI
- GitHub/GitLab/GitHub Enterprise with PR/comment permissions for the CI token
- `security-events: write` and `pull-requests: write` permissions for SARIF upload and PR comments
- Optional: Semgrep Cloud Platform account for centralized triage dashboard
- Optional: CODEOWNERS file configured for automatic reviewer assignment

## Configuration Patterns

### PR Comment Mode

Post findings directly on the pull request as review comments:

```yaml
name: Semgrep PR Review
on:
  pull_request:
    types: [opened, synchronize, reopened]
jobs:
  semgrep-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      security-events: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: semgrep/semgrep-action@v1
        with:
          config: auto
          generate-sarif: true
          severity: WARNING
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
          category: semgrep
```

The action automatically posts annotations on changed lines when `generate-sarif: true` is combined with PR events.

### Gated Merge with Severity Threshold

Block merges when findings exceed a severity floor:

```yaml
name: Semgrep Gate
on:
  pull_request:
    types: [opened, synchronize, reopened]
jobs:
  semgrep-gate:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: semgrep/semgrep-action@v1
        with:
          config: auto
          severity: ERROR
          fail-on: error
          generate-sarif: true
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
          category: semgrep
```

Key settings:
- `severity: ERROR` — only ERROR-level findings count toward the gate
- `fail-on: error` — exits non-zero when any ERROR findings exist
- Combined with branch protection rules requiring this check to pass

### Organization Policy via Semgrep Cloud Platform

Centralize rule configuration and triage state across repositories:

```yaml
name: Semgrep Cloud Sync
on:
  pull_request:
    types: [opened, synchronize, reopened]
  schedule:
    - cron: '0 2 * * *'  # daily sync
jobs:
  semgrep-cloud:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: semgrep/semgrep-action@v1
        with:
          config: https://semgrep.dev/p/<org-slug>
          generate-sarif: true
        env:
          SEMGREP_APP_TOKEN: ${{ secrets.SEMGREP_APP_TOKEN }}
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
          category: semgrep
```

The `config` URL points to a published policy on Semgrep Cloud Platform. The `SEMGREP_APP_TOKEN` authenticates the organization policy.

### CODEOWNERS-Aware Review Routing

Combine SARIF upload with a post-processing step to assign reviewers:

```yaml
      - name: Upload SARIF and extract findings
        id: sarif
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
          category: semgrep

      - name: Route to code owners
        if: always()
        run: |
          # Parse SARIF for file paths with findings
          jq -r '.runs[].results[].locations[].physicalLocation.artifactLocation.uri' semgrep.sarif \
            | sort -u \
            | xargs -I {} git log -1 --format="%ae" -- {} \
            | sort -u \
            | xargs -I {} gh api repos/${{ github.repository }}/pulls/${{ github.event.pull_request.number }}/requested_reviewers -f reviewers[]={}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This extracts unique file paths from SARIF, finds recent contributors via git history, and requests their review.

## Steps

### 1. Enable PR Comment Annotations

Configure the workflow to trigger on `pull_request` events with `fetch-depth: 0` for diff-aware scanning. The action posts inline annotations on changed lines automatically when SARIF is generated.

### 2. Configure Severity Gates

Choose a severity threshold aligned with team policy:
- `severity: ERROR` + `fail-on: error` — hard gate for critical issues only
- `severity: WARNING` + `fail-on: warning` — broader gate including warnings
- Omit `fail-on` for advisory mode (comments posted, merge not blocked)

### 3. Set Up Branch Protection

In repository settings, require the Semgrep workflow to pass before merge:
- Settings → Branches → Branch protection rules → Add rule
- Target branch pattern (e.g., `main`)
- Require status checks to pass → Select the Semgrep job name
- Optional: Require review from code owners

### 4. Integrate with Semgrep Cloud Platform (Optional)

For multi-repo organizations:
1. Create organization policy at `semgrep.dev/p/<org-slug>`
2. Add `SEMGREP_APP_TOKEN` as repository/organization secret
3. Reference the policy URL in `config` field
4. Triage findings in the Cloud Platform dashboard; triage state syncs to PR comments

### 5. Configure Ignore Patterns for Review Noise Reduction

Create `.semgrepignore` at repository root:

```
# Generated code
dist/
build/
*.min.js
*.generated.*

# Vendored dependencies
vendor/
third_party/
node_modules/

# Test fixtures with intentional patterns
tests/fixtures/
testdata/
__snapshots__/
```

Add repository-specific patterns to reduce false positives in review comments.

## Verify

1. Open a test PR with a known violation (e.g., hardcoded secret in a new file)
2. Confirm workflow runs and posts inline annotations on the diff
3. Verify gated merge: PR should show failing status check when `fail-on` threshold met
4. Check SARIF upload in Security → Code scanning alerts
5. If using Cloud Platform, confirm triage state (ignored/triaged) reflects in PR comments
6. Validate CODEOWNERS routing: reviewers assigned match file ownership

## Common Errors

### PR Comments Not Appearing

**Symptom:** Workflow completes but no inline annotations on PR

**Resolution:**
- Verify `fetch-depth: 0` on checkout (required for diff calculation)
- Confirm `pull-requests: write` permission in job permissions
- Ensure workflow triggers on `pull_request` event types including `synchronize`
- Check action logs for "No changed files found" — diff may be empty for first commit on new branch

### Gate Not Blocking Merge

**Symptom:** Findings reported but merge allowed

**Resolution:**
- Verify branch protection rule references the correct job name
- Confirm `fail-on: error` (or `warning`) is set in action config
- Check that workflow job name matches exactly in branch protection settings
- Ensure `security-events: write` permission present for SARIF upload

### Cloud Platform Policy Not Loading

**Symptom:** `config: https://semgrep.dev/p/<org-slug>` fails with 401/404

**Resolution:**
- Verify `SEMGREP_APP_TOKEN` secret exists and has organization admin scope
- Confirm policy is published (not draft) in Semgrep Cloud Platform
- Check organization slug spelling in URL
- Test token locally: `semgrep --config=https://semgrep.dev/p/<org-slug> .`

### Duplicate Annotations on Re-run

**Symptom:** Multiple comment threads for same finding on subsequent pushes

**Resolution:** This is expected GitHub behavior — each workflow run creates new annotations. Previous annotations are marked "outdated" automatically. To consolidate, use a single workflow file for all Semgrep scans rather than separate jobs.

### Memory Exhaustion on Large Monorepos

**Symptom:** OOM kill during scan

**Resolution:**

```yaml
with:
  config: auto
  args: --max-target-bytes 500000 --jobs 2 --oss-only
```

- `--max-target-bytes` limits per-file processing size
- `--jobs` controls parallelism (reduce for memory-constrained runners)
- `--oss-only` skips Pro rules that require more memory

## References

- `semgrep/docs/semgrep-code-scanning-integration-reference.md` — SARIF integration details
- `semgrep/docs/github-actions-ci-from-scratch.md` — Manual CLI workflow setup
- `semgrep/docs/semgrep-rules-migration-guide.md` — Policy versioning across repos