---
last_verified: 2026-10-13
tool_version: n/a
sources: []
---

# TruffleHog integration reference for secret detection

## Purpose

This reference documents how to integrate TruffleHog secret detection into CI/CD pipelines, pre-commit workflows, and scheduled scans across Git repositories, filesystems, and cloud storage. It covers detector configuration, result handling, gating strategies, and operational patterns for production use.

## When to use

- **Pipeline gate** — Block merges when verified secrets are detected in new commits or build artifacts
- **Pre-commit hook** — Catch secrets before they enter version control (local developer guard)
- **Scheduled audit** — Periodic full-history scans of repositories, S3 buckets, or filesystem mounts to find historical leaks
- **Incident response** — Rapid scan of a specific target after a credential rotation event
- **Compliance evidence** — Generate SARIF or JSON reports for audit trails and security dashboards

## Prerequisites

- TruffleHog CLI installed (`trufflesecurity/trufflehog` container image or binary)
- Target access: Git credentials for private repos, AWS credentials/IAM role for S3, filesystem read access for local scans
- CI runner with network egress to scanned registries/repositories (for git/github/gitlab modes)
- `jq` or Python for JSON post-processing and format conversion
- Optional: `trufflehog` configuration file (`.trufflehog.yaml`) for detector tuning and ignore rules

## Steps

### 1. Choose the scan mode for each integration point

| Integration point | Recommended mode | Rationale |
|-------------------|------------------|-----------|
| Pull request validation | `trufflehog git` (with `--since-commit` for diff-aware) | Scans only new commits; fast and targeted |
| Pre-commit | `trufflehog filesystem` | No git history needed; scans working tree instantly |
| Nightly full audit | `trufflehog git` (full history) + `trufflehog s3` (configured buckets) | Comprehensive coverage of historical leaks |
| Build artifact scan | `trufflehog filesystem` on workspace/output dir | Catches interpolated secrets in compiled configs, manifests |
| Container image scan | `trufflehog filesystem` on extracted layers or `trufflehog docker` (if available) | Finds secrets baked into images |

### 2. Configure detectors and verification

TruffleHog ships with 800+ built-in detectors. Enable verification to reduce false positives:

```bash
# Run with verification (default in v3+)
trufflehog git https://github.com/org/repo --results=verified

# Disable verification for initial audit (higher recall)
trufflehog git https://github.com/org/repo --results=verified,unverified

# Use a config file to customize detector behavior
cat > .trufflehog.yaml <<'EOF'
detectors:
  - name: "AWS Access Key"
    verified_only: true
  - name: "GitHub Personal Access Token"
    verified_only: true
ignore:
  - path: "*.test.ts"
    detector: "Generic API Key"
    reason: "Test fixtures with placeholder keys"
EOF
```

Verification requires network access to the credential issuer's API. In air-gapped environments, run with `--results=unverified` and triage manually.

### 3. Gate pipeline stages on verified findings

Exit codes:
- `0` — No findings (or only ignored/unverified when filtered)
- `1` — Verified findings detected
- `2` — Error (auth failure, network timeout, config parse error)

Example GitHub Actions gate:

```yaml
- name: Run TruffleHog on PR diff
  id: trufflehog
  run: |
    trufflehog git https://github.com/${{ github.repository }} \
      --since-commit=${{ github.event.pull_request.base.sha }} \
      --json --fail \
      | tee trufflehog-results.json
    exit_code=${PIPESTATUS[0]}
    echo "exit_code=$exit_code" >> $GITHUB_OUTPUT
    exit $exit_code

- name: Upload SARIF if findings exist
  if: steps.trufflehog.outputs.exit_code == 1
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: trufflehog-results.sarif
    category: trufflehog
```

The `--fail` flag makes TruffleHog exit 1 when verified secrets are found. Combine with `--json` to capture results for SARIF conversion.

### 4. Convert and route results

#### JSON to SARIF (for GitHub Code Scanning)

```bash
trufflehog git https://github.com/org/repo --json --fail \
  | python3 scripts/trufflehog-to-sarif.py > trufflehog-results.sarif
```

The converter script must handle all `SourceMetadata.Data` variants (Git, GitHub, GitLab, Filesystem, S3). See `trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md` for a reference implementation.

#### JSON to CSV (for dashboards/ticketing)

```bash
trufflehog filesystem ./build --json \
  | python3 scripts/trufflehog-to-csv.py > trufflehog-results.csv
```

### 5. Configure ignore rules for known-safe patterns

Ignore rules live in `.trufflehog.yaml` and support path globs, detector names, and reason fields:

```yaml
ignore:
  - path: "tests/fixtures/**"
    detector: "Generic High Entropy String"
    reason: "Test fixtures with high-entropy test data"
  - detector: "Slack Webhook URL"
    reason: "Legacy webhook in docs/example-config.yaml — rotated and revoked"
```

Rules are matched per-result. A result is ignored if **any** rule matches both its path (glob) and detector name. Omit `path` or `detector` to match broadly.

### 6. Schedule full-history and cloud scans

CronJob example for nightly git + S3 audit:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: trufflehog-nightly-audit
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: trufflehog
              image: trufflesecurity/trufflehog:latest
              args:
                - git
                - https://github.com/org/repo
                - --json
                - --fail
                - --results=verified
              env:
                - name: GITHUB_TOKEN
                  valueFrom:
                    secretKeyRef:
                      name: trufflehog-github
                      key: token
              volumeMounts:
                - name: results
                  mountPath: /results
          volumes:
            - name: results
              emptyDir: {}
          restartPolicy: OnFailure
```

Attach a sidecar or post-job step to collect `/results` and upload to artifact storage or SIEM.

## Verify

1. **Gate blocks on known secret** — Add a test credential to a feature branch, open PR, confirm the gate fails with exit code 1 and SARIF uploads.
2. **Ignore rule suppresses expected finding** — Add an ignore rule for a test fixture path, re-run scan, confirm the finding no longer appears in output.
3. **SARIF renders in GitHub Security tab** — Trigger a scan with findings, navigate to the repo's Security > Code scanning alerts, verify TruffleHog category appears.
4. **Scheduled job completes** — Check CronJob history; confirm the container exits 0 (no verified secrets) or 1 (findings captured) without error code 2.
5. **Verification behavior** — Run the same scan with `--results=verified` and `--results=verified,unverified`; delta should only be unverified findings.

## Rollback

| Scenario | Rollback action |
|----------|-----------------|
| Gate blocks legitimate merge (false positive) | Add ignore rule to `.trufflehog.yaml` with `reason`, push to branch, re-run |
| Verification causes CI timeout (network issue) | Temporarily add `--results=unverified` and increase `--timeout`; file issue to rotate credential offline |
| SARIF upload fails (category collision) | Assign unique `category` per scan mode in workflow (`trufflehog-git`, `trufflehog-fs`, `trufflehog-s3`) |
| CronJob fails with error code 2 | Check container logs for auth/network errors; re-deploy with corrected secrets/role; suspend CronJob if persistent |

No scanner-side rollback for emitted findings — once a secret is detected, the remediation is credential rotation, not scan reversal.

## Common errors

- **`--since-commit` with non-ancestor SHA** — In PR workflows, `github.event.pull_request.base.sha` may not be an ancestor if the base branch was force-pushed. Use `github.event.pull_request.merge_base` when available, or fallback to full scan with a timeout.
- **Verified findings missing from SARIF** — Converter script only processes `Verified: true` results but the JSON stream includes both. Filter explicitly: `select(.Verified == true)`.
- **S3 scan hangs on large buckets** — Set `--max-object-size` and `--key-prefix` to limit scope; use `--concurrency` to tune parallelism.
- **Pre-commit hook too slow** — `trufflehog filesystem` scans entire working tree. Restrict with `--exclude-patterns='vendor/,node_modules/,.git/,dist/,build/'`.
- **Container image scan misses layers** — `trufflehog filesystem` on extracted rootfs only sees the final layer. Use `trufflehog docker` (if available) or scan each layer tarball individually.
- **Ignore rule not matching** — Path globs are relative to the scan root. For `trufflehog git`, paths are repo-relative; for `trufflehog filesystem`, paths are relative to the scanned directory argument.

## References

- TruffleHog CLI reference — `trufflehog --help` and `github.com/trufflesecurity/trufflehog`
- Detector catalog — `github.com/trufflesecurity/trufflehog/tree/main/pkg/detectors`
- Configuration file schema — `github.com/trufflesecurity/trufflehog/tree/main/pkg/config`
- Verification logic per detector — `github.com/trufflesecurity/trufflehog/tree/main/pkg/verifier`
- GitHub Actions SARIF upload — `github.com/github/codeql-action`
- SARIF 2.1.0 specification — `oasis-open.github.io/sarif-spec`
- TruffleHog output formats — `trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md`
- Comparing scan modes — `trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md`