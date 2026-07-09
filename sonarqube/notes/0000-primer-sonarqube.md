---
last_verified: 2026-07-09
tool_version: n/a
---

# SonarQube — quick primer

> First-day notes for someone who's never used SonarQube. Personal voice, plain language.

## What is it?

SonarQube is a static analysis platform that inspects code for bugs, code smells, and security issues. I've used linters like ESLint, but SonarQube tracks quality across an entire project over time — duplicated code, low test coverage, complex functions.

## What does it do?

Run a scanner against your code (CLI, Maven plugin, or GitHub Action). It sends results to a SonarQube server that shows a web dashboard. Each analysis gets a Quality Gate status — pass or fail — that you can enforce in CI.

## Why does it exist?

Code review without automation is manual and inconsistent. SonarQube enforces a baseline: if a PR introduces a bug or drops coverage, CI blocks the merge. It also surfaces technical debt that quietly grows — long functions, repeated blocks, unhandled exceptions.

## Key terminology

- **Quality Gate** — pass/fail conditions like "no new bugs, coverage ≥ 80%".
- **Quality Profile** — a set of activated rules per language. Default is "Sonar way".
- **Issue** — a single bug, vulnerability, or code smell. Example: `Remove this unused parameter`.
- **Hotspot** — security-sensitive code needing human review. Example: `eval()` usage.
- **Technical Debt** — estimated hours to fix all maintainability issues.

## A tiny example

```bash
sonar-scanner \
  -Dsonar.projectKey=my-project \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_abc123
```

The dashboard shows 3 bugs, 12 code smells, and a **Failed** Quality Gate because coverage is below 50%.

## What I'll cover next

I want to set up a custom Quality Profile and integrate SonarQube into a GitHub Actions workflow so every PR gets checked.
