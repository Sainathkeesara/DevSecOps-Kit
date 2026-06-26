# Multi-project Snyk CI pipeline with per-service monitoring

This guide covers wiring Snyk into a multi-project CI pipeline where each service maintains its own monitoring scope in the Snyk dashboard.

## Purpose

In a repository with multiple services or packages, a single `snyk test` run produces a flat list of findings that's hard to triage by team. This setup creates distinct Snyk projects for each service directory so that the Snyk web UI shows separate monitors, separate issue histories, and separate severity trends.

## Prerequisites

- A Snyk account with API access (`SNYK_TOKEN`).
- The repository organized into service directories, e.g. `services/api/`, `services/worker/`.
- CI system that supports matrix builds or dynamic job generation (GitHub Actions, GitLab CI, etc.).

## Steps

### 1. Map directories to Snyk project names

Decide on a naming convention so each service gets a predictable project identifier. A common pattern is `<repo-name>/<service-dir>`:

```yaml
services:
  - path: services/api
    project: my-org/api-service
  - path: services/worker
    project: my-org/worker-service
  - path: packages/shared-lib
    project: my-org/shared-lib
```

### 2. Create a reusable matrix workflow

Instead of one job that scans everything, use a matrix that iterates over the service list. Each matrix member runs `snyk monitor` scoped to its own directory and tags the result with a service name.

```yaml
name: Snyk per-service scan
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  snyk-scan:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service:
          - path: services/api
            project: my-org/api-service
          - path: services/worker
            project: my-org/worker-service
    steps:
      - uses: actions/checkout@v4

      - name: Install Snyk CLI
        run: |
          curl -sL https://static.snyk.io/cli/latest/snyk-linux -o snyk
          chmod +x snyk
          sudo mv snyk /usr/local/bin/

      - name: Run Snyk test and monitor
        working-directory: ${{ matrix.service.path }}
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        run: |
          snyk test --all-projects --fail-on=high --json
          snyk monitor --project-name=${{ matrix.service.project }}
```

### 3. Set org-level tags (optional)

If the Snyk org supports project tags, you can add them via the API to group services by team or environment. Run this after the first monitor push:

```bash
curl -X POST \
  "https://snyk.io/api/v1/org/<org-id>/projects/<project-id>/tags" \
  -H "Authorization: token $SNYK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"key": "team", "value": "platform"}'
```

### 4. Enforce per-service failure rules

Some services may tolerate medium-severity issues during early development. Override thresholds per service by passing `--severity-threshold=high` on a case-by-case basis, or maintain separate `snyk` config files inside each service directory.

## Verify

After merging:

1. Open the Snyk dashboard and confirm each `project` appears under the correct org.
2. Trigger a test push and verify that each matrix job reports its own findings in the CI log.
3. In the Snyk UI, check that every project shows a green "last tested" timestamp and the expected issue count.
4. Intentionally introduce a known vulnerable dependency in one service and confirm only that service's monitor flags it.

## Common errors

- **`snyk monitor` creates duplicates instead of updating** — Snyk identifies projects by path and org. If you rename the `--project-name` without deleting the old project, you'll get a new monitor. Delete the stale project from the dashboard or use the Snyk API to merge them.
- **Matrix job runs from repo root** — The `working-directory` input in GitHub Actions must match the service path exactly; otherwise `snyk test` sees the whole monorepo and reports everything.
- **Org mismatch** — Ensure `SNYK_TOKEN` belongs to the org that owns the projects. Tokens scoped to a different org silently create projects there instead of the expected location.
