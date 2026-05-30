# How I wired Trivy into a CI pipeline with SARIF output

## Purpose

Trivy's CLI output is readable, but it doesn't integrate with GitHub Code Scanning, Azure DevOps, or GitHub Advanced Security out of the box. SARIF (Static Analysis Results Interchange Format) bridges that gap — CI platforms consume SARIF and surface findings inline on PRs and in security tabs. This doc covers wiring Trivy into a CI pipeline with SARIF output, caching to keep runs fast, and gating on severity thresholds.

## Steps

### 1. Pick a scan mode

Trivy supports several scan types. For a CI pipeline I used `trivy image` (container) and `trivy fs` (filesystem) — SARIF output works with both. The `--format sarif` flag produces the SARIF payload.

```bash
trivy image --format sarif --output results.sarif alpine:latest
```

The pipeline I wired scans the built image (`trivy image`) and the IaC directory (`trivy config`, which is a subset of `trivy fs` focused on misconfigurations).

### 2. Configure SARIF output with severity gating

Trivy writes valid SARIF but the schema version it uses is 2.1.0. Most CI platforms expect that version, so it works as-is. One thing that tripped me up: `--exit-code` and `--format sarif` interact — if you set `--exit-code 1`, Trivy exits non-zero when findings exist, which can halt the pipeline before the SARIF file is uploaded. I worked around this by splitting the scan and the gating:

```bash
# Scan and produce SARIF (never exits non-zero)
trivy image --format sarif --quiet \
  --severity CRITICAL,HIGH \
  --ignore-unfixed \
  --output "$OUTDIR/results.sarif" \
  "$IMAGE"

# Separate gating step
trivy image --severity CRITICAL \
  --exit-code 1 \
  --quiet \
  "$IMAGE"
```

The docs also suggest using `--ignore-status` to filter by fix availability, which helped reduce noise.

### 3. Upload SARIF to GitHub Code Scanning

For GitHub Actions, the `github/codeql-action/upload-sarif` action uploads the file:

```yaml
- name: Upload Trivy SARIF
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: ${{ env.OUTDIR }}/results.sarif
```

No SARIF schema transformation needed — Trivy's output maps to Code Scanning's expected format. The findings show up under the Security > Code Scanning tab grouped by severity.

### 4. Cache the vulnerability database

Trivy downloads its vulnerability DB on every run (~200MB). Caching it cuts scan time from ~30s to ~5s. In GitHub Actions:

```yaml
- name: Cache Trivy DB
  uses: actions/cache@v4
  with:
    path: ${{ env.TRIVY_CACHE_DIR }}
    key: trivy-db-${{ runner.os }}
```

Set `TRIVY_CACHE_DIR` to a writable path (Trivy defaults to `~/.cache/trivy`).

## Verify

1. Run the pipeline on a branch — the SARIF file should be produced at the configured output path.
2. In the CI run, check that the SARIF upload step succeeded (logs show "Uploaded SARIF file" with a listing of results).
3. Open a PR that introduces a known vulnerable dependency (e.g. `lodash@4.17.20` in a Node project). The PR check annotations should show the finding inline.
4. Run `trivy image --format sarif --quiet --output /dev/stdout alpine:latest | jq '.runs[0].results | length'` — should return a positive count of vulnerabilities.
