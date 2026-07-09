---
last_verified: 2026-07-09
tool_version: n/a
---

# GitHub Actions — quick primer

> First-day notes for someone who's never used GitHub Actions. Personal voice, plain language.

## What is it?

GitHub Actions is GitHub's built-in CI/CD system. You write a YAML file, commit it, and GitHub runs it when events happen. I've used Jenkins before, but Actions is simpler — nothing to install or host.

## What does it do?

You define workflows in `.github/workflows/*.yml`. Each workflow triggers on `push`, `pull_request`, or a schedule. Jobs run on GitHub-hosted or self-hosted runners, and each job has steps that run commands or use pre-built actions from the marketplace.

## Why does it exist?

Before Actions, adding CI/CD to a GitHub repo meant wiring up a third-party service. Actions keeps everything in one place — your pipeline config lives alongside code, no external accounts needed.

## Key terminology

- **Workflow** — the YAML file defining automation. Example: `.github/workflows/ci.yml`.
- **Job** — a group of steps sharing a runner. Example: a "lint" job and a "test" job.
- **Step** — a single task inside a job. Example: `run: npm test`.
- **Runner** — the VM running jobs. Example: `ubuntu-latest`.
- **Event** — the workflow trigger. Example: `push`.
- **Action** — reusable unit from the marketplace. Example: `actions/checkout@v4`.

## A tiny example

```yaml
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Workflow triggered!"
```

## What I'll cover next

I want to learn matrix builds for testing across Node versions and how to add deployment steps.
