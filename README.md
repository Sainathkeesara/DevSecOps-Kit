# DevSecOps-Kit

> A working engineer's DevSecOps reference — notes, snippets, configs, and scripts across the tools used to ship secure software.

## Who this is for

A working DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools on disk. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope spans the DevSecOps toolchain present on disk: secret scanners (gitleaks, trufflehog, gitguardian), vulnerability scanners (trivy, grype, snyk, tfsec, terrascan, semgrep, sonarqube, nuclei, zap), supply-chain (syft, grype), IaC (terraform, opentofu, kustomize, helm, kubernetes, opa), CI/CD (github-actions, jenkins), observability (prometheus, grafana), and supporting scripts and templates.

## Layout

- `00_index/` — topics map, quick links, glossary, learning path.
- `<tool>/` — per-tool notes, docs, scripts, configs, snippets, manifests, templates.
- `scripts/` — cross-cutting shell helpers.
- `templates/` — reusable project scaffolds.
- `snippets/` — cheatsheets and command references.

## Coverage

See [00_index/topics.md](00_index/topics.md) for the full map.

---
_Last updated: 2026-10-21_
