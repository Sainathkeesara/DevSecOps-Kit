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
- [script] scripts/bash/k8s_toolkit/security/k8s-acm-cve-2026-4740.sh — Kubernetes ACM privilege escalation scanner
- [script] scripts/bash/k8s_toolkit/security/k8s-cluster-autoscaler-grpc-hardening.sh — cluster-autoscaler grpc CVE-2026-33186 hardening
- [script] scripts/bash/k8s_toolkit/security/k8s-eso-cve-2026-34984-hardening.sh — External Secrets Operator DNS exfiltration hardening
- [script] scripts/bash/k8s_toolkit/security/k8s-ingress-nginx-cve-2026-4342-hardening.sh — ingress-nginx comment-based config injection hardening
- [script] scripts/bash/k8s_toolkit/security/mcp-server-kubernetes-hardening.sh — mcp-server-kubernetes CVE-2026-39884 hardening
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
- [script] scripts/bash/jenkins_toolkit/agents/jenkins-agent-connection-tuning.sh — Jenkins agent connection tuning
- [script] scripts/bash/jenkins_toolkit/install-jenkins.sh — Automated Jenkins installation
- [script] scripts/bash/jenkins_toolkit/security/cve-2026-27099.sh — Jenkins XSS/DoS vulnerability scanner
- [script] scripts/bash/jenkins_toolkit/security/cve-2026-33001.sh — Jenkins tar symlink path traversal scanner
- [doc] docs/how-to/github-webhook-jenkins.md — GitHub webhook configuration
- [doc] docs/how-to/jenkins-parallel-multi-branch.md — Parallel multi-branch pipeline patterns
- [doc] docs/how-to/jenkins_toolkit.md — Jenkins toolkit usage guide
- [doc] docs/reference/jenkins-agent-connection-tuning.md — Agent connection tuning reference
- [doc] docs/reference/jenkins-commands.md — Jenkins CLI commands reference (50+ commands)
- [doc] docs/reference/jenkins-credential-rotation.md — Automated credential rotation
- [doc] docs/reference/jenkins-job-config-xml-snippets.md — Job configuration XML snippets
- [doc] docs/reference/jenkins-secret-masking-envinject.md — Secret masking with EnvInject
- [doc] docs/reference/jenkins-pipeline-retry-strategy.md — Pipeline retry strategy configuration
- [doc] docs/reference/jenkins-rest-api.md — Jenkins REST API reference
- [doc] docs/troubleshooting/jenkins-troubleshooting.md — Jenkins troubleshooting guide
- [doc] docs/security/jenkins/CVE-2026-33001.md — CVE-2026-33001 remediation guide
- [snippet] snippets/jenkins-cheatsheet.md — Jenkinsfile examples
- [snippet] snippets/jenkins-cli-commands.md — Jenkins CLI with 150+ commands
- [snippet] snippets/jenkins-commands-reference.md — 100+ CLI commands reference
- [snippet] snippets/jenkins-scripted-pipeline-groovy.md — Scripted pipeline Groovy examples
- [template] templates/jenkins/Jenkinsfile-maven-gradle-template.md — Maven/Gradle Jenkinsfile template

## Linux
- [script] scripts/bash/linux_toolkit/aide-config.sh — AIDE configuration management
- [script] scripts/bash/linux_toolkit/aide-deploy.sh — AIDE deployment
- [script] scripts/bash/linux_toolkit/identity/freeipa-setup.sh — FreeIPA server deployment and client enrollment
- [script] scripts/bash/linux_toolkit/linux-container-security-scan.sh — Container security scanning with Trivy
- [script] scripts/bash/linux_toolkit/linux-dns-coredns.sh — Automated DNS entry management for CoreDNS
- [script] scripts/bash/linux_toolkit/linux-dns-monitor.sh — DNS health monitoring with auto-restart
- [script] scripts/bash/linux_toolkit/linux-dns-test.sh — DNS setup verification and testing
- [script] scripts/bash/linux_toolkit/linux-loki-promtail-deploy.sh — Loki and Promtail deployment
- [script] scripts/bash/linux_toolkit/linux-network-monitor.sh — Network health monitoring
- [script] scripts/bash/linux_toolkit/linux-system-commands-library.sh — Shell command library
- [script] scripts/bash/linux_toolkit/linux-system-hardening.sh — System hardening automation
- [script] scripts/bash/linux_toolkit/samba/samba-setup.sh — Samba file server deployment
- [script] scripts/bash/linux_toolkit/system-automation-template.sh — Linux automation template deployment
- [script] scripts/bash/linux_toolkit/wazuh-deploy.sh — Wazuh SIEM deployment
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
- [script] scripts/bash/linux_toolkit/pipeline/iac-pipeline-workflow.sh — IaC pipeline workflows
- [script] scripts/bash/linux_toolkit/process/process-manager.sh — Process management
- [script] scripts/bash/linux_toolkit/samba/samba-setup.sh — Samba file server deployment
- [script] scripts/bash/linux_toolkit/security/aide-deploy.sh — AIDE deployment
- [script] scripts/bash/linux_toolkit/security/ansible-patch-management.sh — Automated patching with Ansible
- [script] scripts/bash/linux_toolkit/security/container-host-hardening.sh — Docker container host hardening
- [script] scripts/bash/linux_toolkit/security/forensics/incident-response.sh — Incident response automation
- [script] scripts/bash/linux_toolkit/security/kpatch-deployment.sh — kpatch live kernel patching
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
- [script] scripts/bash/linux_toolkit/system/disk-usage.sh — Disk usage analysis
- [script] scripts/bash/linux_toolkit/system/health-check.sh — System health monitoring
- [script] scripts/bash/linux_toolkit/vpn/wireguard-server-setup.sh — WireGuard VPN server installation
- [doc] docs/how-to/linux-aide-configuration-management.md — AIDE configuration management guide
- [doc] docs/how-to/linux-aide-configuration.md — AIDE setup and usage guide
- [doc] docs/how-to/linux-ansible-patching.md — Automated patching with Ansible
- [doc] docs/how-to/linux-backup-rsync-retention.md — Backup solution with rsync
- [doc] docs/how-to/linux-centralized-logging-syslog-ng-logstash.md — Centralized logging pipeline
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
- [doc] docs/how-to/linux-samba-file-sharing.md — Samba file sharing server
- [doc] docs/how-to/linux-samba.md — Samba setup guide
- [doc] docs/how-to/linux-vpn-wireguard.md — WireGuard VPN server guide
- [doc] docs/how-to/linux/linux-aide-configuration-management.md — AIDE config management
- [doc] docs/how-to/linux/linux-container-orchestration-systemd-cgroups.md — Container orchestration with systemd and cgroups
- [doc] docs/how-to/linux/linux-disk-io-scheduler-optimization.md — Disk I/O scheduler optimization
- [doc] docs/how-to/linux/linux-iac-pipeline-workflows.md — IaC pipeline workflows
- [doc] docs/how-to/linux/linux-kpatch-live-patching.md — Linux kernel live patching
- [doc] docs/how-to/linux/linux-shell-commands-automation.md — Shell command patterns
- [doc] docs/how-to/linux/linux-shell-script-library-iac.md — IaC shell script library
- [doc] docs/how-to/linux/linux-system-automation-template.md — System automation template
- [doc] docs/how-to/linux/linux-system-hardening-containerized.md — System hardening for containers
- [doc] docs/how-to/linux/linux-wazuh-siem.md — Wazuh SIEM deployment
- [doc] docs/how-to/linux_toolkit.md — Linux toolkit usage guide
- [doc] docs/runbooks/linux-system-administration.md — System administration runbook
- [snippet] snippets/linux-cheatsheet.md — Linux commands reference
- [snippet] snippets/linux-commands.md — Bash one-liners for sysadmins

## Terraform
- [script] scripts/bash/terraform/ter-019-deploy.sh — EventBridge Lambda deployment
- [script] scripts/bash/terraform/terraform-ecs-service-discovery-deploy.sh — ECS service discovery deployment
- [script] scripts/bash/terraform/terraform-iam-roles-deploy.sh — IAM roles deployment
- [script] scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh — Atlantis setup
- [script] scripts/bash/terraform_toolkit/eks/eks-cleanup.sh — EKS cluster cleanup
- [script] scripts/bash/terraform_toolkit/eks/eks-deploy.sh — EKS cluster deployment
- [script] scripts/bash/terraform_toolkit/eks/eks-health-check.sh — EKS health check
- [script] scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh — Multi-environment setup
- [script] scripts/bash/terraform_toolkit/networking/vpc-setup.sh — VPC deployment
- [script] scripts/bash/terraform_toolkit/rds-deploy.sh — RDS deployment
- [script] scripts/bash/terraform_toolkit/secrets/terraform-secrets-deploy.sh — AWS Secrets Manager deployment
- [script] scripts/bash/terraform_toolkit/terraform-lambda-deploy.sh — Lambda/API Gateway deployment
- [script] scripts/bash/terraform_toolkit/terraform-workflow.sh — Terraform workflow automation
- [doc] docs/how-to/terraform-atlantis-gitops.md — Terraform CI/CD with Atlantis
- [doc] docs/how-to/terraform-aws-secrets-manager.md — AWS Secrets Manager integration
- [doc] docs/how-to/terraform-aws-vpc.md — AWS VPC setup
- [doc] docs/how-to/terraform-cloudfront-waf.md — CloudFront with WAF
- [doc] docs/how-to/terraform-ecs-service-discovery.md — ECS Fargate service discovery
- [doc] docs/how-to/terraform-eks-cluster.md — EKS cluster setup
- [doc] docs/how-to/terraform-eventbridge-lambda.md — EventBridge with Lambda triggers
- [tf] docs/how-to/k8s-terraform-ansible-provisioning/terraform/control-plane.tf — K8s control plane nodes
- [tf] docs/how-to/k8s-terraform-ansible-provisioning/terraform/main.tf — K8s provisioning main
- [tf] docs/how-to/k8s-terraform-ansible-provisioning/terraform/outputs.tf — K8s provisioning outputs
- [tf] docs/how-to/k8s-terraform-ansible-provisioning/terraform/variables.tf — K8s provisioning variables
- [tf] docs/how-to/k8s-terraform-ansible-provisioning/terraform/workers.tf — K8s worker nodes
- [doc] docs/how-to/terraform-iam-roles.md — Reusable IAM roles
- [doc] docs/how-to/terraform-lambda-api-gateway.md — Serverless API with Lambda
- [doc] docs/how-to/terraform-module-composition-workspaces.md — Module composition and workspaces
- [doc] docs/how-to/terraform-multi-env-gitops.md — Multi-environment GitOps
- [doc] docs/how-to/terraform-rds-read-replicas.md — RDS with read replicas
- [doc] docs/how-to/terraform-secrets-manager.md — Secrets Manager integration
- [doc] docs/how-to/terraform-s3-cross-region-replication.md — S3 cross-region replication for DR
- [doc] docs/how-to/terraform-state-management.md — State management best practices
- [doc] docs/how-to/terraform-troubleshooting.md — Terraform troubleshooting
- [snippet] snippets/terraform-commands.md — Terraform CLI one-liners
- [template] templates/terraform/lambda-api-gateway/main.tf — Lambda + API Gateway module
- [template] templates/terraform/lambda-api-gateway/outputs.tf — Lambda + API Gateway outputs
- [template] templates/terraform/lambda-api-gateway/variables.tf — Lambda + API Gateway variables
- [template] templates/terraform/multi-env/vpc-module.tf — Multi-environment VPC module
- [template] templates/terraform/production-module-template.md — Production module template
- [template] templates/terraform/rds-with-replicas/main.tf — RDS with read replicas
- [template] templates/terraform/rds-with-replicas/monitoring.tf — RDS monitoring setup
- [template] templates/terraform/rds-with-replicas/outputs.tf — RDS outputs
- [template] templates/terraform/rds-with-replicas/provider.tf — RDS provider config
- [template] templates/terraform/rds-with-replicas/terraform.tfvars.example — RDS example vars
- [template] templates/terraform/rds-with-replicas/variables.tf — RDS variable definitions

## Ansible
- [script] scripts/bash/ansible_toolkit/patch-management.yml — Ansible patching playbook
- [script] scripts/bash/ansible_toolkit/security/aap-cve-2026-0598-check.sh — AAP Lightspeed auth bypass scanner
- [script] scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh — AAP wheel privilege escalation scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2025-14010-audit.sh — Sensitive variable exposure scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2025-9907-eda-creds.sh — EDA credentials exposure scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2026-0598-audit.sh — Lightspeed auth bypass scanner
- [script] scripts/bash/ansible_toolkit/security/cve-2026-33228-audit.sh — Flatted prototype pollution auditor
- [script] scripts/bash/ansible_toolkit/security/cve-2026-33228-execution.sh — CVE-2026-33228 mitigation playbook execution
- [script] scripts/bash/ansible_toolkit/security/cve-2026-33228-mitigation.yml — CVE-2026-33228 mitigation playbook
- [script] scripts/bash/ansible_toolkit/security/harden-ansible-cve-2026-33228.sh — Flatted prototype pollution hardening
- [script] scripts/bash/ansible_toolkit/security/vault-password-rotation.sh — Vault password rotation
- [doc] docs/how-to/ansible-cve-2026-33228-flatted.md — CVE-2026-33228 hardening guide
- [doc] docs/how-to/ansible-lightspeed-cve-2026-0598.md — CVE-2026-0598 remediation guide
- [doc] docs/how-to/ansible-playbook-best-practices.md — Playbook best practices
- [doc] docs/how-to/ansible_toolkit.md — Ansible toolkit usage guide
- [doc] docs/security/ansible/CVE-2026-33228.md — CVE-2026-33228 remediation guide
- [ansible] docs/how-to/k8s-terraform-ansible-provisioning/ansible/inventory.ini.example — K8s provisioning inventory
- [ansible] docs/how-to/k8s-terraform-ansible-provisioning/ansible/roles/preflight/tasks/main.yml — Preflight tasks for K8s
- [ansible] docs/how-to/k8s-terraform-ansible-provisioning/ansible/site.yml — K8s provisioning playbook
- [ansible] docs/how-to/k8s-terraform-ansible-provisioning/ansible/teardown.yml — K8s teardown playbook
- [doc] docs/runbooks/cve-2026-33228-ansible-flatted.md — CVE-2026-33228 remediation runbook
- [snippet] snippets/ansible-commands.md — Ansible ad-hoc commands

## Vault
- [note] vault/notes/0000-primer-vault.md — First-day primer on HashiCorp Vault (L1)
- [note] vault/notes/2026-06-05-install-vault-and-explore-cli.md — Installing Vault and exploring the CLI (L1)
- [script] scripts/bash/vault/security/vault-go-getter-hardening.sh — go-getter arbitrary file read hardening
- [script] scripts/bash/vault/vault-audit-log-analysis.sh — Vault audit log analysis
- [script] scripts/bash/vault_toolkit/security/cve-2025-11621.sh — AWS Auth bypass scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-5999.sh — Privilege escalation scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6000.sh — Plugin directory RCE scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6013.sh — LDAP MFA enforcement bypass scanner
- [script] scripts/bash/vault_toolkit/security/cve-2025-6037.sh — TLS certificate auth bypass scanner
- [doc] docs/how-to/vault-secure-deployment.md — Vault secure deployment guide
- [doc] docs/how-to/vault-troubleshooting-seal-unseal.md — Seal/unseal troubleshooting
- [doc] docs/how-to/vault_toolkit.md — Vault toolkit usage guide
- [doc] docs/troubleshooting/vault-seal-unseal.md — Vault seal/unseal issues
- [snippet] snippets/vault-commands.md — Vault CLI commands

## Observability
- [script] scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh — Alertmanager HA cluster setup
- [script] scripts/bash/observability_toolkit/grafana/health-check.sh — Grafana health check
- [script] scripts/bash/observability_toolkit/jaeger/query-traces.sh — Query Jaeger traces
- [script] scripts/bash/observability_toolkit/loki/loki-promtail-install.sh — Loki and Promtail installation
- [script] scripts/bash/observability_toolkit/loki/query-logs.sh — Query Loki logs with LogQL
- [script] scripts/bash/observability_toolkit/otel/collector-health.sh — OTel collector health
- [script] scripts/bash/observability_toolkit/otel/otel-collector-install.sh — OTel Collector installation
- [script] scripts/bash/observability_toolkit/prometheus/check-alert.sh — Check Prometheus alerts
- [script] scripts/bash/observability_toolkit/prometheus/query-metrics.sh — Execute PromQL queries
- [script] scripts/bash/observability_toolkit/prometheus/targets-status.sh — Prometheus targets health
- [script] scripts/bash/observability_toolkit/stack-health.sh — Full stack health check
- [doc] docs/how-to/observability/alertmanager-ha-clustering.md — Alertmanager HA clustering
- [doc] docs/how-to/observability/loki-promtail-installation.md — Loki Promtail installation
- [doc] docs/how-to/observability/otel-collector-installation.md — OTel Collector installation
- [doc] docs/how-to/observability_toolkit.md — Observability toolkit usage guide
- [doc] docs/how-to/thanos_installation.md — Thanos installation and configuration
- [doc] docs/how-to/observability/alertmanager-installation.md — Alertmanager installation and routing rules
- [doc] docs/how-to/observability/grafana-installation.md — Grafana installation and data source configuration
- [doc] docs/how-to/observability/prometheus-node-exporter-installation.md — Node exporter installation
- [doc] docs/how-to/linux-distributed-tracing-jaeger.md — Distributed tracing with Jaeger
- [snippet] snippets/observability-cheatsheet.md — PromQL, LogQL reference
- [script] scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh — Alertmanager automated install
- [script] scripts/bash/observability_toolkit/grafana/grafana-install.sh — Grafana automated install
- [script] scripts/bash/observability_toolkit/grafana/provisioning/dashboards/default.yml — Grafana default dashboard provisioning

## Docker
- [script] scripts/bash/docker_toolkit/docker-kaniko-cve-2026-28406-hardening.sh — Kaniko path traversal hardening
- [script] scripts/bash/docker_toolkit/security/docker-cve-2026-34040.sh — CVE-2026-34040 remediation
- [script] scripts/bash/docker_toolkit/docker-image-cleanup.sh — Docker image cleanup with age filtering
- [script] scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh — Docker Swarm cluster setup
- [script] scripts/bash/docker_toolkit/security/cve-2026-2664.sh — Docker Desktop grpcfuse privilege escalation
- [script] scripts/bash/docker_toolkit/security/cve-2026-28400.sh — Docker Model Runner privilege escalation
- [script] scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh — AuthZ plugin hardening
- [script] scripts/bash/docker_toolkit/security/docker-cve-2026-34040.sh — Docker authorization plugin bypass
- [doc] docs/how-to/docker-kaniko-cve-2026-28406.md — Kaniko path traversal remediation
- [doc] docs/how-to/docker-security-best-practices.md — Docker security hardening guide
- [doc] docs/how-to/docker-security.md — Docker comprehensive security guide
- [doc] docs/how-to/docker-swarm-cluster-installation.md — Docker Swarm cluster installation
- [doc] docs/security/docker/AUTHZ-PLUGIN-HARDENING.md — Docker AuthZ plugin hardening
- [doc] docs/security/docker/CVE-2026-34040.md — Docker CVE-2026-34040 remediation
- [snippet] snippets/docker-commands.md — Docker CLI snippets

## Helm
- [script] scripts/bash/helm_toolkit/helm-terraform/deploy-helm-terraform.sh — Helm + Terraform deployment
- [script] scripts/bash/helm_toolkit/security/cve-2025-53547-harden.sh — Chart.yaml code injection hardening
- [script] scripts/bash/helm_toolkit/security/cve-2025-53547.sh — Chart.yaml code injection scanner
- [doc] docs/how-to/helm-commands-reference.md — Helm CLI commands reference
- [doc] docs/how-to/helm-security-scanning.md — Helm security scanning guide
- [doc] docs/how-to/helm-terraform-fullstack/README.md — Helm + Terraform full-stack guide

## CI/CD
- [script] scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh — Buildkite agent installation
- [script] scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh — CircleCI runner installation
- [script] scripts/bash/ci_cd_toolkit/github/check-action-updates.sh — Check for outdated GitHub Actions
- [script] scripts/bash/ci_cd_toolkit/github/generate-workflow.sh — Generate starter workflows
- [script] scripts/bash/ci_cd_toolkit/github/lint-workflows.sh — Lint GitHub Actions workflows
- [script] scripts/bash/ci_cd_toolkit/github/pipeline-health.sh — Check pipeline health
- [script] scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh — Trivy supply chain compromise scanner
- [script] scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh — Trivy GitHub Actions workflow generator
- [script] scripts/bash/ci_cd_toolkit/github/validate-workflow.sh — Validate workflow syntax
- [script] scripts/bash/ci_cd_toolkit/jenkins/trivy-jenkins-integration.sh — Trivy Jenkins integration
- [script] scripts/bash/ci_cd_toolkit/trivy-cache-configure.sh — Trivy cache configuration
- [script] scripts/bash/ci_cd_toolkit/trivy-db-update.sh — Trivy database update automation
- [script] scripts/bash/ci_cd_toolkit/trivy-postbuild-scan.sh — Trivy post-build stage integration
- [script] scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh — Trivy severity-based filtering
- [script] scripts/bash/trivy_toolkit/security/cve-2026-33001.sh — Trivy CVE-2026-33001 path traversal
- [doc] docs/how-to/buildkite-installation.md — Buildkite agent installation and configuration
- [doc] docs/how-to/circleci-runner-installation.md — CircleCI runner installation
- [doc] docs/how-to/ci_cd_toolkit.md — CI/CD toolkit usage guide
- [doc] docs/how-to/trivy-cicd-integration.md — Trivy CI/CD pipeline integration
- [doc] docs/how-to/trivy-github-actions.md — Trivy GitHub Actions integration
- [doc] docs/how-to/trivy-jenkins-integration.md — Trivy Jenkins plugin integration
- [doc] docs/how-to/trivy-severity-filtering.md — Trivy severity-based filtering
- [doc] docs/how-to/trivy-cache-configuration.md — Trivy cache configuration
- [doc] docs/security/trivy/CVE-2026-33634.md — Trivy CVE-2026-33634 remediation guide
- [doc] docs/how-to/trivy/cve-2026-33001-remediation.md — Trivy CVE-2026-33001 remediation
- [script] scripts/bash/argo_toolkit/argo-workflows-install.sh — Argo Workflows automated install
- [script] scripts/bash/flux_toolkit/flux-install.sh — Flux v2 automated install
- [doc] docs/how-to/argo-workflows-installation.md — Argo Workflows installation and pipelines
- [doc] docs/how-to/fluxcd-installation.md — Flux v2 installation and GitOps reconciliation
- [snippet] snippets/ci-cd-cheatsheet.md — CI/CD commands reference

## OCI/Container Registries
- [script] scripts/bash/azure_toolkit/acr/acr-deploy.sh — ACR deployment with geo-replication
- [script] scripts/bash/harbor/harbor-backup.sh — Harbor backup script
- [script] scripts/bash/harbor/harbor-deploy.sh — Harbor deployment
- [script] scripts/bash/harbor/harbor-health-check.sh — Harbor health verification
- [script] scripts/bash/oci_registry_toolkit/auth/check-auth.sh — Auth diagnostics
- [script] scripts/bash/oci_registry_toolkit/registry/list-repos.sh — List repositories
- [script] scripts/bash/oci_registry_toolkit/registry/list-tags.sh — List tags for repo
- [script] scripts/bash/oci_registry_toolkit/tags/find-old-tags.sh — Find old/unused tags
- [script] scripts/bash/oci_registry_toolkit/tools/keepalive-pull-plan.sh — Generate keepalive pull plan
- [doc] docs/how-to/azure-container-registry-acr.md — Azure Container Registry ACR setup
- [doc] docs/how-to/github-container-registry-ghcr.md — GitHub Container Registry ghcr.io
- [doc] docs/how-to/linux-harbor-registry.md — Harbor container registry setup
- [doc] docs/how-to/oci-registry-toolkit/github-container-registry-ghcr.md — ghcr.io configuration
- [doc] docs/how-to/oci_registry_toolkit.md — OCI registry toolkit usage guide
- [script] scripts/bash/oci_registry_toolkit/gar/gar-deploy.sh — Google Artifact Registry deploy
- [script] scripts/bash/oci_registry_toolkit/quay/quay-deploy.sh — Quay container registry deploy
- [doc] docs/how-to/google-artifact-registry-gar.md — Google Artifact Registry setup
- [doc] docs/how-to/quay-container-registry-installation.md — Quay container registry installation
- [snippet] snippets/oci-registry-cheatsheet.md — Registry commands reference

## Git
- [script] scripts/bash/git/credential-helper-ci.sh — Credential helper configuration
- [script] scripts/bash/git/git-automation.sh — Git automation for CI/CD
- [script] scripts/bash/git/git-cicd-hooks.sh — CI/CD hooks
- [script] scripts/bash/git/git-install-macos.sh — macOS installation script
- [script] scripts/bash/git/git-install-wsl.sh — WSL installation script
- [script] scripts/bash/git/git-install.sh — Linux installation script
- [script] scripts/bash/git/git-pre-commit-hooks.sh — Pre-commit hook automation
- [script] scripts/bash/git/github-runner-install.sh — GitHub Actions runner installation
- [doc] docs/concepts/git-001-version-control-fundamentals.md — Introduction to version control fundamentals
- [doc] docs/concepts/git-002-basic-commands-setup.md — Basic Git commands and repository setup
- [doc] docs/concepts/git-003-workflow.md — Git workflow patterns
- [doc] docs/concepts/git-005-configuration-aliases.md — Git configuration, aliases, and best practices
- [doc] docs/concepts/git-version-control-mental-model.md — Architecture, repositories, branching, remote operations
- [doc] docs/how-to/git-cicd-automation.md — Git automation for CI/CD integration
- [doc] docs/how-to/git/git-credential-helper-cicd-setup.md — Credential helper for CI/CD pipelines
- [doc] docs/how-to/git-installation-macos.md — Git installation on macOS
- [doc] docs/how-to/git-installation-wsl.md — Git installation on WSL
- [doc] docs/how-to/git-installation.md — Git installation for Linux
- [doc] docs/how-to/git-pre-commit-security-scanning.md — Pre-commit security scanning
- [doc] docs/how-to/git-workflow-optimization.md — Git workflow optimization for DevOps
- [doc] docs/reference/git-advanced-commands.md — Git advanced command patterns
- [doc] docs/reference/git-commands.md — Git command patterns
- [doc] docs/security/git-security-access-control-authentication.md — Git access control and authentication hardening
- [doc] docs/setup-guides/git-credential-helper-ci-cd.md — Credential helper setup guide
- [doc] docs/setup-guides/git-github-actions-runner.md — GitHub Actions runner setup
- [snippet] snippets/git-commands.md — Git CLI commands reference

## Checkov
- [note] checkov/notes/0000-primer-checkov.md — First-day primer on Checkov (L1)
- [note] checkov/notes/2026-05-25-scan-terraform-plan.md — Scanning a Terraform plan for misconfigurations (L1)
- [note] checkov/notes/2026-05-26-cli-vs-sdk-comparison.md — CLI vs SDK scanning approaches (L1)
- [note] checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md — Quickstart walkthrough and common pitfalls (L1)
- [snippet] checkov/snippets/scan-kubernetes.sh — Scan Kubernetes manifests with Checkov
- [snippet] checkov/snippets/scan-terraform-dir.py — Python SDK scan of Terraform directory
- [snippet] checkov/snippets/scan-a-terraform-file.py — Scan a single Terraform file with Checkov SDK
- [config] checkov/configs/checkov-skip-severity-config.yaml — Skip and severity configuration for Checkov
- [config] checkov/configs/checkov-ci-config.yaml — CI pipeline config with framework selection
- [manifest] checkov/manifests/checkov-sarif-pr-blocking.yaml — SARIF scan results PR gate workflow
- [notebook] checkov/notebooks/compare-static-vs-plan-scanning.ipynb — Compare static vs plan scanning with Checkov
- [snippet] checkov/snippets/terraform-scan-custom-policies.py — Terraform scanning project with custom Checkov policies
- [doc] checkov/docs/pre-commit-hook-with-version-pinning.md — Pre-commit hook with version pinning for Checkov
- [policy] checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml — Custom policy to deny public S3 buckets

## Semgrep
- [note] semgrep/notes/0000-primer-semgrep.md — First-day primer on Semgrep (L1)
- [note] semgrep/notes/2026-05-25-install-semgrep.md — Installing Semgrep and first SAST scan (L1)
- [note] semgrep/notes/2026-05-26-install-semgrep-pitfalls.md — Installation pitfalls and first scan gotchas (L1)
- [snippet] semgrep/snippets/first-custom-rule.yaml — Custom rule to detect dangerous subprocess patterns (L1)
- [snippet] semgrep/snippets/catch-privileged-containers.yaml — Custom rule to catch privileged container configurations
- [doc] semgrep/docs/github-actions-ci-from-scratch.md — Building a Semgrep CI pipeline from scratch with GitHub Actions
- [doc] semgrep/docs/semgrep-ci-integration.md — Integrating Semgrep into CI/CD pipelines
- [script] semgrep/scripts/detect-hardcoded-secrets.py — Python script to detect hardcoded secrets using Semgrep
- [script] semgrep/scripts/scan-python-codebase.sh — Scan a Python codebase with custom Semgrep rules
- [config] semgrep/configs/multi-rule-pack.yaml — Multi-rule Semgrep pack with operator combinators
- [notebook] semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb — Compare semgrep scan vs semgrep ci approaches
- [doc] semgrep/docs/comparing-rule-writing-approaches.md — Pattern vs pattern-inside vs pattern-either approaches
- [manifest] semgrep/manifests/diff-aware-semgrep-ci.yaml — Diff-aware Semgrep CI pipeline workflow
- [dockerfile] semgrep/dockerfiles/custom-scanning-image.Dockerfile — Custom Semgrep scanning Docker image
- [dockerfile] semgrep/dockerfiles/ci-entrypoint.sh — Entrypoint script for Semgrep scanning image

## Trivy
- [note] trivy/notes/0000-primer-trivy.md — First-day primer on Trivy (L1)
- [note] trivy/notes/2026-05-24-install-trivy.md — Installing Trivy and first vulnerability scan (L1)
- [note] trivy/notes/2026-05-26-trivy-quickstart.md — Official quickstart walkthrough (L2)
- [snippet] trivy/snippets/scan-docker-image.sh — Scan a Docker image with severity filtering (L1)
- [script] trivy/scripts/container-vuln-scan.sh — Container image scan with CRITICAL gating (L2)
- [script] trivy/scripts/compose-multi-scan.sh — Scan multi-service Docker Compose deployments with Trivy
- [script] trivy/scripts/multi-target-scanner.sh — Multi-target scanner (image/fs/repo)
- [config] trivy/configs/trivy-scan-config.yaml — Configuration for targeted scanning (L2)
- [config] trivy/configs/.trivy.yaml — Trivy project-level default configuration
- [doc] trivy/docs/ci-pipeline-sarif-output.md — CI pipeline with SARIF output integration
- [doc] trivy/docs/ci-cd-pipeline-recipes.md — CI/CD pipeline recipes for Trivy
- [notebook] trivy/notebooks/trivy-sarif-output-processing.ipynb — Trivy SARIF output processing and analysis
- [script] trivy/scripts/image-vuln-pipeline.sh — Automated image vulnerability scanning pipeline
- [dockerfile] trivy/dockerfiles/custom-policies.Dockerfile — Custom policies scanning Docker image

## Trivy Templates
- [template] trivy/templates/trivy-monorepo-scanner/Makefile — Monorepo scanner Makefile
- [template] trivy/templates/trivy-monorepo-scanner/README.md — Monorepo scanner usage guide
- [template] trivy/templates/trivy-monorepo-scanner/trivy.yaml — Monorepo scanner Trivy config
- [template] trivy/templates/trivy-monorepo-scanner/.trivyignore — Monorepo scanner ignore rules
- [template] trivy/templates/trivy-monorepo-scanner/.github/workflows/ci-scan.yml — Monorepo scanner CI workflow
- [template] trivy/templates/trivy-monorepo-scanner/scripts/scan-all.sh — Monorepo scanner entrypoint

## Syft
- [note] syft/notes/0000-primer-syft.md — First-day primer on Syft SBOM generation (L1)
- [note] syft/notes/2026-05-27-install-syft-first-sbom.md — Installing Syft and generating the first SBOM (L1)
- [snippet] syft/snippets/tried-sbom-formats.sh — Generate SPDX and CycloneDX SBOMs with Syft (L1)
- [note] syft/notes/2026-05-29-syft-quickstart-trip-ups.md — Quickstart walkthrough and common pitfalls (L1)
- [note] syft/notes/2026-05-30-sbom-format-comparison.md — CycloneDX vs SPDX vs Syft JSON format comparison (L1)
- [script] syft/scripts/gen-multi-format-sboms.sh — Generate SBOMs in all supported Syft formats
- [script] syft/scripts/multi-image-sbom-pipeline.sh — Multi-image SBOM generation pipeline
- [config] syft/configs/.syft.yaml — Syft project-level configuration

## Grype
- [note] grype/notes/0000-primer-grype.md — First-day primer on Grype (L1)
- [note] grype/notes/2026-05-31-install-grype.md — Installing Grype and running the first scan (L1)
- [note] grype/notes/2026-06-04-grype-quickstart-trip-ups.md — Quickstart walkthrough and common pitfalls (L1)
- [snippet] grype/snippets/my-first-grype-commands.sh — First Grype commands reference
- [script] grype/scripts/minimal-grype-scan.sh — Minimal Grype vulnerability scanning script

## CodeQL
- [note] codeql/notes/0000-primer-codeql.md — First-day primer on CodeQL (L1)
- [note] codeql/notes/2026-06-05-install-codeql-first-analysis.md — Installing CodeQL and running first analysis (L1)
- [snippet] codeql/snippets/find-hardcoded-creds.ql — Custom query for hardcoded credentials in Python
- [snippet] codeql/snippets/my-first-codeql-commands.sh — First CodeQL CLI commands reference
- [config] codeql/configs/first-codeql-analysis.yml — Starter GitHub Actions workflow for CodeQL

## ZAP
- [note] zap/notes/0000-primer-zap.md — First-day primer on OWASP ZAP (L1)
- [note] zap/notes/2026-06-06-install-zap-desktop-ui.md — Installing ZAP and exploring the desktop UI (L1)
- [note] zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md — Quickstart walkthrough and UI gotchas (L1)
- [snippet] zap/snippets/my-first-zap-baseline-scan.sh — First ZAP baseline scan from the CLI
- [snippet] zap/snippets/authenticated-scan-with-context.sh — Authenticated scan using ZAP context
- [note] zap/notes/2026-06-13-spider-scan-test-app.md — Spider scan against a test app (L1)
- [snippet] zap/snippets/my-first-zap-spider-scan.sh — First ZAP spider scan via API
- [script] zap/scripts/dast-workflow-from-scratch.sh — Full ZAP DAST workflow from spider to active scan
- [doc] zap/docs/zap-integration-patterns.md — ZAP integration patterns for web app security testing

## TruffleHog
- [note] trufflehog/notes/0000-primer-trufflehog.md — First-day primer on TruffleHog (L1)
- [note] trufflehog/notes/2026-05-27-install-trufflehog.md — Installing TruffleHog and scanning a repo (L1)
- [note] trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md — Walkthrough of the TruffleHog quickstart (L1)
- [snippet] trufflehog/snippets/fake-secrets-test.sh — Test TruffleHog detection with fake secrets (L1)
- [snippet] trufflehog/snippets/scan-github-repo-for-secrets.sh — Scan a GitHub repository for leaked secrets (L1)
- [config] trufflehog/configs/trufflehog-custom-regex-config.yaml — Custom regex and entropy configuration (L1)
- [config] trufflehog/configs/custom-detector-rules.yaml — Custom detector rules for proprietary secret patterns
- [script] trufflehog/scripts/multi-repo-scan-pipeline.sh — Multi-repo secret scanning pipeline
- [script] trufflehog/scripts/pre-commit-scan-pipeline.sh — Pre-commit secret scanning pipeline
- [doc] trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md — Comparing git, filesystem, and S3 scan modes
- [notebook] trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb — Analyzing false positives and severity tuning

## Lab Projects
- [doc] lab/mini-projects/postgresql-database-server/README.md — PostgreSQL 16 with replication
- [doc] lab/mini-projects/samba-enterprise-file-sharing/README.md — Enterprise Samba file sharing
- [doc] lab/mini-projects/terraform-project/README.md — Terraform project with modules
- [tf] lab/mini-projects/terraform-project/main.tf — Terraform project main
- [tf] lab/mini-projects/terraform-project/modules/compute/main.tf — Compute module
- [tf] lab/mini-projects/terraform-project/modules/network/main.tf — Network module
- [tf] lab/mini-projects/terraform-project/modules/storage/main.tf — Storage module
- [tf] lab/mini-projects/terraform-project/outputs.tf — Project outputs
- [tf] lab/mini-projects/terraform-project/variables.tf — Project variables
- [tf] lab/mini-projects/terraform-project/workspace.tf — Workspace configuration

## Environments (Terraform)
- [env] environments/dev/main.tf — Development environment Terraform
- [env] environments/dev/outputs.tf — Development outputs
- [env] environments/dev/terraform.tfvars — Development variables
- [env] environments/dev/variables.tf — Development variable definitions
- [env] environments/prod/main.tf — Production environment Terraform
- [env] environments/prod/outputs.tf — Production outputs
- [env] environments/prod/terraform.tfvars — Production variables
- [env] environments/prod/variables.tf — Production variable definitions
- [env] environments/staging/main.tf — Staging environment Terraform
- [env] environments/staging/outputs.tf — Staging outputs
- [env] environments/staging/terraform.tfvars — Staging variables
- [env] environments/staging/variables.tf — Staging variable definitions

## Terraform Modules
- [module] terraform/eventbridge-lambda/main.tf — EventBridge Lambda module
- [module] terraform/eventbridge-lambda/environments/dev.tfvars — Dev environment vars
- [module] terraform/eventbridge-lambda/modules/eventbridge/outputs.tf — EventBridge module outputs
- [module] terraform/eventbridge-lambda/modules/eventbridge/variables.tf — EventBridge module variables
- [module] terraform/eventbridge-lambda/modules/lambda/outputs.tf — Lambda module outputs
- [module] terraform/eventbridge-lambda/modules/lambda/variables.tf — Lambda module variables
- [module] terraform/eventbridge-lambda/variables.tf — Root variables
- [module] scripts/bash/terraform_toolkit/networking/terraform/main.tf — VPC networking module
- [module] scripts/bash/terraform_toolkit/networking/terraform/variables.tf — VPC module variables

## Cosign
- [note] cosign/notes/0000-primer-cosign.md — First-day primer on Cosign container image signing (L1)
- [note] cosign/notes/2026-06-13-install-cosign-sign-first-image.md — Installing Cosign and signing the first image (L1)
- [script] cosign/scripts/verify-signed-image.sh — Verify a signed container image

## Falco
- [note] falco/notes/0000-primer-falco.md — First-day primer on Falco runtime security (L1)
- [note] falco/notes/2026-06-10-install-falco-first-detection.md — Installing Falco and running first detection (L1)
- [config] falco/configs/first-custom-rule-detect-shell-in-container.yaml — Custom rule to detect shell in container
- [config] falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml — First custom Falco rule snapshot

## OPA
- [note] opa/notes/0000-primer-opa.md — First-day primer on OPA policy engine (L1)
- [note] opa/notes/2026-06-06-install-opa-repl.md — Installing OPA and exploring the REPL (L1)
- [snippet] opa/snippets/my-first-opa-policy-eval.sh — First OPA policy evaluation
- [snippet] opa/snippets/enforce-image-registry-constraints.rego — Rego policy enforcing image registry constraints

## Snyk
- [note] snyk/notes/0000-primer-snyk.md — First-day primer on Snyk (L1)
- [note] snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md — Snyk quickstart walkthrough (L1)
- [note] snyk/notes/2026-06-08-install-snyk-first-test.md — Installing Snyk CLI and running first project test (L1)
- [snippet] snyk/snippets/my-first-snyk-commands.sh — First Snyk CLI commands reference

## GitGuardian
- [note] gitguardian/notes/0000-primer-gitguardian.md — First-day primer on GitGuardian (L1)
- [note] gitguardian/notes/2026-06-07-first-ggshield-scan.md — Installing ggshield and running first scan (L1)
- [note] gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md — Quickstart walkthrough and common pitfalls (L1)
- [snippet] gitguardian/snippets/my-first-ggshield-commands.sh — First ggshield commands reference
- [snippet] gitguardian/snippets/custom-policy-engine-ggshield.sh — Custom policy engine with ggshield
- [config] gitguardian/configs/.ggshield.yaml — ggshield scheduled scanning configuration