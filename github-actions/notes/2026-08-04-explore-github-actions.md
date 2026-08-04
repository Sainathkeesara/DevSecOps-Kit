---
last_verified: 2026-08-04
tool_version: n/a
---

# Exploring GitHub Actions — workflows, runners, events, marketplace

I spent some time poking around GitHub Actions to understand the moving parts.

## Workflows

A workflow is a YAML file in `.github/workflows/`. Each workflow has a trigger (the `on:` key) and one or more jobs. I started with the simplest one — a workflow that runs `echo` on every push to main.

## Runners

The default runner is `ubuntu-latest` — a VM that GitHub hosts. Jobs run fresh each time. There are also `windows-latest` and `macos-latest` runners, plus self-hosted ones you manage yourself.

## Events

The `on:` field controls when a workflow fires. I tried `push`, `pull_request`, and `workflow_dispatch` (manual trigger from the UI). `workflow_dispatch` was handy for testing without pushing code.

## Marketplace

The Actions Marketplace has pre-built actions you can reference with `uses:`. Things like `actions/checkout@v4` to clone the repo and `actions/setup-python@v5` to install Python. I prefer pinning to a major version tag rather than `@main` — less chance of surprise breakage.