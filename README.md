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
| Linux | 36 | 31 | 2 | 0 |
| Kafka | 17 | 3 | 2 | 0 |
| Terraform | 13 | 17 | 1 | 14 |
| Ansible | 8 | 4 | 1 | 0 |
| Vault | 7 | 4 | 1 | 0 |
| Observability | 8 | 1 | 1 | 0 |
| Docker | 5 | 3 | 1 | 0 |
| Helm | 3 | 2 | 0 | 0 |
| Jenkins | 2 | 6 | 4 | 1 |
| OCI/Registry | 5 | 1 | 1 | 0 |
| CI/CD | 5 | 1 | 1 | 0 |

## Quick links

- [Git version control fundamentals](docs/concepts/git-001-version-control-fundamentals.md) — Git concepts (L1) (2026-04-29)
- [Git basic commands and setup](docs/concepts/git-002-basic-commands-setup.md) — Git commands (L1) (2026-04-29)
- [Jenkins CLI commands reference](snippets/jenkins-cli-commands.md) — Jenkins CLI with 150+ commands (2026-04-28)
- [CoreDNS and systemd-resolved DNS management](docs/how-to/linux-dns-management-coredns-systemd-resolved.md) — Complete DNS management guide (2026-04-27)
- [AKS privilege escalation hardening](scripts/bash/kubernetes/aks-privilege-escalation-hardening.sh) — CVE-2026-33105 hardening script (2026-04-23)

## Contributing

All changes go through PR review. Scripts must include dry-run modes and safety guardrails. Documentation should follow the existing how-to and troubleshooting patterns.
