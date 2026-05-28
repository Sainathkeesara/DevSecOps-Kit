# How I wired Semgrep into a GitHub Actions CI pipeline from scratch

> Purpose: Build a reusable Semgrep scanning pipeline in GitHub Actions that catches security issues before they ship — without relying on the official `semgrep-action` wrapper, so I understand every moving part.

## Purpose

This walks through creating a GitHub Actions workflow that runs Semgrep on every push and pull request, outputs SARIF for GitHub Code Scanning alerts, and includes custom rules. The official action (`semgrep/semgrep-action@v1`) abstracts away the CLI details, but setting it up from scratch makes it easier to debug when things break and customize when the defaults don't fit.

## Steps

### 1. Create the workflow file

`.github/workflows/semgrep-ci.yml`:

```yaml
name: Semgrep CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  semgrep-scan:
    runs-on: ubuntu-latest
    container:
      image: semgrep/semgrep:latest

    steps:
      - uses: actions/checkout@v4

      - name: Run Semgrep with community rules
        run: |
          semgrep \
            --config=auto \
            --error \
            --sarif \
            --output=semgrep.sarif \
            --severity=WARNING \
            .
        env:
          SEMGREP_APP_TOKEN: ""

      - name: Upload SARIF to GitHub Code Scanning
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
          category: semgrep
```

Key choices:
- **Container image** instead of the action — gives direct control over the Semgrep version and CLI flags.
- **`--error`** — exits non-zero if any findings are found, which blocks the pipeline.
- **`--sarif`** — produces SARIF output that GitHub can render in the Security tab.
- **`SEMGREP_APP_TOKEN` left empty** — community rules don't need a token. The env var just suppresses the "no token configured" warning.

### 2. Add a `.semgrepignore` file

Without this, Semgrep scans `node_modules/`, `vendor/`, and minified files — most of which aren't your code. Place at the repo root:

```
# File: .semgignore
# Ignore vendored and generated code
node_modules/
vendor/
*.min.js
*.min.css
build/
dist/
__pycache__/
*.pyc
```

I initially forgot this and got 47 findings from a React project — 43 were from minified vendor bundles. Took me a minute to realize `--exclude` on the CLI doesn't compose well with `--config=auto`.

### 3. Add custom rules alongside community rules

The community registry misses repo-specific patterns. I mounted a rules directory via the container:

```yaml
      - name: Run custom rules
        run: |
          semgrep \
            --config=semgrep/rules/ \
            --error \
            --sarif \
            --output=semgrep-custom.sarif \
            .

      - name: Upload custom SARIF
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep-custom.sarif
          category: semgrep-custom
```

This runs a **separate scan** because `--config` doesn't merge multiple entries in all Semgrep versions (one config at a time, run multiple scans). The second SARIF upload keeps them distinct in Code Scanning, which I actually prefer — I can tell at a glance whether a finding came from community rules or my own.

### 4. Cache the registry between runs

The biggest friction point: `semgrep --config=auto` downloads thousands of rules on every run. First scan takes 3–4 minutes. Subsequent scans with caching drop to ~30 seconds.

```yaml
      - name: Restore Semgrep cache
        uses: actions/cache@v4
        with:
          path: ~/.semgrep
          key: semgrep-${{ runner.os }}-${{ hashFiles('.semgrepignore') }}

      - name: Run Semgrep
        run: |
          semgrep --config=auto --error --sarif --output=semgrep.sarif .
```

`hashFiles('.semgrepignore')` invalidates the cache only when the ignore patterns change — not on every commit. Worked well in practice.

## Verify

1. Push the workflow file to a branch on GitHub.
2. Create a PR against `main`. The workflow should trigger automatically.
3. Check **Actions** tab — the `semgrep-scan` job should complete.
4. Check **Security → Code scanning** — SARIF results should appear under "Semgrep" and "Semgrep Custom" categories.
5. Verify gating: introduce a known-bad pattern (e.g., `subprocess.Popen("rm -rf /", shell=True)`) and confirm the workflow exits non-zero.

I hit this sequence: first run, the SARIF upload succeeded but nothing showed up in Code Scanning. Turns out the upload action requires the `GITHUB_TOKEN` to have `security_events: write` permission. Adding it explicitly fixed it:

```yaml
    permissions:
      contents: read
      security-events: write
```
