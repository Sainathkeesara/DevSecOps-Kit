#!/usr/bin/env bash
# last_verified: 2026-10-24 · AppSec testing concepts
#
# Common patterns I keep reaching for when wiring SAST/DAST/SCA into pipelines.
# These aren't full workflows — just the snippets I copy-paste and adapt.

# SAST: Semgrep fast scan on PR changes only (diff-aware)
# Runs in <30s, good for every commit. Uses community rulesets.
semgrep_scan_pr() {
    local target="${1:-.}"
    semgrep --config=p/security-audit --config=p/secrets \
        --error --quiet --json "$target" 2>/dev/null \
        | jq -r '.results[] | "\(.path):\(.start.line): [\(.extra.severity)] \(.extra.message)"'
}

# SAST: CodeQL deep scan for PR gate (slower, more thorough)
# Requires CodeQL CLI + query packs. Outputs SARIF for GitHub upload.
codeql_scan_pr() {
    local lang="${1:-python}"
    local src_root="${2:-.}"
    local db_dir="/tmp/codeql-db-$$"
    local out_file="/tmp/codeql-results.sarif"

    codeql database create "$db_dir" --language="$lang" --source-root="$src_root" --quiet
    codeql database analyze "$db_dir" \
        "codeql/${lang}-queries:codeql-suites/${lang}-security-extended.qls" \
        --format=sarif-latest --output="$out_file" --quiet
    echo "$out_file"
}

# SCA: Trivy filesystem scan for dependency vulns + misconfig
# Runs on repo root, catches lockfiles, Dockerfiles, K8s manifests.
trivy_sca_scan() {
    local target="${1:-.}"
    trivy fs --scanners vuln,config --severity HIGH,CRITICAL \
        --format table --exit-code 1 "$target"
}

# SCA: Syft SBOM generation (SPDX JSON) for supply chain tracking
syft_sbom() {
    local target="${1:-.}"
    local out_file="${2:-sbom.spdx.json}"
    syft "$target" -o spdx-json="$out_file"
    echo "SBOM written to $out_file"
}

# DAST: ZAP baseline scan against running target
# Fast passive scan + active checks. Good for staging smoke test.
zap_baseline() {
    local target_url="${1:-http://localhost:8080}"
    docker run --rm -t owasp/zap2docker-stable zap-baseline.py \
        -t "$target_url" -r zap-report.html -J zap-report.json
}

# DAST: ZAP full active scan (slower, deeper)
zap_full_scan() {
    local target_url="${1:-http://localhost:8080}"
    docker run --rm -t owasp/zap2docker-stable zap-full-scan.py \
        -t "$target_url" -r zap-full-report.html
}

# Pipeline snippet: SAST on every commit, DAST on merge to main, SCA nightly
# This is the pattern I describe in docs — not a runnable workflow file.
cat <<'PIPELINE_EXAMPLE'
# .github/workflows/appsec.yml (conceptual)
jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: returntocorp/semgrep-action@v1
        with:
          config: p/security-audit p/secrets
  dast:
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - run: docker compose up -d
      - run: zap_baseline http://localhost:8080
  sca:
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'  # nightly
    steps:
      - uses: actions/checkout@v4
      - run: trivy_sca_scan .
      - run: syft_sbom . sbom.spdx.json
      - uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.spdx.json
PIPELINE_EXAMPLE

# Quick reference: which tool for which job
cat <<'TOOL_MATRIX'
Tool          | Type   | Speed    | Best for
--------------|--------|----------|---------------------------
Semgrep       | SAST   | Fast     | Per-commit, IDE, PR comments
CodeQL        | SAST   | Slow     | PR gate, deep analysis, SARIF
Trivy fs      | SCA    | Fast     | Lockfiles, Dockerfiles, K8s
Syft          | SCA    | Fast     | SBOM generation (SPDX/CycloneDX)
OWASP ZAP     | DAST   | Medium   | Staging smoke, auth flows
Nuclei        | DAST   | Fast     | Template-based vuln checks
TOOL_MATRIX

# Usage: source this file, then call functions, or copy snippets into your pipeline.
# Example: semgrep_scan_pr src/