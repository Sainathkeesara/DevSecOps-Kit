# Quick Links

## I need to...

### Fix a Kubernetes issue
- [CrashLoopBackOff](docs/troubleshooting/k8s-crashloopbackoff.md) — CrashLoopBackOff diagnosis and fix
- [Drain a node](scripts/bash/k8s_toolkit/node/drain-node.sh) — Safely drain a node before maintenance
- [Restart a deployment](scripts/bash/k8s_toolkit/rollout-restart.sh) — Restart deployments with watch
- [Decode a secret](scripts/bash/k8s_toolkit/secret/decode-secret.sh) — Decode base64 Kubernetes secrets
- [cluster-autoscaler CVE-2026-33186](docs/troubleshooting/k8s-cluster-autoscaler-cve-2026-33186.md) — cluster-autoscaler grpc hardening
- [MCP server Kubernetes CVE-2026-39884](docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md) — MCP server RCE remediation
- [External Secrets Operator CVE-2026-34984](docs/how-to/k8s-external-secrets-cve-2026-34984.md) — ESO DNS exfiltration remediation
- [ingress-nginx CVE-2026-4342](docs/how-to/k8s-ingress-nginx-cve-2026-4342.md) — ingress-nginx RCE vulnerability remediation
- [ingress-nginx CVE-2026-3288](scripts/bash/k8s_toolkit/security/cve-2026-3288-nginx.sh) — ingress-nginx rewrite-target RCE scanner
- [AKS CVE-2026-33105](docs/how-to/k8s-aks-cve-2026-33105.md) — AKS privilege escalation remediation
- [ACM CVE-2026-4740](scripts/bash/k8s/security/k8s-acm-cve-2026-4740.sh) — Kubernetes ACM privilege escalation scanner

### Harden Kafka
- [CVE-2025-27818 hardening](scripts/bash/kafka_toolkit/security/cve-2025-27818.sh) — Kafka Connect SASL JAAS RCE scanner
- [CVE-2025-27817 hardening](scripts/bash/kafka_toolkit/security/cve-2025-27817.sh) — Kafka Client SSRF scanner

### Set up Kafka
- [Kafka cluster setup](docs/setup-guides/kafka-cluster-setup.md) — Local Kafka cluster setup
- [Consumer lag troubleshooting](docs/troubleshooting/kafka-consumer-lag.md) — Consumer lag and rebalancing issues

### Harden Docker
- [CVE-2026-34040](scripts/bash/docker_toolkit/security/docker-cve-2026-34040.sh) — Docker authorization plugin bypass scanner
- [CVE-2026-34040 guide](docs/security/docker/CVE-2026-34040.md) — Docker authorization plugin bypass remediation
- [CVE-2026-2664](scripts/bash/docker_toolkit/security/cve-2026-2664.sh) — Docker Desktop grpcfuse privilege escalation
- [CVE-2026-28400](scripts/bash/docker_toolkit/security/cve-2026-28400.sh) — Docker Model Runner privilege escalation
- [AuthZ plugin hardening](scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh) — AuthZ plugin hardening script
- [Kaniko CVE-2026-28406](docs/how-to/docker-kaniko-cve-2026-28406.md) — Kaniko path traversal remediation
- [Docker security best practices](docs/how-to/docker-security-best-practices.md) — Comprehensive security hardening guide

### Set up Docker Swarm
- [Docker Swarm cluster installation](docs/how-to/docker-swarm-cluster-installation.md) — Docker Swarm cluster setup guide
- [Docker Swarm setup script](scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh) — Automated Docker Swarm cluster setup

### Harden Ansible
- [CVE-2026-33228 hardening](scripts/bash/ansible_toolkit/security/harden-ansible-cve-2026-33228.sh) — Flatted prototype pollution scanner
- [CVE-2026-33228 execution](scripts/bash/ansible_toolkit/security/cve-2026-33228-execution.sh) — Mitigation playbook execution
- [CVE-2026-33228 guide](docs/security/ansible/CVE-2026-33228.md) — Flatted prototype pollution remediation
- [CVE-2026-33228 runbook](docs/runbooks/cve-2026-33228-ansible-flatted.md) — Comprehensive remediation runbook
- [CVE-2026-0598](scripts/bash/ansible_toolkit/security/cve-2026-0598-audit.sh) — Ansible Lightspeed auth bypass scanner
- [CVE-2026-24049](scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh) — AAP wheel privilege escalation scanner
- [CVE-2025-14010](scripts/bash/ansible_toolkit/security/cve-2025-14010-audit.sh) — Sensitive variable exposure scanner
- [CVE-2025-9907](scripts/bash/ansible_toolkit/security/cve-2025-9907-eda-creds.sh) — EDA credentials exposure scanner

### Harden Jenkins
- [CVE-2026-33001](scripts/bash/jenkins_toolkit/security/cve-2026-33001.sh) — Jenkins tar symlink path traversal scanner
- [CVE-2026-33001 guide](docs/security/jenkins/CVE-2026-33001.md) — CVE-2026-33001 remediation guide
- [CVE-2026-27099](scripts/bash/jenkins_toolkit/security/cve-2026-27099.sh) — Jenkins XSS and DoS vulnerability scanner

### Harden Vault
- [CVE-2025-6037](scripts/bash/vault_toolkit/security/cve-2025-6037.sh) — TLS certificate auth validation bypass
- [CVE-2025-6013](scripts/bash/vault_toolkit/security/cve-2025-6013.sh) — LDAP MFA enforcement bypass
- [CVE-2025-6000](scripts/bash/vault_toolkit/security/cve-2025-6000.sh) — Plugin directory RCE scanner
- [CVE-2025-5999](scripts/bash/vault_toolkit/security/cve-2025-5999.sh) — Privilege escalation scanner
- [CVE-2025-11621](scripts/bash/vault_toolkit/security/cve-2025-11621.sh) — AWS Auth bypass scanner
- [CVE-2026-4660](scripts/bash/vault/security/vault-go-getter-hardening.sh) — go-getter arbitrary file read
- [Vault seal/unseal](docs/troubleshooting/vault-seal-unseal.md) — Troubleshooting guide

### Scan with Trivy
- [CVE-2026-33634](scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh) — Trivy supply chain compromise scanner
- [CVE-2026-33634 guide](docs/security/trivy/CVE-2026-33634.md) — Trivy supply chain vulnerability remediation
- [CVE-2026-33001](scripts/bash/trivy_toolkit/security/cve-2026-33001.sh) — Trivy path traversal vulnerability scanner
- [CVE-2026-33001 guide](docs/how-to/trivy/cve-2026-33001-remediation.md) — Trivy CVE-2026-33001 remediation
- [Trivy CI/CD integration](docs/how-to/trivy-cicd-integration.md) — Trivy CI/CD pipeline integration
- [Trivy GitHub Actions](docs/how-to/trivy-github-actions.md) — Trivy GitHub Actions integration
- [Trivy Jenkins integration](docs/how-to/trivy-jenkins-integration.md) — Trivy Jenkins plugin integration
- [Trivy severity filtering](docs/how-to/trivy-severity-filtering.md) — Trivy severity-based filtering
- [Trivy cache configuration](docs/how-to/trivy-cache-configuration.md) — Trivy cache for accelerated scans

### Set up CI/CD
- [Buildkite installation](docs/how-to/buildkite-installation.md) — Buildkite agent installation and configuration
- [Buildkite install script](scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh) — Automated Buildkite agent installation
- [CircleCI runner](docs/how-to/circleci-runner-installation.md) — CircleCI runner installation
- [CircleCI runner script](scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh) — Automated CircleCI runner installation
- [Lint GitHub Actions](scripts/bash/ci_cd_toolkit/github/lint-workflows.sh) — Lint GitHub Actions workflows
- [Pipeline health](scripts/bash/ci_cd_toolkit/github/pipeline-health.sh) — Check pipeline health
- [Check action updates](scripts/bash/ci_cd_toolkit/github/check-action-updates.sh) — Check for outdated GitHub Actions
- [Trivy GitHub Actions](scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh) — Trivy GitHub Actions workflow generator

### Set up OCI Registries
- [Azure Container Registry](docs/how-to/azure-container-registry-acr.md) — ACR installation and geo-replication
- [ACR deploy script](scripts/bash/azure_toolkit/acr/acr-deploy.sh) — ACR deployment with geo-replication
- [GitHub Container Registry](docs/how-to/oci-registry-toolkit/github-container-registry-ghcr.md) — ghcr.io configuration
- [GitHub Container Registry](docs/how-to/github-container-registry-ghcr.md) — ghcr.io guide
- [Harbor registry](docs/how-to/linux-harbor-registry.md) — Production private container registry
- [Harbor deploy](scripts/bash/harbor/harbor-deploy.sh) — Automated Harbor installation
- [Harbor health](scripts/bash/harbor/harbor-health-check.sh) — Harbor health verification
- [Harbor backup](scripts/bash/harbor/harbor-backup.sh) — Harbor database and registry backup

### Set up Observability
- [OTel Collector](docs/how-to/observability/otel-collector-installation.md) — OpenTelemetry Collector installation
- [OTel Collector script](scripts/bash/observability_toolkit/otel/otel-collector-install.sh) — OTel Collector deployment
- [Loki Promtail](docs/how-to/observability/loki-promtail-installation.md) — Grafana Loki Promtail installation
- [Loki Promtail script](scripts/bash/observability_toolkit/loki/loki-promtail-install.sh) — Loki and Promtail deployment
- [Alertmanager HA](docs/how-to/observability/alertmanager-ha-clustering.md) — Alertmanager high-availability clustering
- [Alertmanager HA script](scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh) — Alertmanager HA cluster setup
- [Thanos installation](docs/how-to/thanos_installation.md) — Thanos installation for long-term metric retention
- [Prometheus targets](scripts/bash/observability_toolkit/prometheus/targets-status.sh) — Prometheus targets health
- [Query metrics](scripts/bash/observability_toolkit/prometheus/query-metrics.sh) — Execute PromQL queries
- [Query logs](scripts/bash/observability_toolkit/loki/query-logs.sh) — Query Loki logs with LogQL
- [Grafana health](scripts/bash/observability_toolkit/grafana/health-check.sh) — Grafana health check
- [Jaeger traces](scripts/bash/observability_toolkit/jaeger/query-traces.sh) — Query Jaeger traces
- [Stack health](scripts/bash/observability_toolkit/stack-health.sh) — Full observability stack health check

### Harden Helm
- [CVE-2025-53547](scripts/bash/helm_toolkit/security/cve-2025-53547-harden.sh) — Chart.yaml code injection hardening
- [Helm security scanning](docs/how-to/helm-security-scanning.md) — Helm security scanning with Trivy, kube-score, Checkov, Kubescape

### Set up Kubernetes
- [EKS cluster setup](docs/setup-guides/eks-cluster-setup.md) — Complete guide for creating EKS cluster on AWS
- [k8s_toolkit](docs/how-to/k8s_toolkit.md) — Safe kubectl helper scripts (drain, rollout, restart, logs, exec, debug)
- [RBAC guide](docs/how-to/k8s_rbac.md) — Role, ClusterRole, RoleBinding, ClusterRoleBinding

### Set up Terraform
- [Terraform CI/CD with Atlantis](docs/how-to/terraform-atlantis-gitops.md) — Terraform CI/CD with Atlantis and GitOps
- [Atlantis setup](scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh) — Atlantis server setup
- [EKS cluster](docs/how-to/terraform-eks-cluster.md) — EKS cluster with managed node groups
- [EKS deploy](scripts/bash/terraform_toolkit/eks/eks-deploy.sh) — EKS cluster deployment
- [EKS cleanup](scripts/bash/terraform_toolkit/eks/eks-cleanup.sh) — Safe EKS cluster cleanup
- [RDS with replicas](docs/how-to/terraform-rds-read-replicas.md) — RDS PostgreSQL with read replicas
- [RDS deploy](scripts/bash/terraform_toolkit/rds-deploy.sh) — RDS deployment automation
- [Module composition](docs/how-to/terraform-module-composition-workspaces.md) — Module composition and workspaces
- [Multi-environment](docs/how-to/terraform-multi-env-gitops.md) — Multi-environment infrastructure with Terraform workspaces
- [Terraform workflow](scripts/bash/terraform_toolkit/terraform-workflow.sh) — init/plan/apply with sensitive value handling

### Configure Git
- [Git installation Linux](docs/how-to/git-installation.md) — Git installation for Linux
- [Git installation macOS](docs/how-to/git-installation-macos.md) — Git installation on macOS via Homebrew
- [Git installation WSL](docs/how-to/git-installation-wsl.md) — Git installation on Windows Subsystem for Linux
- [GitHub Actions runner](docs/setup-guides/git-github-actions-runner.md) — GitHub Actions self-hosted runner setup
- [GitHub runner script](scripts/bash/git/github-runner-install.sh) — GitHub Actions runner installation
- [Credential helper](docs/setup-guides/git-credential-helper-ci-cd.md) — Git credential helper setup for CI/CD
- [Pre-commit security](docs/how-to/git-pre-commit-security-scanning.md) — Pre-commit hooks for secrets and vulnerabilities
- [Git security access control](docs/security/git-security-access-control-authentication.md) — Git access control and authentication hardening

### Linux System Administration
- [Linux toolkit](docs/how-to/linux_toolkit.md) — Linux system administration scripts
- [System hardening](docs/how-to/linux/linux-system-hardening-containerized.md) — System hardening for containerized environments
- [Hardening script](scripts/bash/linux/linux-system-hardening.sh) — Automated hardening script
- [AIDE file integrity](docs/how-to/linux-aide-configuration.md) — AIDE file integrity monitoring
- [AIDE deploy](scripts/bash/linux_toolkit/security/aide-deploy.sh) — Automated AIDE deployment
- [Ansible patching](docs/how-to/linux-ansible-patching.md) — Automated patching with Ansible
- [OpenSCAP hardening](docs/how-to/linux-openscap-hardening.md) — OpenSCAP compliance scanning
- [OpenSCAP script](scripts/bash/linux_toolkit/security/openscap-hardening.sh) — Compliance automation
- [Incident response](docs/how-to/linux-incident-response-automation.md) — Automated forensic evidence collection
- [Incident response script](scripts/bash/linux_toolkit/security/forensics/incident-response.sh) — Forensics automation
- [kpatch live patching](docs/how-to/linux/linux-kpatch-live-patching.md) — Linux kernel live patching
- [kpatch script](scripts/bash/linux_toolkit/security/kpatch-deployment.sh) — kpatch live kernel patching deployment
- [Wazuh SIEM](docs/how-to/linux/linux-wazuh-siem.md) — Wazuh SIEM deployment

### Linux Services
- [DNS BIND9](docs/how-to/linux-dns-bind9.md) — BIND9 DNS server setup
- [DNS BIND9 script](scripts/bash/linux_toolkit/dns/bind9-server-setup.sh) — Automated BIND9 installation
- [CoreDNS management](docs/how-to/linux-dns-management-coredns-systemd-resolved.md) — CoreDNS and systemd-resolved
- [HAProxy load balancer](docs/how-to/linux-haproxy-load-balancer.md) — HAProxy L4/L7 load balancer
- [HAProxy script](scripts/bash/linux_toolkit/loadbalancer/haproxy-setup.sh) — Automated HAProxy deployment
- [Nginx reverse proxy](docs/how-to/linux-nginx-reverse-proxy-ssl-tls.md) — Nginx reverse proxy with SSL/TLS
- [Nginx script](scripts/bash/linux_toolkit/network/nginx-reverse-proxy.sh) — Automated Nginx setup
- [LDAP server](docs/how-to/linux-ldap-server.md) — LDAP authentication server setup
- [LDAP script](scripts/bash/linux_toolkit/authentication/ldap-server-setup.sh) — Automated LDAP installation
- [Samba file sharing](docs/how-to/linux-samba.md) — Samba file server setup
- [Samba script](scripts/bash/linux_toolkit/samba/samba-setup.sh) — Automated Samba setup
- [Mail server](docs/how-to/linux-mail-server.md) — Postfix and Dovecot mail server
- [Mail script](scripts/bash/linux_toolkit/mail/mail-server-setup.sh) — Automated mail server installation
- [WireGuard VPN](docs/how-to/linux-vpn-wireguard.md) — WireGuard VPN server guide
- [WireGuard script](scripts/bash/linux_toolkit/vpn/wireguard-server-setup.sh) — Automated WireGuard installation
- [FreeIPA identity](docs/how-to/linux-freeipa-identity.md) — FreeIPA identity management
- [FreeIPA script](scripts/bash/linux_toolkit/identity/freeipa-setup.sh) — Automated FreeIPA deployment

### Linux Logging and Monitoring
- [ELK stack](docs/how-to/linux-elk-log-aggregation.md) — ELK stack log aggregation
- [ELK script](scripts/bash/linux_toolkit/logging/elk-setup.sh) — Automated ELK stack installation
- [Loki Promtail](docs/how-to/linux-log-aggregation-loki-promtail.md) — Loki and Promtail log aggregation
- [Loki script](scripts/bash/linux_toolkit/linux-loki-promtail-deploy.sh) — Automated Loki and Promtail deployment
- [Centralized logging](docs/how-to/linux-centralized-logging-syslog-ng-logstash.md) — Centralized logging with syslog-ng and Logstash
- [Centralized logging script](scripts/bash/linux_toolkit/setup-centralized-logging.sh) — Automated syslog-ng + Logstash + Elasticsearch
- [Prometheus monitoring](docs/how-to/linux-monitoring-prometheus.md) — Prometheus monitoring setup
- [Node exporter](docs/how-to/linux-monitoring-prometheus-node-exporter.md) — Prometheus node_exporter dashboard
- [Node exporter script](scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh) — Automated node_exporter installation

### Linux Database
- [PostgreSQL 16](lab/mini-projects/postgresql-database-server/README.md) — PostgreSQL 16 with replication
- [pg-setup](scripts/bash/linux_toolkit/database/pg-setup.sh) — Automated PostgreSQL 16 installation
- [pg-backup](scripts/bash/linux_toolkit/database/pg-backup.sh) — PostgreSQL backup with rotation
- [pg-healthcheck](scripts/bash/linux_toolkit/database/pg-healthcheck.sh) — PostgreSQL health check

### Linux Backup and Recovery
- [rsync backup](docs/how-to/linux-backup-rsync-retention.md) — Automated backup with rsync and retention
- [rsync script](scripts/bash/linux_toolkit/backup/backup-rsync-retention.sh) — Backup script with dry-run, encryption, retention
- [System backup](scripts/bash/linux_toolkit/sysadmin/system-backup.sh) — Automated system backup

### Linux Container Security
- [Container security scanning](docs/how-to/linux-container-security-scanning.md) — Container security scanning with Trivy and Falco
- [Container security script](scripts/bash/linux_toolkit/linux-container-security-scan.sh) — Automated container security scanning
- [Container host security](docs/how-to/linux-container-host-security.md) — Container host security hardening
- [Container host hardening](scripts/bash/linux_toolkit/security/container-host-hardening.sh) — Security hardening script

### Linux Automation
- [System automation template](docs/how-to/linux/linux-system-automation-template.md) — Linux system automation template
- [IaC shell script library](docs/how-to/linux/linux-shell-script-library-iac.md) — Shell script library for IaC operations
- [IaC operations](scripts/bash/linux_toolkit/lib/iac-operations.sh) — Shell script library with Terraform/Ansible functions
- [IaC pipeline workflows](docs/how-to/linux/linux-iac-pipeline-workflows.md) — Infrastructure-as-Code automation workflows
- [IaC pipeline script](scripts/bash/linux_toolkit/pipeline/iac-pipeline-workflow.sh) — Pipeline workflow with multi-environment support
- [Systemd cgroups](docs/how-to/linux/linux-container-orchestration-systemd-cgroups.md) — Container orchestration with systemd and cgroups
- [Container orchestration script](scripts/bash/linux_toolkit/container-orchestration-systemd-cgroups.sh) — Container orchestration automation
- [Linux automation template](templates/linux-automation/) — Linux automation template with Ansible

### Terraform Projects
- [Terraform project](lab/mini-projects/terraform-project/README.md) — Terraform project with modules
- [K8s provisioning](docs/how-to/k8s-terraform-ansible-provisioning.md) — Self-managed K8s with Terraform + Ansible
- [K8s CI/CD with Vault](docs/how-to/k8s-jenkins-vault-cicd-security.md) — Secure CI/CD pipeline with Jenkins and Vault
- [K8s GitOps](docs/how-to/k8s-argocd-vault-gitops.md) — GitOps with ArgoCD and Vault secrets injection

### Reference
- [Glossary](../00_index/glossary.md) — Terms and acronyms
- [Kubectl cheatsheet](../snippets/kubectl-cheatsheet.md) — Quick kubectl reference
- [Kafka cheatsheet](../snippets/kafka-cheatsheet.md) — Kafka commands reference
- [Jenkins cheatsheet](../snippets/jenkins-cheatsheet.md) — Jenkinsfile examples
- [Ansible commands](../snippets/ansible-commands.md) — Ansible ad-hoc commands
- [Linux cheatsheet](../snippets/linux-cheatsheet.md) — Linux commands reference
- [Terraform commands](../snippets/terraform-commands.md) — Terraform CLI one-liners
- [Vault commands](../snippets/vault-commands.md) — Vault CLI commands
- [Docker commands](../snippets/docker-commands.md) — Docker CLI snippets
- [Git commands](../snippets/git-commands.md) — Git CLI commands reference
- [CI/CD cheatsheet](../snippets/ci-cd-cheatsheet.md) — CI/CD commands reference
- [Observability cheatsheet](../snippets/observability-cheatsheet.md) — PromQL, LogQL reference