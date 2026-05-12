# DevOps-Kit

## What is this?

A curated collection of production-ready scripts, runbooks, and reference docs for common DevOps tools. Each entry is version-specific, scenario-grounded, and ready to adapt for real infrastructure work.

## Repository Structure

```
DevOps-Kit/
├─ 00_index/        → Navigation: topic index, quick links, glossary
├─ .github/         → GitHub Actions workflows and configurations
├─ assets/           → Static assets (diagrams, images)
├─ docs/
│  ├─ concepts/     → Deep dives into technologies and concepts
│  ├─ how-to/       → Step-by-step guides per tool
│  ├─ reference/   → Quick-reference tables and flags
│  ├─ runbooks/     → Incident response procedures
│  ├─ security/     → Security hardening guides and CVE documentation
│  ├─ setup-guides/ → Installation and configuration guides
│  └─ troubleshooting/ → Failure patterns and fixes
├─ environments/    → Environment configurations (dev, staging, prod)
├─ lab/             → Learning labs and mini-projects
├─ scripts/
│  ├─ bash/         → Shell scripts, organized by tool
│  ├─ examples/     → Example scripts and templates
│  ├─ lib/          → Reusable script libraries
│  ├─ powershell/   → PowerShell utilities
│  └─ python/       → Python utilities
├─ snippets/        → Copy-paste ready one-liners and blocks
├─ templates/       → Starter configs for k8s, Terraform, Docker, etc.
└─ terraform/       → Terraform modules and examples
```

## How to use this repo

1. **Find what you need**: Start with `00_index/quick-links.md` for the most useful resources
2. **Explore by tool**: Each tool has its own `toolkit/` directory with scripts, docs, and how-to guides
3. **Learn concepts**: Check `docs/concepts/` for deep dives into technologies
4. **Fix issues**: Look in `docs/troubleshooting/` for common problems and solutions

## Tools covered

| Tool | Scripts | Docs | Snippets | Templates |
|------|--------:|-----:|---------:|----------:|
| Kubernetes | 18 | 17 | 1 | 3 |
| Linux | 39 | 38 | 2 | 1 |
| Kafka | 17 | 3 | 2 | 0 |
| Terraform | 12 | 16 | 1 | 6 |
| Ansible | 8 | 6 | 1 | 0 |
| Vault | 7 | 4 | 1 | 0 |
| Observability | 8 | 5 | 1 | 0 |
| Docker | 8 | 7 | 1 | 0 |
| CI/CD | 12 | 7 | 1 | 0 |
| OCI/Registry | 5 | 3 | 1 | 0 |
| Helm | 3 | 3 | 0 | 0 |
| Jenkins | 2 | 11 | 4 | 1 |

## Quick links

- [Alertmanager HA Clustering](docs/how-to/observability/alertmanager-ha-clustering.md) — Alertmanager high-availability clustering for alert deduplication (2026-05-11)
- [Loki Promtail Installation](docs/how-to/observability/loki-promtail-installation.md) — Grafana Loki Promtail installation and log pipeline configuration (2026-05-11)
- [Azure Container Registry ACR](docs/how-to/azure-container-registry-acr.md) — Azure Container Registry ACR installation and geo-replication (2026-05-11)
- [GitHub Container Registry ghcr.io](docs/how-to/oci-registry-toolkit/github-container-registry-ghcr.md) — GitHub Container Registry ghcr.io configuration (2026-05-11)
- [Buildkite Installation](docs/how-to/buildkite-installation.md) — Buildkite agent installation and configuration for CI/CD pipelines (2026-05-11)

## Contributing

All changes go through PR review. Scripts must include dry-run modes and safety guardrails. Documentation should follow the existing how-to and troubleshooting patterns.