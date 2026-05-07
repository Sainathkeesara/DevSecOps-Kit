# Quick Links

## Getting Started
- [README](../README.md) — Repository overview and purpose
- [CHANGELOG](../CHANGELOG.md) — Version history and updates

## I need to...

### Fix a Kubernetes issue
- [CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md) — CrashLoopBackOff diagnosis and fix
- [Drain a node](../scripts/bash/k8s_toolkit/node/drain-node.sh) — Safely drain a node before maintenance
- [Cluster-autoscaler CVE](../docs/troubleshooting/k8s-cluster-autoscaler-cve-2026-33186.md) — CVE-2026-33186 hardening
- [MCP server CVE](../docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md) — CVE-2026-39884 remediation
- [External Secrets CVE](../docs/how-to/k8s-external-secrets-cve-2026-34984.md) — CVE-2026-34984 DNS exfiltration fix
- [Ingress-nginx CVE](../docs/how-to/k8s-ingress-nginx-cve-2026-4342.md) — CVE-2026-4342 RCE remediation
- [AKS privilege escalation](../docs/how-to/k8s-aks-cve-2026-33105.md) — CVE-2026-33105 hardening
- [ACM privilege escalation](../scripts/bash/k8s/security/k8s-acm-cve-2026-4740.sh) — Kubernetes ACM CVE scanner

### Harden Docker
- [Docker security best practices](../docs/how-to/docker-security-best-practices.md) — Comprehensive Docker hardening guide
- [AuthZ plugin hardening](../docs/security/docker/AUTHZ-PLUGIN-HARDENING.md) — Prevent privileged container operations
- [CVE-2026-34040 remediation](../docs/security/docker/CVE-2026-34040.md) — Authorization plugin bypass fix
- [CVE-2026-28406 kaniko hardening](../docs/how-to/docker-kaniko-cve-2026-28406.md) — Kaniko path traversal fix
- [CVE-2026-2664 hardening](../scripts/bash/docker_toolkit/security/cve-2026-2664.sh) — Docker Desktop grpcfuse scanner
- [CVE-2026-28400 hardening](../scripts/bash/docker_toolkit/security/cve-2026-28400.sh) — Model Runner privilege escalation scanner
- [Docker Swarm cluster setup](../docs/how-to/docker-swarm-cluster-installation.md) — High-availability Swarm installation

### Harden Kafka
- [Kafka cluster setup](../docs/setup-guides/kafka-cluster-setup.md) — Single-broker local setup
- [Consumer lag troubleshooting](../docs/troubleshooting/kafka-consumer-lag.md) — Lag and rebalancing issues
- [CVE-2025-27818 hardening](../scripts/bash/kafka_toolkit/security/cve-2025-27818.sh) — Kafka Connect SASL JAAS RCE scanner
- [CVE-2025-27817 hardening](../scripts/bash/kafka_toolkit/security/cve-2025-27817.sh) — Kafka Client SSRF scanner

### Set up Kubernetes
- [EKS cluster setup](../docs/setup-guides/eks-cluster-setup.md) — Complete EKS provisioning on AWS
- [K8s toolkit usage](../docs/how-to/k8s_toolkit.md) — All k8s scripts documentation
- [RBAC guide](../docs/how-to/k8s_rbac.md) — Role, ClusterRole, RoleBinding examples
- [Production deployment template](../templates/k8s/production-deployment.yaml) — Deployment with HPA and PDB
- [Deploy production app](../templates/k8s/deploy-prod-app.sh) — Production deployment generator

### Harden Ansible
- [Ansible toolkit](../docs/how-to/ansible_toolkit.md) — Security audit scripts
- [Playbook best practices](../docs/how-to/ansible-playbook-best-practices.md) — Production playbook guidelines
- [CVE-2026-33228 hardening](../docs/how-to/ansible-cve-2026-33228-flatted.md) — Flatted prototype pollution fix
- [CVE-2025-14010 audit](../scripts/bash/ansible_toolkit/security/cve-2025-14010-audit.sh) — Sensitive variable exposure scanner
- [CVE-2026-0598 audit](../scripts/bash/ansible_toolkit/security/cve-2026-0598-audit.sh) — Lightspeed auth bypass scanner
- [CVE-2026-24049 hardening](../scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh) — Wheel privilege escalation scanner
- [CVE-2026-0598 hardening](../scripts/bash/ansible_toolkit/security/aap-cve-2026-0598-check.sh) — AAP Lightspeed auth bypass scanner

### Harden Vault
- [Vault toolkit](../docs/how-to/vault_toolkit.md) — Security hardening scripts
- [Secure deployment guide](../docs/how-to/vault-secure-deployment.md) — Production hardening best practices
- [Seal/unseal troubleshooting](../docs/how-to/vault-troubleshooting-seal-unseal.md) — Seal failure recovery
- [CVE-2025-11621 hardening](../scripts/bash/vault_toolkit/security/cve-2025-11621.sh) — AWS Auth bypass scanner
- [CVE-2025-5999 hardening](../scripts/bash/vault_toolkit/security/cve-2025-5999.sh) — Privilege escalation scanner
- [CVE-2025-6000 hardening](../scripts/bash/vault_toolkit/security/cve-2025-6000.sh) — Plugin directory RCE scanner
- [CVE-2025-6037 hardening](../scripts/bash/vault_toolkit/security/cve-2025-6037.sh) — TLS cert auth bypass scanner
- [CVE-2025-6013 hardening](../scripts/bash/vault_toolkit/security/cve-2025-6013.sh) — LDAP MFA enforcement bypass scanner
- [Audit log analysis](../scripts/bash/vault/vault-audit-log-analysis.sh) — Security event analysis

### Set up Terraform
- [Terraform workflow](../scripts/bash/terraform_toolkit/terraform-workflow.sh) — init/plan/apply with dry-run
- [EKS deployment](../scripts/bash/terraform_toolkit/eks/eks-deploy.sh) — Automated EKS cluster deployment
- [Multi-environment GitOps](../docs/how-to/terraform-multi-env-gitops.md) — Workspace isolation workflow
- [Terraform module composition](../docs/how-to/terraform-module-composition-workspaces.md) — Reusable modules guide
- [Atlantis setup](../scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh) — Automated Atlantis installation
- [RDS with read replicas](../docs/how-to/terraform-rds-read-replicas.md) — Production RDS deployment
- [RDS deploy script](../scripts/bash/terraform_toolkit/rds-deploy.sh) — RDS automation (plan/apply/destroy)
- [State management](../docs/how-to/terraform-state-management.md) — Backends, locking, encryption
- [Terraform troubleshooting](../docs/how-to/terraform-troubleshooting.md) — Plan/apply failures guide

### Work with Linux
- [Linux toolkit](../docs/how-to/linux_toolkit.md) — System administration scripts
- [System administration runbook](../docs/runbooks/linux-system-administration.md) — Complete sysadmin guide (L7)
- [System hardening](../docs/how-to/linux/linux-system-hardening-containerized.md) — CIS benchmark automation (L7)
- [Container orchestration](../docs/how-to/linux/linux-container-orchestration-systemd-cgroups.md) — Systemd + cgroups (L7)
- [Incident response](../docs/how-to/linux-incident-response-automation.md) — Forensic evidence collection
- [Wazuh SIEM](../docs/how-to/linux/linux-wazuh-siem.md) — Wazuh server and agent deployment
- [Prometheus monitoring](../docs/how-to/linux-monitoring-prometheus.md) — node_exporter + Grafana
- [OpenSCAP hardening](../docs/how-to/linux-openscap-hardening.md) — STIG/CIS compliance automation
- [AIDE file integrity](../docs/how-to/linux-aide-configuration.md) — AIDE setup and usage
- [Container security scanning](../docs/how-to/linux-container-security-scanning.md) — Trivy and Falco integration
- [Centralized logging](../docs/how-to/linux-centralized-logging-syslog-ng-logstash.md) — Syslog-ng + Logstash + ES
- [Samba file sharing](../docs/how-to/linux-samba-file-sharing.md) — Cross-platform file server
- [HAProxy load balancer](../docs/how-to/linux-haproxy-load-balancer.md) — L4/L7 load balancer with SSL
- [WireGuard VPN](../docs/how-to/linux-vpn-wireguard.md) — VPN server setup
- [BIND9 DNS](../docs/how-to/linux-dns-bind9.md) — DNS server setup
- [PostgreSQL database](../lab/mini-projects/postgresql-database-server/README.md) — PostgreSQL 16 with replication (L7)
- [Samba enterprise](../lab/mini-projects/samba-enterprise-file-sharing/README.md) — Enterprise file sharing (L7)

### Harden Jenkins
- [Jenkins CLI reference](../snippets/jenkins-cli-commands.md) — 150+ CLI commands
- [Jenkins commands reference](../snippets/jenkins-commands-reference.md) — 100+ commands for job/build/node management
- [Scripted pipeline Groovy](../snippets/jenkins-scripted-pipeline-groovy.md) — 50+ Groovy snippets
- [Jenkins troubleshooting](../docs/troubleshooting/jenkins-troubleshooting.md) — Startup, plugin, build failures
- [CVE-2026-27099 hardening](../scripts/bash/jenkins_toolkit/security/cve-2026-27099.sh) — XSS/DoS vulnerability scanner

### Secure CI/CD pipelines
- [CI/CD toolkit](../docs/how-to/ci_cd_toolkit.md) — Workflow linting, health checks, action updates
- [Pre-commit security scanning](../docs/how-to/git-pre-commit-security-scanning.md) — Secrets, vulnerabilities, code quality
- [Trivy CVE-2026-33634 remediation](../docs/security/trivy/CVE-2026-33634.md) — Supply chain compromise fix
- [Trivy CVE-2026-33634 scanner](../scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh) — Trivy vulnerability detection

### Work with Helm
- [Helm commands reference](../docs/how-to/helm-commands-reference.md) — 80+ Helm CLI examples
- [Helm security scanning](../docs/how-to/helm-security-scanning.md) — Trivy, kube-score, Checkov, Kubescape
- [Helm + Terraform full-stack](../docs/how-to/helm-terraform-fullstack/README.md) — EKS provisioning + Helm deployment
- [CVE-2025-53547 hardening](../scripts/bash/helm_toolkit/security/cve-2025-53547-harden.sh) — Chart.yaml code injection scanner

### Manage Observability
- [Observability toolkit](../docs/how-to/observability_toolkit.md) — Prometheus, Loki, Grafana, Jaeger, OTel
- [Prometheus target status](../scripts/bash/observability_toolkit/prometheus/targets-status.sh) — Check targets health
- [Prometheus query metrics](../scripts/bash/observability_toolkit/prometheus/query-metrics.sh) — Execute PromQL queries
- [Loki query logs](../scripts/bash/observability_toolkit/loki/query-logs.sh) — Query logs with LogQL
- [Stack health check](../scripts/bash/observability_toolkit/stack-health.sh) — Full stack verification

### Manage container registries
- [OCI registry toolkit](../docs/how-to/oci_registry_toolkit.md) — List repos/tags, find old tags, auth diagnostics
- [Harbor registry setup](../docs/how-to/linux-harbor-registry.md) — Production Harbor deployment with TLS/LDAP

### Work with Git
- [Git commands reference](../snippets/git-commands.md) — 80+ CLI commands
- [Git installation (Linux)](../docs/how-to/git-installation.md) — Automated Ubuntu/Debian, RHEL/Alma install
- [Git installation (macOS)](../docs/how-to/git-installation-macos.md) — Homebrew installation
- [Git installation (WSL)](../docs/how-to/git-installation-wsl.md) — WSL setup with PPA
- [GitHub Actions runner](../docs/setup-guides/git-github-actions-runner.md) — Self-hosted runner installation
- [Git credential helper](../docs/setup-guides/git-credential-helper-ci-cd.md) — CI/CD credential configuration
- [Git version control mental model](../docs/concepts/git-version-control-mental-model.md) — Architecture and branching model
- [Git automation](../scripts/bash/git/git-automation.sh) — CI/CD integration scripts
- [Pre-commit hooks](../scripts/bash/git/git-pre-commit-hooks.sh) — Secrets and vulnerability scanning hooks
