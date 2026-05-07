# DevOps-Kit

## What is this?

A curated collection of production-ready scripts, runbooks, and reference docs for common DevOps tools. Each entry is version-specific, scenario-grounded, and ready to adapt for real infrastructure work.

## Repository Structure

```
DevOps-Kit/
├─ 00_index/        → Navigation: topic index, quick links, glossary
├─ docs/
│  ├─ how-to/       → Step-by-step guides per tool
│  ├─ troubleshooting/ → Failure patterns and fixes
│  ├─ runbooks/     → Incident response procedures
│  └─ reference/    → Quick-reference tables and flags
├─ scripts/
│  ├─ bash/         → Shell scripts, organized by tool
│  └─ python/       → Python utilities
├─ snippets/        → Copy-paste ready one-liners and blocks
└─ templates/       → Starter configs for k8s, Terraform, Docker, etc.
```

## How to use this repo

1. **Find what you need**: Start with `00_index/quick-links.md` for the most useful resources
2. **Explore by tool**: Each tool has its own `toolkit/` directory with scripts, docs, and how-to guides
3. **Learn concepts**: Check `docs/concepts/` for deep dives into technologies
4. **Fix issues**: Look in `docs/troubleshooting/` for common problems and solutions

## Tools covered

| Tool | Scripts | Docs | Snippets | Templates |
|------|---------|------|----------|-----------|
| Kubernetes | 18 | 12 | 1 | 3 |
| Linux | 51 | 37 | 2 | 14 |
| Kafka | 17 | 3 | 2 | 0 |
| Terraform | 13 | 16 | 1 | 12 |
| Ansible | 8 | 6 | 1 | 0 |
| Vault | 7 | 4 | 1 | 0 |
| Observability | 8 | 1 | 1 | 0 |
| Docker | 8 | 6 | 1 | 0 |
| Helm | 3 | 3 | 0 | 0 |
| Jenkins | 2 | 6 | 4 | 1 |
| OCI/Registry | 5 | 2 | 1 | 0 |
| CI/CD | 6 | 2 | 1 | 0 |

## Quick links

- [Trivy CVE-2026-33634 hardening](docs/security/trivy/CVE-2026-33634.md) — Trivy supply chain compromise scanner and remediation guide (2026-05-06)
- [Trivy supply chain scanner](scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh) — CVE-2026-33634 detection with --check, --fix, --dry-run flags (2026-05-06)
- [Ansible CVE-2026-33228 hardening](scripts/bash/ansible_toolkit/security/harden-ansible-cve-2026-33228.sh) — Flatted prototype pollution vulnerability scanner (2026-05-05)
- [Git pre-commit security scanning](docs/how-to/git-pre-commit-security-scanning.md) — Pre-commit hooks for secrets, vulnerabilities, code quality (2026-05-05)
- [Docker Swarm cluster setup](docs/how-to/docker-swarm-cluster-installation.md) — High-availability Docker Swarm installation guide (2026-05-04)

## Contributing

All changes go through PR review. Scripts must include dry-run modes and safety guardrails. Documentation should follow the existing how-to and troubleshooting patterns.
