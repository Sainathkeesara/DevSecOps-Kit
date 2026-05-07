# Topics

## Kubernetes
- [script] scripts/bash/k8s_toolkit/context/context-manager.sh — Multi-cluster context switching
- [script] scripts/bash/k8s_toolkit/debug/debug-pod.sh — Interactive pod debugging session
- [script] scripts/bash/k8s_toolkit/job/cleanup-jobs.sh — Clean up completed or failed jobs
- [script] scripts/bash/k8s_toolkit/node/drain-node.sh — Safely drain a node before maintenance
- [script] scripts/bash/k8s_toolkit/pod/exec-pod.sh — Execute commands in running pods
- [script] scripts/bash/k8s_toolkit/pod/pod-logs.sh — Stream and tail pod logs
- [script] scripts/bash/k8s_toolkit/pod/restart-pod.sh — Restart pods with graceful termination
- [script] scripts/bash/k8s_toolkit/report/namespace-report.sh — Generate namespace resource reports
- [script] scripts/bash/k8s_toolkit/rollout-restart.sh — Restart deployments with watch
- [script] scripts/bash/k8s_toolkit/rollout-status.sh — Monitor deployment rollout status
- [script] scripts/bash/k8s_toolkit/secret/decode-secret.sh — Decode base64 Kubernetes secrets
- [script] scripts/bash/k8s_toolkit/security/cve-2026-3288-nginx.sh — ingress-nginx RCE vulnerability scanner
- [script] scripts/bash/kubernetes/aks-privilege-escalation-hardening.sh — AKS privilege escalation hardening
- [script] scripts/bash/kubernetes/mcp-server-kubernetes-hardening.sh — mcp-server-kubernetes CVE-2026-39884 hardening
- [script] scripts/bash/k8s/security/k8s-acm-cve-2026-4740.sh — Kubernetes ACM privilege escalation scanner
- [doc] docs/how-to/k8s_toolkit.md — Complete usage guide for all k8s scripts
- [doc] docs/how-to/k8s_rbac.md — Role, ClusterRole, RoleBinding guide
- [doc] docs/how-to/k8s-aks-cve-2026-33105.md — AKS privilege escalation remediation
- [doc] docs/how-to/k8s-argocd-vault-gitops.md — GitOps with ArgoCD and Vault secret injection
- [doc] docs/how-to/k8s-external-secrets-cve-2026-34984.md — External Secrets Operator DNS exfiltration remediation
- [doc] docs/how-to/k8s-ingress-nginx-cve-2026-4342.md — ingress-nginx RCE vulnerability remediation
- [doc] docs/how-to/k8s-jenkins-vault-cicd-security.md — CI/CD pipeline with Jenkins and Vault secrets
- [doc] docs/how-to/k8s-terraform-ansible-provisioning.md — Self-managed K8s provisioning with Terraform + Ansible
- [doc] docs/setup-guides/eks-cluster-setup.md — EKS cluster setup guide
- [doc] docs/troubleshooting/k8s-crashloopbackoff.md — CrashLoopBackOff diagnosis and fix
- [doc] docs/troubleshooting/k8s-cluster-autoscaler-cve-2026-33186.md — cluster-autoscaler CVE hardening
- [doc] docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md — MCP server Kubernetes CVE remediation
- [snippet] snippets/kubectl-cheatsheet.md — Quick kubectl reference
- [template] templates/k8s/deploy-prod-app.sh — Production deployment generator
- [template] templates/k8s/deployment-monitor.sh — Deployment monitoring script
- [template] templates/k8s/production-deployment.yaml — Deployment with HPA and PDB

## Kafka
- [script] scripts/bash/kafka_toolkit/acl/manage-acls.sh — Manage Kafka ACLs
- [script] scripts/bash/kafka_toolkit/admin/broker-health.sh — Individual broker health check
- [script] scripts/bash/kafka_toolkit/admin/cluster-health.sh — Cluster health overview
- [script] scripts/bash/kafka_toolkit/consumers/check-lag.sh — Check consumer lag with thresholds
- [script] scripts/bash/kafka_toolkit/consumers/consumer-groups.sh — List consumer groups
- [script] scripts/bash/kafka_toolkit/messaging/consume-message.sh — Consume messages from topic
- [script] scripts/bash/kafka_toolkit/messaging/produce-message.sh — Produce messages to topic
- [script] scripts/bash/kafka_toolkit/monitoring/consumer-lag.sh — Monitor consumer lag
- [script] scripts/bash/kafka_toolkit/monitoring/throughput-check.sh — Measure topic throughput
- [script] scripts/bash/kafka_toolkit/partitions/partition-mgmt.sh — Partition management
- [script] scripts/bash/kafka_toolkit/partitions/partition-reassign.sh — Partition reassignment
- [script] scripts/bash/kafka_toolkit/security/cve-2025-27817.sh — Kafka Client SSRF scanner
- [script] scripts/bash/kafka_toolkit/security/cve-2025-27818.sh — Kafka Connect SASL JAAS RCE scanner
- [script] scripts/bash/kafka_toolkit/topics/topic-config.sh — View/modify topic config
- [script] scripts/bash/kafka_toolkit/topics/topic-create.sh — Create new topics
- [script] scripts/bash/kafka_toolkit/topics/topic-delete.sh — Delete topics
- [script] scripts/bash/kafka_toolkit/topics/topic-list.sh — List Kafka topics
- [doc] docs/how-to/kafka_toolkit.md — Complete usage guide
- [doc] docs/setup-guides/kafka-cluster-setup.md — Local Kafka cluster setup
- [doc] docs/troubleshooting/kafka-consumer-lag.md — Consumer lag troubleshooting
- [snippet] snippets/kafka-cheatsheet.md — Kafka commands reference
- [snippet] snippets/kafka-topics-commands.md — Kafka topics CLI one-liners

## Jenkins
- [script] scripts/bash/jenkins_toolkit/install-jenkins.sh — Automated Jenkins installation
- [script] scripts/bash/jenkins_toolkit/security/cve-2026-27099.sh — Jenkins XSS/DoS vulnerability scanner
- [doc] docs/how-to/github-webhook-jenkins.md — GitHub webhook configuration
- [doc] docs/how-to/jenkins_toolkit.md — Jenkins toolkit usage guide
- [doc] docs/reference/jenkins-commands.md — Jenkins CLI commands reference (50+ commands)
- [doc] docs/reference/jenkins-rest-api.md — Jenkins REST API reference
- [doc] docs/troubleshooting/jenkins-troubleshooting.md — Jenkins troubleshooting guide
- [snippet] snippets/jenkins-cheatsheet.md — Jenkinsfile examples
- [snippet] snippets/jenkins-cli-commands.md — Jenkins CLI with 150+ commands
- [snippet] snippets/jenkins-commands-reference.md — 100+ CLI commands reference
- [snippet] snippets/jenkins-scripted-pipeline-groovy.md — Scripted pipeline Groovy examples
- [template] templates/jenkins/Jenkinsfile-maven-gradle-template.md — Maven/Gradle Jenkinsfile template

## Linux
- [script] scripts/bash/linux_toolkit/authentication/ldap-server-setup.sh — LDAP authentication server setup
- [script] scripts/bash/linux_toolkit/backup/backup-rsync-retention.sh — Backup with rsync and retention policy
- [script] scripts/bash/linux_toolkit/container-orchestration-systemd-cgroups.sh — Container orchestration with systemd
- [script] scripts/bash/linux_toolkit/database/pg-backup.sh — PostgreSQL backup with rotation
- [script] scripts/bash/linux_toolkit/database/pg-healthcheck.sh — PostgreSQL health check
- [script] scripts/bash/linux_toolkit/database/pg-setup.sh — PostgreSQL 16 automated installation
- [script] scripts/bash/linux_toolkit/dns/bind9-server-setup.sh — BIND9 DNS server setup
- [script] scripts/bash/linux_toolkit/lib/iac-operations.sh — Shell script library for IaC operations
- [script] scripts/bash/linux_toolkit/loadbalancer/haproxy-setup.sh — HAProxy load balancer setup
- [script] scripts/bash/linux_toolkit/logging/elk-setup.sh — ELK stack automated deployment
- [script] scripts/bash/linux_toolkit/mail/mail-server-setup.sh — Postfix and Dovecot mail server
- [script] scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh — Prometheus node_exporter installation
- [script] scripts/bash/linux_toolkit/network/net-diag.sh — Network diagnostics
- [script] scripts/bash/linux_toolkit/network/nginx-reverse-proxy.sh — Nginx reverse proxy with SSL/TLS
- [script] scripts/bash/linux_toolkit/process/process-manager.sh — Process management
- [script] scripts/bash/linux_toolkit/samba/samba-setup.sh — Samba file server deployment
- [script] scripts/bash/linux_toolkit/security/ansible-patch-management.sh — Automated patching with Ansible
- [script] scripts/bash/linux_toolkit/security/container-host-hardening.sh — Docker container host hardening
- [script] scripts/bash/linux_toolkit/security/forensics/incident-response.sh — Incident response automation
- [script] scripts/bash/linux_toolkit/security/openscap-hardening.sh — OpenSCAP compliance automation
- [script] scripts/bash/linux_toolkit/security/security-check.sh — Security audit
- [script] scripts/bash/linux_toolkit/service/manage-services.sh — Systemd service management
- [script] scripts/bash/linux_toolkit/setup-centralized-logging.sh — Syslog-ng + Logstash + Elasticsearch deployment
- [script] scripts/bash/linux_toolkit/sysadmin/disk-usage.sh — Disk usage analysis
- [script] scripts/bash/linux_toolkit/sysadmin/network-iface.sh — Network interface management
- [script] scripts/bash/linux_toolkit/sysadmin/process-monitor.sh — Process monitoring
- [script] scripts/bash/linux_toolkit/sysadmin/security-audit.sh — Security audit checks
- [script] scripts/bash/linux_toolkit/sysadmin/service-health.sh — Service health check
- [script] scripts/bash/linux_toolkit/sysadmin/system-backup.sh — Automated system backup
- [script] scripts/bash/linux_toolkit/sysadmin/user-create.sh — Create system users
- [script] scripts/bash/linux_toolkit/sysadmin/user-modify.sh — Modify users and groups
- [script] scripts/bash/linux_toolkit/system-automation-template.sh — Linux automation template deployment
- [script] scripts/bash/linux_toolkit/system/disk-usage.sh — Disk usage analysis (toolkit)
- [script] scripts/bash/linux_toolkit/system/health-check.sh — System health monitoring
- [script] scripts/bash/linux_toolkit/vpn/wireguard-server-setup.sh — WireGuard VPN server installation
- [script] scripts/bash/linux/aide-config.sh — AIDE configuration management
- [script] scripts/bash/linux/linux-container-security-scan.sh — Container security scanning with Trivy
- [script] scripts/bash/linux/linux-system-hardening.sh — System hardening automation
- [doc] docs/how-to/linux-samba-file-sharing.md — Samba file sharing server
- [doc] docs/how-to/linux-samba.md — Samba setup guide
- [doc] docs/how-to/linux-aide-configuration-management.md — AIDE configuration management guide
- [doc] docs/how-to/linux-aide-configuration.md — AIDE setup and usage guide
- [doc] docs/how-to/linux-ansible-patching.md — Automated patching with Ansible
- [doc] docs/how-to/linux-backup-rsync-retention.md — Backup solution with rsync
- [doc] docs/how-to/linux-container-host-docker-security.md — Container host Docker security
- [doc] docs/how-to/linux-container-host-security.md — Container host security hardening
- [doc] docs/how-to/linux-container-security-scanning.md — Container security scanning with Trivy and Falco
- [doc] docs/how-to/linux-dns-bind9.md — BIND9 DNS server setup
- [doc] docs/how-to/linux-dns-management-coredns-systemd-resolved.md — CoreDNS and systemd-resolved management
- [doc] docs/how-to/linux-elk-log-aggregation.md — ELK stack log aggregation
- [doc] docs/how-to/linux-freeipa-identity.md — FreeIPA identity management
- [doc] docs/how-to/linux-haproxy-load-balancer.md — HAProxy load balancer guide
- [doc] docs/how-to/linux-harbor-registry.md — Harbor container registry setup
- [doc] docs/how-to/linux-incident-response-automation.md — Incident response automation
- [doc] docs/how-to/linux-ldap-server.md — LDAP server setup
- [doc] docs/how-to/linux-log-aggregation-loki-promtail.md — Loki and Promtail log aggregation
- [doc] docs/how-to/linux-mail-server.md — Postfix and Dovecot mail server
- [doc] docs/how-to/linux-monitoring-prometheus-node-exporter.md — Prometheus node_exporter dashboard
- [doc] docs/how-to/linux-monitoring-prometheus.md — Prometheus monitoring setup
- [doc] docs/how-to/linux-network-traffic-analysis.md — Network traffic analysis
- [doc] docs/how-to/linux-nginx-reverse-proxy-ssl-tls.md — Nginx reverse proxy with SSL/TLS
- [doc] docs/how-to/linux-openscap-hardening.md — OpenSCAP compliance scanning
- [doc] docs/how-to/linux-vpn-wireguard.md — WireGuard VPN server guide
- [doc] docs/how-to/linux/linux-aide-configuration-management.md — AIDE config management (L7)
- [doc] docs/how-to/linux/linux-container-orchestration-systemd-cgroups.md — Container orchestration automation (L7)
- [doc] docs/how-to/linux/linux-disk-io-scheduler-optimization.md — Disk I/O scheduler optimization (L7)
- [doc] docs/how-to/linux/linux-iac-pipeline-workflows.md — IaC pipeline workflows (L7)
- [doc] docs/how-to/linux/linux-shell-commands-automation.md — Shell command patterns (L7)
- [doc] docs/how-to/linux/linux-shell-script-library-iac.md — IaC shell script library (L7)
- [doc] docs/how-to/linux/linux-system-automation-template.md — System automation template (L7)
- [doc] docs/how-to/linux/linux-system-hardening-containerized.md — System hardening for containers (L7)
- [doc] docs/how-to/linux/linux-wazuh-siem.md — Wazuh SIEM deployment (L7)
- [doc] docs/how-to/linux_toolkit.md — Linux toolkit usage guide
- [doc] docs/runbooks/linux-system-administration.md — System administration runbook (L7)
- [snippet] snippets/linux-cheatsheet.md — Linux commands reference
- [snippet] snippets/linux-commands.md — Bash one-liners for sysadmins
- [template] templates/linux-automation/ — Linux automation template (Ansible-based)

## Terraform
- [script] scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh — Atlantis setup
- [script] scripts/bash/terraform_toolkit/eks/eks-cleanup.sh — EKS cluster cleanup
- [script] scripts/bash/terraform_toolkit/eks/eks-deploy.sh — EKS cluster deployment
- [script] scripts/bash/terraform_toolkit/eks/eks-health-check.sh — EKS health check
- [script] scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh — Multi-environment setup
- [script] scripts/bash/terraform_toolkit/rds-deploy.sh — RDS deployment
- [script] scripts/bash/terraform_toolkit/secrets/terraform-secrets-deploy.sh — AWS Secrets Manager deployment
- [script] scripts/bash/terraform_toolkit/terraform-lambda-deploy.sh — Lambda/API Gateway deployment
- [script] scripts/bash/terraform_toolkit/terraform-workflow.sh — Terraform workflow automation
- [script] scripts/bash/terraform/ter-019-deploy.sh — EventBridge Lambda deployment
- [script] scripts/bash/terraform/terraform-ecs-service-discovery-deploy.sh — ECS service discovery deployment
- [script] scripts/bash/terraform/terraform-iam-roles-deploy.sh — IAM roles deployment
- [doc] docs/how-to/terraform-atlantis-gitops.md — Terraform CI/CD with Atlantis
- [doc] docs/how-to/terraform-aws-secrets-manager.md — AWS Secrets Manager integration
- [doc] docs/how-to/terraform-aws-vpc.md — AWS VPC setup
- [doc] docs/how-to/terraform-cloudfront-waf.md — CloudFront with WAF
- [doc] docs/how-to/terraform-ecs-service-discovery.md — ECS Fargate service discovery
- [doc] docs/how-to/terraform-eks-cluster.md — EKS cluster setup
- [doc] docs/how-to/terraform-eventbridge-lambda.md — EventBridge with Lambda triggers
- [doc] docs/how-to/terraform-iam-roles.md — Reusable IAM roles
- [doc] docs/how-to/terraform-lambda-api-gateway.md — Serverless API with Lambda
- [doc] docs/how-to/terraform-module-composition-workspaces.md — Module composition and workspaces
- [doc] docs/how-to/terraform-multi-env-gitops.md — Multi-environment GitOps
- [doc] docs/how-to/terraform-rds-read-replicas.md — RDS with read replicas
- [doc] docs/how-to/terraform-secrets-manager.md — Secrets Manager integration
- [doc] docs/how-to/terraform-state-management.md — State management best practices
- [doc] docs/how-to/terraform-troubleshooting.md — Terraform troubleshooting
- [doc] docs/how-to/terraform-eks-cluster.md — EKS cluster guide
- [doc] docs/reference/git-advanced-commands.md — Git advanced commands (L4)
- [doc] docs/reference/git-commands.md — Git command patterns (L4)
- [snippet] snippets/terraform-commands.md — Terraform CLI one-liners
- [template] templates/terraform/lambda-api-gateway/ — Lambda + API Gateway module
- [template] templates/terraform/multi-env/ — Multi-environment VPC module
- [template] templates/terraform/production-module-template.md — Production module template
- [template] templates/terraform/rds-with-replicas/ — RDS with read replicas module

## Ansible
- [script] scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh — AAP wheel privilege escalation scanner
- [script] scripts/bash/ansible_toolkit/security/aap-cve-2026-0598-check.sh — AAP Lightspeed auth bypass scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2025-14010-audit.sh — Sensitive variable exposure scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2026-0598-audit.sh — Lightspeed auth bypass scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2026-33228-audit.sh — Flatted prototype pollution auditor
- [script] scripts/bash/ansible_toolkit/security/harden-ansible-cve-2026-33228.sh — Flatted prototype pollution hardening
- [script] scripts/bash/ansible_toolkit/security/vault-password-rotation.sh — Vault password rotation
- [script] scripts/bash/ansible_toolkit/patch-management.yml — Ansible patching playbook
- [doc] docs/how-to/ansible-cve-2026-33228-flatted.md — CVE-2026-33228 hardening guide
- [doc] docs/how-to/ansible-lightspeed-cve-2026-0598.md — CVE-2026-0598 remediation guide
- [doc] docs/how-to/ansible-playbook-best-practices.md — Playbook best practices
- [doc] docs/how-to/ansible_toolkit.md — Ansible toolkit usage guide
- [snippet] snippets/ansible-commands.md — Ansible ad-hoc commands

## Vault
- [script] scripts/bash/vault_toolkit/security/cve-2025-11621.sh — AWS Auth bypass scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-5999.sh — Privilege escalation scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6000.sh — Plugin directory RCE scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6013.sh — LDAP MFA enforcement bypass scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6037.sh — TLS certificate auth bypass scanner
- [script] scripts/bash/vault_toolkit/security/cve-2026-4660.sh — go-getter arbitrary file read scanner
- [script] scripts/bash/vault_toolkit/vault-audit-log-analysis.sh — Vault audit log analysis
- [doc] docs/how-to/vault-secure-deployment.md — Vault secure deployment guide
- [doc] docs/how-to/vault-troubleshooting-seal-unseal.md — Seal/unseal troubleshooting
- [doc] docs/how-to/vault_toolkit.md — Vault toolkit usage guide
- [doc] docs/troubleshooting/vault-seal-unseal.md — Vault seal/unseal issues
- [snippet] snippets/vault-commands.md — Vault CLI commands

## Observability
- [script] scripts/bash/observability_toolkit/grafana/health-check.sh — Grafana health check
- [script] scripts/bash/observability_toolkit/jaeger/query-traces.sh — Query Jaeger traces
- [script] scripts/bash/observability_toolkit/loki/query-logs.sh — Query Loki logs with LogQL
- [script] scripts/bash/observability_toolkit/otel/collector-health.sh — OTel collector health
- [script] scripts/bash/observability_toolkit/prometheus/check-alert.sh — Check Prometheus alerts
- [script] scripts/bash/observability_toolkit/prometheus/query-metrics.sh — Execute PromQL queries
- [script] scripts/bash/observability_toolkit/prometheus/targets-status.sh — Prometheus targets health
- [script] scripts/bash/observability_toolkit/stack-health.sh — Full stack health check
- [doc] docs/how-to/observability_toolkit.md — Observability toolkit usage guide
- [snippet] snippets/observability-cheatsheet.md — PromQL, LogQL reference

## Docker
- [script] scripts/bash/docker_toolkit/docker-image-cleanup.sh — Docker image cleanup with age filtering
- [script] scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh — Docker Swarm cluster setup
- [script] scripts/bash/docker_toolkit/security/cve-2026-2664.sh — Docker Desktop grpcfuse privilege escalation scanner
- [script] scripts/bash/docker_toolkit/security/cve-2026-28400.sh — Docker Model Runner privilege escalation scanner
- [script] scripts/bash/docker_toolkit/security/cve-2026-34040.sh — Docker authorization plugin bypass scanner
- [script] scripts/bash/docker/security/docker-cve-2026-34040.sh — Docker CVE-2026-34040 remediation (legacy)
- [doc] docs/how-to/docker-kaniko-cve-2026-28406.md — Kaniko path traversal remediation
- [doc] docs/how-to/docker-security-best-practices.md — Docker security hardening guide
- [doc] docs/how-to/docker-security.md — Docker comprehensive security guide
- [doc] docs/how-to/docker-swarm-cluster-installation.md — Docker Swarm cluster installation
- [doc] docs/security/docker/AUTHZ-PLUGIN-HARDENING.md — Docker AuthZ plugin hardening
- [doc] docs/security/docker/CVE-2026-34040.md — Docker CVE-2026-34040 remediation
- [snippet] snippets/docker-commands.md — Docker CLI snippets

## Helm
- [script] scripts/bash/helm_toolkit/security/cve-2025-53547-harden.sh — Chart.yaml code injection hardening
- [script] scripts/bash/helm_toolkit/security/cve-2025-53547.sh — Chart.yaml code injection scanner
- [script] scripts/bash/helm_toolkit/helm-terraform/deploy-helm-terraform.sh — Helm + Terraform deployment
- [doc] docs/how-to/helm-commands-reference.md — Helm CLI commands reference
- [doc] docs/how-to/helm-security-scanning.md — Helm security scanning guide
- [doc] docs/how-to/helm-terraform-fullstack/README.md — Helm + Terraform full-stack guide

## CI/CD
- [script] scripts/bash/ci_cd_toolkit/github/check-action-updates.sh — Check for outdated GitHub Actions
- [script] scripts/bash/ci_cd_toolkit/github/generate-workflow.sh — Generate starter workflows
- [script] scripts/bash/ci_cd_toolkit/github/lint-workflows.sh — Lint GitHub Actions workflows
- [script] scripts/bash/ci_cd_toolkit/github/pipeline-health.sh — Check pipeline health
- [script] scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh — Trivy supply chain compromise scanner
- [script] scripts/bash/ci_cd_toolkit/github/validate-workflow.sh — Validate workflow syntax
- [doc] docs/how-to/ci_cd_toolkit.md — CI/CD toolkit usage guide
- [doc] docs/security/trivy/CVE-2026-33634.md — Trivy CVE-2026-33634 remediation guide
- [snippet] snippets/ci-cd-cheatsheet.md — CI/CD commands reference

## OCI/Container Registries
- [script] scripts/bash/oci_registry_toolkit/auth/check-auth.sh — Auth diagnostics
- [script] scripts/bash/oci_registry_toolkit/registry/list-repos.sh — List repositories
- [script] scripts/bash/oci_registry_toolkit/registry/list-tags.sh — List tags for repo
- [script] scripts/bash/oci_registry_toolkit/tags/find-old-tags.sh — Find old/unused tags
- [script] scripts/bash/oci_registry_toolkit/tools/keepalive-pull-plan.sh — Generate keepalive pull plan
- [doc] docs/how-to/oci_registry_toolkit.md — OCI registry toolkit usage guide
- [snippet] snippets/oci-registry-cheatsheet.md — Registry commands reference

## Git
- [doc] docs/concepts/git-001-version-control-fundamentals.md — Introduction to version control fundamentals (L1)
- [doc] docs/concepts/git-002-basic-commands-setup.md — Basic Git commands and repository setup (L1)
- [doc] docs/concepts/git-005-configuration-aliases.md — Git configuration, aliases, and best practices (L1)
- [doc] docs/concepts/git-version-control-mental-model.md — Architecture, repositories, branching, remote operations
- [doc] docs/how-to/git-cicd-automation.md — Git automation for CI/CD integration (L6)
- [doc] docs/how-to/git-installation-macos.md — Git installation on macOS
- [doc] docs/how-to/git-installation-wsl.md — Git installation on WSL
- [doc] docs/how-to/git-installation.md — Git installation for Linux
- [doc] docs/how-to/git-pre-commit-security-scanning.md — Pre-commit security scanning (L2)
- [doc] docs/how-to/git-workflow-optimization.md — Git workflow optimization for DevOps (L3)
- [doc] docs/how-to/git/git-credential-helper-cicd-setup.md — Credential helper for CI/CD pipelines
- [doc] docs/reference/git-advanced-commands.md — Git advanced command patterns (L4)
- [doc] docs/reference/git-commands.md — Git command patterns (L4)
- [doc] docs/security/git-security-access-control-authentication.md — Git access control and authentication hardening
- [doc] docs/setup-guides/git-credential-helper-ci-cd.md — Credential helper setup guide
- [doc] docs/setup-guides/git-github-actions-runner.md — GitHub Actions runner setup
- [script] scripts/bash/git/credential-helper-ci.sh — Credential helper configuration
- [script] scripts/bash/git/git-automation.sh — Git automation for CI/CD
- [script] scripts/bash/git/git-cicd-hooks.sh — CI/CD hooks
- [script] scripts/bash/git/git-install-macos.sh — macOS installation script
- [script] scripts/bash/git/git-install-wsl.sh — WSL installation script
- [script] scripts/bash/git/git-install.sh — Linux installation script
- [script] scripts/bash/git/git-pre-commit-hooks.sh — Pre-commit hook automation
- [script] scripts/bash/git/github-runner-install.sh — GitHub Actions runner installation
- [snippet] snippets/git-commands.md — Git CLI commands reference

## Concepts
- [doc] docs/concepts/git-001-version-control-fundamentals.md — Git fundamentals (L1)
- [doc] docs/concepts/git-002-basic-commands-setup.md — Git basic commands (L1)
- [doc] docs/concepts/git-005-configuration-aliases.md — Git configuration (L1)
- [doc] docs/concepts/git-version-control-mental-model.md — Git mental model

## Reference
- [doc] docs/reference/git-advanced-commands.md — Git advanced commands (L4)
- [doc] docs/reference/git-commands.md — Git commands reference (L4)
- [doc] docs/reference/jenkins-commands.md — Jenkins CLI commands (50+)
- [doc] docs/reference/jenkins-rest-api.md — Jenkins REST API reference

## Runbooks
- [doc] docs/runbooks/cve-2026-33228-ansible-flatted.md — CVE-2026-33228 remediation runbook
- [doc] docs/runbooks/linux-system-administration.md — Linux system administration runbook (L7)

## Troubleshooting
- [doc] docs/troubleshooting/jenkins-troubleshooting.md — Jenkins troubleshooting guide
- [doc] docs/troubleshooting/k8s-crashloopbackoff.md — CrashLoopBackOff diagnosis and fix
- [doc] docs/troubleshooting/k8s-cluster-autoscaler-cve-2026-33186.md — cluster-autoscaler CVE hardening
- [doc] docs/troubleshooting/kafka-consumer-lag.md — Kafka consumer lag troubleshooting
- [doc] docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md — MCP server Kubernetes CVE remediation
- [doc] docs/troubleshooting/vault-seal-unseal.md — Vault seal/unseal issues

## Lab Projects
- [doc] lab/mini-projects/postgresql-database-server/README.md — PostgreSQL 16 with replication (L7)
- [doc] lab/mini-projects/samba-enterprise-file-sharing/README.md — Enterprise Samba file sharing (L7)
- [doc] lab/mini-projects/terraform-project/README.md — Terraform project with modules (L7)

## Environments (Terraform)
- [script] environments/dev/main.tf — Development environment Terraform
- [script] environments/dev/outputs.tf — Development outputs
- [script] environments/dev/terraform.tfvars — Development variables
- [script] environments/dev/variables.tf — Development variable definitions
- [script] environments/prod/main.tf — Production environment Terraform
- [script] environments/prod/outputs.tf — Production outputs
- [script] environments/prod/terraform.tfvars — Production variables
- [script] environments/prod/variables.tf — Production variable definitions
- [script] environments/staging/main.tf — Staging environment Terraform
- [script] environments/staging/outputs.tf — Staging outputs
- [script] environments/staging/terraform.tfvars — Staging variables
- [script] environments/staging/variables.tf — Staging variable definitions
