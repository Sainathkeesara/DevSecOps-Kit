# TruffleHog output format reference — JSON, SARIF, and CSV for CI ingestion

## Purpose

TruffleHog emits structured output that CI pipelines consume for gating, alerting, and audit trails. Understanding the native JSON schema and the conversion paths to SARIF and CSV is required to build reliable secret-scanning stages without brittle text parsing.

This reference documents the three formats supported by the TruffleHog v3+ CLI, their field mappings, and the conversion strategies used in GitHub Actions, GitLab CI, and Jenkins pipelines.

## When to use

- **JSON** — Default structured output for downstream tooling, jq filtering, or custom parsers. Use when the consuming step is a script or a security platform that ingests TruffleHog JSON directly.
- **SARIF** — Required for GitHub Code Scanning, Azure DevOps, or any platform that expects a SARIF 2.1.0 report. Use when secrets must appear in the GitHub Security tab or when the pipeline runs `upload-sarif`.
- **CSV** — Useful for spreadsheet review, ticketing exports, or legacy dashboards that do not accept JSON. Use when a human-readable tabular feed is needed for triage outside the CI UI.

## Prerequisites

- TruffleHog v3.x installed or available as a container image (`trufflesecurity/trufflehog:latest`)
- `jq` for JSON filtering and transformation
- Python 3.8+ or `yq` for format conversion
- CI runner with network access to the target registry or repository being scanned
- `trufflehog` CLI invoked with one of the output flags: `--json`, `--json-legacy`, or `--github-actions`

## Steps

### 1. Emit native JSON

The v3 CLI outputs one JSON object per result line by default when `--json` is passed.

```bash
trufflehog git https://github.com/example/repo --json --results=verified,unverified
```

Key fields in each JSON object:

| Field | Type | Description |
|-------|------|-------------|
| `SourceMetadata` | object | Protobuf-derived metadata containing branch, commit, file, and line information |
| `DetectorName` | string | Human-readable detector name (e.g. `AWS Access Key`) |
| `Verified` | boolean | Whether the credential passed live verification |
| `Raw` | string | The detected secret as found in the source |
| `Redacted` | string | Safe-to-display version for logs and reports |
| `StructuredData` | object | Structured details such as certificate fingerprints or username fields |
| `SourceID` | number | Internal identifier for the scanned source type |

Use `jq` to filter before writing artifacts to reduce artifact size:

```bash
trufflehog filesystem ./src --json --results=verified \
  | jq -c 'select(.Verified == true)' > verified-secrets.json
```

### 2. Convert JSON to SARIF for GitHub Code Scanning

TruffleHog does not emit SARIF natively. Convert using a small wrapper script or `jq` transformation. The minimal conversion maps each TruffleHog result to a SARIF `result` object with `physicalLocation` derived from `SourceMetadata`.

```bash
trufflehog git https://github.com/example/repo --json \
  | python3 -c '
import sys, json
from pathlib import Path

sarif = {
  "version": "2.1.0",
  "runs": [{
    "tool": {"driver": {"name": "TruffleHog", "informationUri": "https://github.com/trufflesecurity/trufflehog"}},
    "results": []
  }]
}

for line in sys.stdin:
    r = json.loads(line)
    meta = r.get("SourceMetadata", {}).get("Data", {})
    git = meta.get("Git", {})
    fs = meta.get("Filesystem", {})
    uri = git.get("file") or fs.get("file") or ""
    region = sarif["runs"][0]["results"]
    loc = {"physicalLocation": {"artifactLocation": {"uri": uri}}}
    if "line" in (git or fs or {}):
        loc["physicalLocation"]["region"] = {"startLine": git.get("line") or fs.get("line")}
    region.append({
        "ruleId": r.get("DetectorName", "trufflehog-detector"),
        "level": "error" if r.get("Verified") else "warning",
        "message": {"text": f"Secret detected: {r.get(\"DetectorName\")}"},
        "locations": [loc]
    })

print(json.dumps(sarif))
' > trufflehog-results.sarif
```

Upload with `github/codeql-action/upload-sarif@v3` in GitHub Actions:

```yaml
- name: Run TruffleHog and convert to SARIF
  run: |
    trufflehog git https://github.com/example/repo --json \
      | python3 scripts/trufflehog-to-sarif.py > trufflehog-results.sarif

- name: Upload SARIF to GitHub Code Scanning
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: trufflehog-results.sarif
    category: trufflehog
```

### 3. Convert JSON to CSV for downstream dashboards

Flatten the JSON stream into a CSV with deterministic columns:

```bash
trufflehog filesystem ./src --json \
  | jq -r '
    [.DetectorName, .Verified, .Redacted, .SourceMetadata.Data.Git.file, .SourceMetadata.Data.Git.commit]
    | @csv
  ' > trufflehog-results.csv
```

For cross-platform `SourceMetadata` handling (Git, S3, filesystem in one CSV), use a small Python script instead of chained `jq` filters:

```python
import csv, json, sys

writer = csv.writer(sys.stdout)
writer.writerow(["detector", "verified", "redacted", "file", "commit", "branch"])

for line in sys.stdin:
    r = json.loads(line)
    meta = r.get("SourceMetadata", {}).get("Data", {})
    git = meta.get("Git", {})
    fs = meta.get("Filesystem", {})
    writer.writerow([
        r.get("DetectorName", ""),
        r.get("Verified", False),
        r.get("Redacted", ""),
        git.get("file") or fs.get("file") or "",
        git.get("commit", ""),
        git.get("branch", ""),
    ])
```

Pipe TruffleHog JSON into the script and redirect stdout to artifact storage.

## Verify

1. **JSON round-trip** — Confirm the emitted file is valid JSON lines:
   ```bash
   trufflehog filesystem ./src --json | jq empty
   ```
2. **SARIF schema** — Validate the converted report against the SARIF 2.1.0 JSON schema before upload:
   ```bash
   python3 -m json.tool trufflehog-results.sarif >/dev/null && echo "valid SARIF"
   ```
3. **CSV column integrity** — Spot-check that headers are stable and no column shifts occur when `SourceMetadata` contains empty fields:
   ```bash
   head -3 trufflehog-results.csv
   ```
4. **CI ingestion test** — Trigger a pipeline with a known fake secret and confirm the expected result appears in the target platform (GitHub Security tab, dashboard, or ticket).

## Common errors

- **Empty SARIF `runs[0].results`** — Occurs when `jq` or the Python converter selects `--results=verified` but the scanned repo contains no live credentials. The SARIF file is still valid but yields zero alerts. Fix by scanning a repo with known test keys or loosening the results filter during validation.
- **Bucket key collision in GitHub Actions** — If multiple TruffleHog jobs in the same workflow upload SARIF, set `category` to a unique value (e.g. `trufflehog-git`, `trufflehog-filesystem`) so uploads do not overwrite each other.
- **CSV injection in dashboards** — `Redacted` values can still contain formula-like strings. Wrap the CSV parser in the consumer or sanitize cells pre-export if the downstream system evaluates formulas.
- **`SourceMetadata` shape mismatch** — Git, GitHub, GitLab, filesystem, and S3 sources populate different sub-objects under `SourceMetadata.Data`. A converter that assumes `Git.file` will produce empty locations for filesystem or S3 scans.
- **Large artifact queue timeout** — A full-history git scan against a large repo can produce JSON lines in the hundreds of megabytes. Buffer to disk and use `--fail` to gate without piping the entire stream through a single `jq` or Python process.

## References

- TruffleHog CLI man page and flag reference — `trufflesecurity/trufflehog` on GitHub
- GitHub Code Scanning SARIF support — `docs.github.com/en/code-security/code-scanning`
- SARIF 2.1.0 specification — `oasis-open.github.io/sarif-spec`
- TruffleHog v3 output system source — `github.com/trufflesecurity/trufflehog/tree/main/pkg/output`
- SARIF output feature request and discussion — `github.com/trufflesecurity/trufflehog/issues/578`
