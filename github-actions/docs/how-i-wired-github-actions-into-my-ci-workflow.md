---
last_verified: 2026-10-20
tool_version: n/a
sources:
  - https://github.com/Lowkh/Practice_DevSecOps_2026_SCA_SAST_DAST/blob/main/README.md
  - https://www.globaltechcouncil.org/cyber-security/ssdlc-integrating-sast-dast-sca-into-devsecops
---

# How I wired GitHub Actions into my CI workflow

## Purpose

This is the CI setup I landed on for a Python service: one job that installs dependencies and runs the tests, a second job that runs static analysis, and a permissions block that stops the workflow token from doing more than each job needs. It is one arrangement and not the only one — the shape carries over to another language by swapping the setup step, and a monorepo would probably want one workflow per service instead of one workflow with more jobs.

## Prerequisites

- A repository with a `.github/workflows/` directory. The workflow file has to live there; in my first attempt I put it at the repo root and nothing ran at all, with no error in the Actions tab to explain why.
- A dependency file for the project — `requirements.txt` for the service I used.
- The `gh` CLI locally, so I can start a run and watch it without leaving the terminal.

## The workflow I ended up with

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run tests
        run: pytest

  sast:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - name: Init CodeQL
        uses: github/codeql-action/init@v4
        with:
          languages: python
      - name: Analyse
        uses: github/codeql-action/analyze@v4
```

## What I did, in order

1. **Started with the smallest thing that runs.** One job, one checkout step, one `run:` step. I did not split anything until I had a green run I trusted, because until then a failure told me nothing about which part was wrong.
2. **Split by outcome, not by step.** The build job gates the merge; the static-analysis job reports findings. Keeping them as separate jobs means a red test run does not hide the scan output, and either one can be re-run on its own.
3. **Put the scan on the pull request.** The layering I was aiming for is the shift-left one: the checks that need no deployed application run on the pull request so the feedback arrives while the change is still being written, and the checks that need a running service happen later, after a deployment.
4. **Scoped the token.** The workflow-level `permissions: contents: read` applies to every job. Only the scan job asks for more, because `security-events: write` is the one extra scope it actually needs to record results.
5. **Triggered and watched from the CLI.** `workflow_dispatch:` in the trigger block means I can start a run on demand, and I do it by workflow file name — `gh workflow run ci.yml --ref main`, where `ci.yml` is the name of the workflow file in the repo. `gh run list` shows the recent history and `gh run watch` follows the latest run to the end. That loop let me iterate without pushing empty commits.
6. **Kept the workflow in the repository.** The file lives next to the code, so a change to the pipeline goes through the same review as a change to the service.

## Verify

- A push to the branch named in the `push:` trigger produces a run with both a `build` and a `sast` job, listed separately on that run.
- The analysis step in the `sast` job completes rather than failing on permissions.
- A pull request from a branch that is not in the `push:` trigger still produces a run, because `pull_request:` has no branch filter.
- The `build` job's steps run with a token that can read the repository but not write to it — that comes from the workflow-level `permissions: contents: read`, and the `sast` job's own block is the only place a wider scope appears.

## Where I got it wrong

- **The workflow file sat at the repo root.** No runs appeared and no error was shown. Moving the file under `.github/workflows/` fixed it, but the silence is what I remember.
- **The scan job failed with "Resource not accessible by integration".** The job's token had read access only, and the analysis step was trying to write results. Adding `security-events: write` to that job's `permissions:` block was the fix; the workflow-level default was not enough for it.
- **A result name drifted between jobs.** When I had a later step read a scan result that an earlier job had produced, I named it `sast-results` in one place and `sast_results` in the other, and the step never found the file — the names have to match exactly. I dropped that hand-off afterwards and kept the analysis step inside the scan job, which is why the workflow above has no result names in it.

## References

- [`../configs/2026-09-10-minimal-ci-workflow.yaml`](../configs/2026-09-10-minimal-ci-workflow.yaml) — the minimal CI workflow this doc grew out of.
- [`../manifests/2026-08-04-pr-validation.yml`](../manifests/2026-08-04-pr-validation.yml) — the PR validation workflow, which splits lint and type check into separate jobs the same way.
- [`../snippets/2026-10-14-trigger-first-workflow-gh.sh`](../snippets/2026-10-14-trigger-first-workflow-gh.sh) — the `gh workflow run` snippet for kicking a workflow off by name.
- [`../notes/2026-09-21-quickstart-tripped-me-up.md`](../notes/2026-09-21-quickstart-tripped-me-up.md) — where I first hit the file-location and indentation snags.
- [`../notes/0000-primer-github-actions.md`](../notes/0000-primer-github-actions.md) — first-contact primer on workflows, jobs, steps, and runners.
