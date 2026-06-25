# CI/CD Pipeline Concepts — quick primer

> First-day notes on CI/CD Pipeline Concepts. What it is, why it matters, and the key ideas to know.

## What is it?

A CI/CD pipeline is an automated sequence of steps that code goes through from the moment a developer pushes a commit until it's running in production. CI (Continuous Integration) means every commit gets built and tested automatically. CD (Continuous Delivery or Deployment) means those changes can roll out automatically too.

Think of it like an assembly line for software. Instead of manually compiling, testing, and deploying (which people forget or do differently every time), the pipeline does it the same way every single run. Consistent, repeatable, auditable.

## Why does it matter for DevSecOps?

A pipeline is where security testing actually happens in practice. Without a pipeline, you're relying on developers to remember to run security scans locally — which they won't, especially under deadline pressure.

Pipelines also create a natural place to enforce gates: scans must pass before a PR merges, signatures must exist before an image deploys, policy checks must pass before a manifest applies. If you can't build a pipeline, you can't enforce DevSecOps at scale.

## Key terminology

- **CI (Continuous Integration)** — Automatically building and testing every code change. Example: GitHub Actions running `npm test` on every PR branch push.
- **CD (Continuous Delivery)** — Keeping every change in a deployable state so releases can happen on demand. The pipeline produces artifacts ready to ship, but deployment still requires a manual go-ahead.
- **CD (Continuous Deployment)** — Every change that passes the pipeline's tests and scans goes straight to production. No human in the loop.
- **Stage** — A logical phase in the pipeline (build, test, scan, deploy). Stages run sequentially and can fail independently.
- **Gate** — A condition that must pass before the pipeline proceeds. Example: "Trivy scan must not find critical CVEs" as a gate between scan and deploy.
- **Artifact** — A file produced by the pipeline that gets passed to later stages. Example: a Docker image, a compiled binary, or a SARIF report.
- **Trigger** — What starts the pipeline running. Usually a git push, but can be a schedule, a webhook, or a manual button.
- **Runner / Agent** — The machine that executes pipeline jobs. Can be GitHub-hosted, self-hosted, or ephemeral containers.

## A concrete example

Here's a minimal CI pipeline in GitHub Actions that runs tests and a security scan:

```yaml
name: CI
on: [push]
jobs:
  test-and-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test
      - uses: aquasecurity/trivy-action@master
        with:
          scan-type: fs
          scan-ref: .
          exit-code: 1
```

This pipeline triggers on every push, installs dependencies, runs unit tests, then scans the filesystem with Trivy. If any of those steps fail, the commit is flagged — the developer knows right away instead of finding out during a release.

## How this connects to what's next

Nearly every tool in the DevSecOps stack integrates with a CI/CD pipeline. Semgrep, Trivy, Checkov, Grype, ZAP — they all publish GitHub Actions, GitLab CI templates, or Docker images designed to run in a pipeline stage. Understanding stage ordering and gating is what lets me decide where each scan belongs.
