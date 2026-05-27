# Semgrep CI Integration

> Following the official Semgrep CI docs and wiring it into a GitHub Actions pipeline. Here's what worked and where it broke.

## Steps

I started with Semgrep's GitHub Actions action (`semgrep/semgrep-action@v1`) because it's the quickest path — no self-hosted runner, no API token needed for community rules.

Created `.github/workflows/semgrep.yml`:

```yaml
name: Semgrep
on: [push, pull_request]
jobs:
  semgrep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: semgrep/semgrep-action@v1
        with:
          config: auto
          severity: WARNING
```

The `config: auto` flag tells Semgrep to use the community rule registry. `severity: WARNING` means it'll report WARNING and above (WARNING, ERROR).

I pushed and the workflow ran. First pass flagged 12 findings in a Django app — mostly `javascript` rules firing on minified vendor files.

**Fix:** Added a `.semgrepignore` file:

```
# node_modules equivalents
*.min.js
vendor/
node_modules/
build/
dist/
```

Re-ran and got down to 4 real findings: two `subprocess` calls without `shell=False`, one hardcoded secret in a test fixture, and one SQL injection via f-string.

## Got stuck on

1. **`config: auto` is slow the first time** — the action downloads the full registry (thousands of rules). Took ~3 min for the registry download alone. Subsequent runs cache it, but first-run CI times jumped from 30s to 4min.
2. **YAML rule strictness** — I tried writing a custom `.semgrep.yml` rule inline with the `config:` field but the action doesn't merge custom rules with `auto`. You have to point `config:` at your rule file and run a separate job if you want both.
3. **SARIF output** — I wanted GitHub Code Scanning alerts. The action supports `generate-sarif: true` but you also need to upload it:

```yaml
      - uses: semgrep/semgrep-action@v1
        with:
          config: auto
          generate-sarif: true
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
```

I missed the upload step on the first try.

## What I'd try next

- Set up a scheduled weekly scan (`on: schedule`) so findings don't pile up.
- Write repo-specific rules for patterns that the community rules don't catch (Django ORM misuse, internal API auth checks).
- Try the Semgrep Cloud Platform dashboard to track findings over time instead of relying on GitHub issues.
