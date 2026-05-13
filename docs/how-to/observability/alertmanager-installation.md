# Alertmanager Installation and Routing Rule Configuration for Alert Management

---
SQUIRREL:
  title: "Alertmanager Installation and Routing Rule Configuration for Alert Management"
  category: "observability"
  tags: ["alertmanager", "prometheus", "alerting", "routing", "notification", "observability", "pagerduty", "slack", "email"]
  last_verified: "2026-05-13"
  version: "Alertmanager 0.27.0"
---

## Purpose

This guide provides steps to install and configure Alertmanager for alert routing, deduplication, and notification management. It covers installation via automated script or manual package installation, routing rule configuration with receivers for multiple notification channels (email, Slack, PagerDuty, webhook), and integration with Prometheus alert evaluation.

## When to use

- When you need to route Prometheus alerts to different notification channels
- When setting up alert deduplication and grouping to reduce notification noise
- When configuring inhibition rules to suppress related alerts
- When integrating with incident management systems (PagerDuty, OpsGenie)
- When automating alert routing based on severity, team, or service labels

## Prerequisites

- Linux server (Ubuntu 20.04+, RHEL 8+, Debian 11+, AlmaLinux 9+)
- Root or sudo privileges for installation
- Prometheus already installed and configured (port 9090)
- 512MB+ RAM recommended for Alertmanager
- Ports available: 9093 (HTTP API), 9094 (cluster/gossip for HA)
- curl and wget available

## Installation

### Option 1: Automated Installation Script

Use the provided deployment script for automated installation:

```bash
# Download and run Alertmanager installation script (dry-run)
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh | bash -s -- --dry-run

# Actual installation (requires root)
sudo curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh | sudo bash -s -- --version 0.27.0 --http-port 9093

# Install with custom notification config
sudo curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh | sudo bash -s -- --receiver-config /path/to/receivers.yml
```

### Option 2: Manual Package Installation (Debian/Ubuntu)

#### Install Alertmanager via APT

```bash
# Download and extract
VERSION="0.27.0"
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) ARCH="386" ;;
esac

curl -fsSL "https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager_${VERSION}_linux_${ARCH}.tar.gz" -o /tmp/alertmanager.tar.gz

# Extract and install
sudo mkdir -p /opt/alertmanager
sudo tar -xzf /tmp/alertmanager.tar.gz -C /opt/alertmanager --strip-components=1
rm /tmp/alertmanager.tar.gz

# Create alertmanager user
sudo useradd --system --no-create-home --shell /usr/sbin/nologin alertmanager

# Create directories
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
sudo chown -R alertmanager:alertmanager /opt/alertmanager /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
```

### Option 3: Docker Installation

```bash
docker run -d \
  --name=alertmanager \
  -p 9093:9093 \
  -p 9094:9094 \
  -v alertmanager-data:/alertmanager \
  quay.io/prometheus/alertmanager:v0.27.0 \
  --config.file=/alertmanager/alertmanager.yml \
  --storage.path=/alertmanager
```

## Configuration

### Alertmanager Configuration (alertmanager.yml)

Create the main configuration file:

```bash
sudo mkdir -p /etc/alertmanager
```

```yaml
# /etc/alertmanager/alertmanager.yml
global:
  resolve_timeout: 5m
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@example.com'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'team-notifications'
  routes:
    - match:
        severity: critical
      receiver: 'critical-alerts'
      continue: true
    - match:
        severity: warning
      receiver: 'warning-alerts'
    - match:
        team: platform
      receiver: 'platform-team'
      group_by: ['service', 'team']

receivers:
  - name: 'team-notifications'
    email_configs:
      - to: 'devops@example.com'
        send_resolved: true
        headers:
          subject: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
    webhook_configs:
      - url: 'https://internal.example.com/alerts'
        send_resolved: true

  - name: 'critical-alerts'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#critical-alerts'
        send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_KEY'
        severity: critical
        description: '{{ .GroupLabels.alertname }}'
        details:
          cluster: '{{ .GroupLabels.cluster }}'
          service: '{{ .GroupLabels.service }}'

  - name: 'warning-alerts'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#warning-alerts'
        send_resolved: true

  - name: 'platform-team'
    email_configs:
      - to: 'platform@example.com'
        send_resolved: true

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']
  - source_match:
      alertname: 'K8sPodNotReady'
    target_match:
      alertname: 'K8sDeploymentReady'
    equal: ['namespace', 'deployment']

templates:
  - '/etc/alertmanager/templates/*.tmpl'
```

### Template Configuration (Optional)

Create custom notification templates:

```bash
sudo mkdir -p /etc/alertmanager/templates
```

```go
{{ define "slack.default.title" }}
[{{ .Status | toUpper | toEmoji }}] {{ .GroupLabels.alertname }}
{{ end }}

{{ define "slack.default.text" }}
{{ range .Alerts }}
*Alert:* {{ .Labels.alertname }}
*Severity:* {{ .Labels.severity }}
*Description:* {{ .Annotations.description }}
*Details:*
  {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
  {{ end }}
{{ end }}
{{ end }}

{{ define "emoji.level" }}{{ if eq .Status "firing" }}{{ if eq .Labels.severity "critical" }}🔴{{ else }}🟡{{ end }}{{ else }}✅{{ end }}{{ end }}
```

### Systemd Service

```bash
sudo tee /etc/systemd/system/alertmanager.service > /dev/null <<'EOF'
[Unit]
Description=Alertmanager Alert Routing Service
After=network.target

[Service]
Type=simple
User=alertmanager
Group=alertmanager
ExecStart=/opt/alertmanager/alertmanager \
    --config.file=/etc/alertmanager/alertmanager.yml \
    --storage.path=/var/lib/alertmanager \
    --web.listen-address=0.0.0.0:9093 \
    --cluster.listen-address=0.0.0.0:9094 \
    --log.level=info
Restart=always
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/alertmanager /etc/alertmanager

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager
```

## Prometheus Integration

### Configure Prometheus to send alerts to Alertmanager

Update your Prometheus configuration:

```yaml
# /etc/prometheus/prometheus.yml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - localhost:9093
          # For HA setup:
          # - alertmanager-node-1:9093
          # - alertmanager-node-2:9093
          # - alertmanager-node-3:9093

rule_files:
  - '/etc/prometheus/rules/*.yml'
```

### Example Alert Rules

```yaml
# /etc/prometheus/rules/alerts.yml
groups:
  - name: instance_alerts
    interval: 30s
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
          team: platform
        annotations:
          summary: "Instance {{ $labels.instance }} is down"
          description: "{{ $labels.instance }} has been down for more than 5 minutes"

      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for more than 10 minutes"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) < 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk space low on {{ $labels.instance }}"
          description: "Disk space is below 10%"
```

## Verify

### Check Service Status

```bash
# Service status
sudo systemctl status alertmanager

# Health check API
curl -s http://localhost:9093/api/v1/status | jq .

# Check configuration
curl -s http://localhost:9093/api/v1/status | jq '.config'
```

Expected output:
```json
{
  "status": "success",
  "data": {
    "config": {
      "route": {
        "receiver": "team-notifications"
      }
    }
  }
}
```

### Test Alert Routing

```bash
# View active alerts
curl -s http://localhost:9093/api/v1/alerts | jq .

# Check silences
curl -s http://localhost:9093/api/v1/silences | jq .

# Get cluster status (if using HA)
curl -s http://localhost:9093/api/v1/status/peers | jq .
```

### Verify Prometheus Connection

```bash
# Check Prometheus can reach Alertmanager
curl -s http://localhost:9090/api/v1/alertmanagers | jq '.status'

# Expected: {"status": "success", "data": {"activeAlertmanagers": [...]}}
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Failed to load configuration` | Invalid YAML syntax | Validate with: `amtool check-config /etc/alertmanager/alertmanager.yml` |
| `No receivers configured` | Empty receivers section | Ensure at least one receiver is defined |
| `Alertmanager unreachable` | Prometheus can't connect | Check firewall: `ss -tlnp \| grep 9093` |
| `Template not found` | Template path incorrect | Check `templates:` section in config |
| `Email not sent` | SMTP not configured | Verify `global.smtp_smarthost` is set |
| `Slack webhook failed` | Invalid webhook URL | Test with: `curl -X POST -d '{"text":"test"}' <webhook_url>` |
| `High memory usage` | Too many alerts in flight | Adjust `group_interval` and `repeat_interval` |

## Rollback

### Stop and Remove Alertmanager

```bash
# Stop service
sudo systemctl stop alertmanager
sudo systemctl disable alertmanager
sudo rm /etc/systemd/system/alertmanager.service
sudo systemctl daemon-reload

# Remove files
sudo rm -rf /opt/alertmanager /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager

# Remove user
sudo userdel alertmanager 2>/dev/null || true
```

## Security Hardening

### Enable Authentication

```yaml
# Add to alertmanager.yml
web:
  http_address: "0.0.0.0:9093"
  # Enable basic auth
  basic_auth_users:
    admin: <hashed_password>
```

Generate password hash:
```bash
echo -n "password" | htpasswd -i -c -B user  # or use bcrypt
```

### TLS Configuration

```yaml
# Add to alertmanager.yml
tls_server_config:
  cert_file: /etc/alertmanager/ssl/cert.pem
  key_file: /etc/alertmanager/ssl/key.pem

tls_client_config:
  ca_file: /etc/alertmanager/ssl/ca.pem
```

### Webhook Authentication

```yaml
webhook_configs:
  - url: 'https://example.com/webhook'
    # Optional: send basic auth
    auth_config:
      username: 'alertmanager'
      password: 'secret'
```

## Alert Routing Best Practices

1. **Use grouping effectively**: Group by meaningful labels to reduce notification noise
2. **Set appropriate timeouts**: `group_wait` (30s) and `group_interval` (5m) balance between timely and grouped alerts
3. **Configure inhibition rules**: Suppress related alerts to avoid alert storms
4. **Use continue wisely**: Use `continue: true` to match multiple routes
5. **Implement severity levels**: Separate critical from warning alerts
6. **Test routing rules**: Use amtool to validate configuration before deployment
7. **Monitor Alertmanager itself**: Add alerts for Alertmanager downtime

```bash
# Test configuration
amtool check-config /etc/alertmanager/alertmanager.yml

# Check routing tree
amtool config routes show --config.file=/etc/alertmanager/alertmanager.yml
```

## References

- [Alertmanager Official Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)
- [Alertmanager Configuration](https://prometheus.io/docs/alerting/latest/configuration/)
- [Prometheus Alerting](https://prometheus.io/docs/alerting/latest/)
- [Alertmanager Docker Image](https://quay.io/prometheus/alertmanager)
- [amtool CLI](https://prometheus.io/docs/alerting/latest/alertmanager/#amtool)
- [PagerDuty Integration](https://www.pagerduty.com/docs/guides/prometheus-integration/)
- [Slack Webhook Configuration](https://api.slack.com/messaging/webhooks)