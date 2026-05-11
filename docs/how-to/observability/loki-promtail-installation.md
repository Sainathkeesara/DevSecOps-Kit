# Grafana Loki Promtail Installation and Log Pipeline Configuration

---
SQUIRREL:
  title: "Grafana Loki Promtail Installation and Log Pipeline Configuration"
  category: "observability"
  tags: ["loki", "promtail", "grafana", "log-aggregation", "log-pipeline", "centralized-logging", "observability"]
  last_verified: "2026-05-11"
  version: "Loki 3.2.0, Promtail 3.2.0"
---

## Purpose

This guide provides steps to install and configure Grafana Loki with Promtail for centralized log aggregation and pipeline configuration. It covers single-node and multi-node deployments, Promtail log collection from various sources (files, syslog, journal, Docker), Loki configuration for storage and retention, and integration with Grafana for log visualization and alerting.

## When to use

- Centralizing logs from multiple Linux servers into a single queryable store
- Building a centralized logging infrastructure for microservices
- Implementing log-based alerting and monitoring workflows
- Replacing traditional syslog/rsyslog setups with a modern Loki/Promtail stack
- Creating audit trails and compliance logging for security analysis
- Querying and visualizing application logs alongside metrics and traces

## Prerequisites

- Linux servers (Ubuntu 20.04+, RHEL 8+, Debian 11+, AlmaLinux 9+)
- Root or sudo privileges for installation
- 10GB+ free disk space for log storage (adjust based on log volume)
- Network connectivity between Promtail agents and Loki server
- Basic understanding of systemd and log management
- Grafana installed for visualization (recommended)
- curl and wget available on all target systems

## Installation

### Option 1: Automated Installation Script

Use the provided deployment script for automated installation:

```bash
# Install as standalone (Loki + Promtail on same host)
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/loki/loki-promtail-install.sh | bash -s -- --mode standalone

# Dry-run preview
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/loki/loki-promtail-install.sh | bash -s -- --dry-run --mode standalone

# Install Loki server only (for multi-node)
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/loki/loki-promtail-install.sh | bash -s -- --mode server

# Install Promtail client only (connects to remote Loki)
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/loki/loki-promtail-install.sh | bash -s -- --mode client --loki-server loki.company.com

# Specify versions
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/loki/loki-promtail-install.sh | bash -s -- --loki-version 3.1.0 --promtail-version 3.1.0 --mode standalone
```

### Option 2: Manual Package Installation (Debian/Ubuntu)

#### Install Loki (Server)

```bash
# Download Loki package
curl -sL https://github.com/grafana/loki/releases/download/v3.2.0/loki_3.2.0_amd64.deb -o /tmp/loki.deb
sudo dpkg -i /tmp/loki.deb

# Verify loki user was created
id loki
# Expected: uid=... gid=... groups=...

# Create required directories
sudo mkdir -p /var/lib/loki /etc/loki /var/log/loki

# Set correct ownership
sudo chown -R loki:loki /var/lib/loki /var/log/loki /etc/loki
```

#### Install Promtail (Client)

```bash
# Download Promtail package
curl -sL https://github.com/grafana/loki/releases/download/v3.2.0/promtail_3.2.0_amd64.deb -o /tmp/promtail.deb
sudo dpkg -i /tmp/promtail.deb

# Verify promtail user was created
id promtail
```

### Option 3: Manual Binary Installation

#### Install Loki from Binary

```bash
# Create loki system user first
if ! id loki &>/dev/null; then
    sudo useradd -r -s /bin/false -M -d /nonexistent loki
fi

# Download and install Loki binary
cd /tmp
wget -q https://github.com/grafana/loki/releases/download/v3.2.0/loki-linux-amd64.zip
unzip -o loki-linux-amd64.zip

# Install binary with correct ownership
sudo install -o loki -g loki -m 0755 loki-linux-amd64 /usr/local/bin/loki

# Create directories with correct ownership
sudo mkdir -p /var/lib/loki /etc/loki /var/log/loki
sudo chown -R loki:loki /var/lib/loki /var/log/loki /etc/loki
```

#### Install Promtail from Binary

```bash
# Create promtail system user first
if ! id promtail &>/dev/null; then
    sudo useradd -r -s /bin/false -M -d /nonexistent promtail
fi

# Download and install Promtail binary
cd /tmp
wget -q https://github.com/grafana/loki/releases/download/v3.2.0/promtail-linux-amd64.zip
unzip -o promtail-linux-amd64.zip

# Install binary with correct ownership
sudo install -o promtail -g promtail -m 0755 promtail-linux-amd64 /usr/local/bin/promtail

# Create directories with correct ownership
sudo mkdir -p /var/lib/promtail /etc/promtail /var/log/promtail
sudo chown -R promtail:promtail /var/lib/promtail /var/log/promtail /etc/promtail
```

## Loki Configuration

Create the Loki configuration file with filesystem storage:

```bash
sudo tee /etc/loki/local-config.yaml > /dev/null << 'EOF'
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  path_prefix: /var/lib/loki
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules
  replication_factor: 1
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 50
  ingestion_burst_size_mb: 100

schema_config:
  configs:
    - from: 2024-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v12
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb:
    directory: /var/lib/loki/index
  filesystem:
    directory: /var/lib/loki/chunks

chunk_store_config:
  max_look_back_period: 720h

table_manager:
  retention_deletes_enabled: true
  retention_period: 720h
EOF

sudo chown loki:loki /etc/loki/local-config.yaml
sudo chmod 0644 /etc/loki/local-config.yaml
```

### Loki with Object Storage (S3/GCS/Azure)

```yaml
# For AWS S3
storage_config:
  aws:
    bucketnames: your-bucket-name
    region: us-east-1
    s3forcepathstyle: true
  boltdb:
    directory: /var/lib/loki/index

common:
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
    s3:
      s3: s3://access_key:secret_key@bucket_name/loki

# For Google Cloud Storage
common:
  storage:
    gcs:
      bucket_name: your-bucket-name
```

## Promtail Configuration

Create the Promtail configuration file to collect logs:

```bash
sudo tee /etc/promtail/promtail-config.yaml > /dev/null << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 9081

clients:
  - url: http://LOKI_SERVER_HOSTNAME:3100/loki/api/v1/push
    retry_interval: 5s
    batch_timeout: 10s
    external_labels:
      environment: production
      datacenter: dc1

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: system_logs
          host: __HOSTNAME__
          __path__: /var/log/*.log

  - job_name: auth_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: auth
          host: __HOSTNAME__
          __path__: /var/log/auth.log

  - job_name: syslog
    syslog:
      listen_address: 0.0.0.0:514
      labels:
        job: syslog
        host: __HOSTNAME__

  - job_name: journal
    journal:
      path: /var/log/journal
      labels:
        job: systemd
        host: __HOSTNAME__

  - job_name: docker
    docker_targets:
      - containers
    labels:
      job: docker
      host: __HOSTNAME__

  - job_name: application_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: app-logs
          host: __HOSTNAME__
        __path__: /var/log/application/*.log
EOF

sudo chown promtail:promtail /etc/promtail/promtail-config.yaml
sudo chmod 0644 /etc/promtail/promtail-config.yaml

# Replace placeholders
sudo sed -i "s/__HOSTNAME__/$(hostname)/g" /etc/promtail/promtail-config.yaml
# Note: Manually replace LOKI_SERVER_HOSTNAME with your Loki server's hostname or IP
```

## Systemd Services

### Loki Service

```bash
sudo tee /etc/systemd/system/loki.service > /dev/null << 'EOF'
[Unit]
Description=Loki Log Aggregator
After=network.target

[Service]
Type=simple
User=loki
Group=loki
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/local-config.yaml
Restart=on-failure
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/loki /var/log/loki /etc/loki

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki
```

### Promtail Service

```bash
sudo tee /etc/systemd/system/promtail.service > /dev/null << 'EOF'
[Unit]
Description=Promtail Log Shipper
After=network.target

[Service]
Type=simple
User=promtail
Group=promtail
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/promtail-config.yaml
Restart=on-failure
RestartSec=10
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/promtail /var/log/promtail /var/log /etc/promtail

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail
```

## Log Rotation

Prevent disk space issues with log rotation:

```bash
sudo tee /etc/logrotate.d/loki > /dev/null << 'EOF'
/var/log/loki/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 loki loki
    sharedscripts
    postrotate
        /bin/kill -HUP $(cat /run/loki/loki.pid 2>/dev/null) || true
    endscript
}
EOF

sudo tee /etc/logrotate.d/promtail > /dev/null << 'EOF'
/var/log/promtail/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 promtail promtail
}
EOF
```

## Grafana Integration

Connect Loki to Grafana for visualization:

1. Open Grafana: `http://grafana-server:3000`
2. Navigate to **Configuration** → **Data Sources**
3. Click **Add data source** → Select **Loki**
4. Set URL: `http://loki-server:3100`
5. Click **Save & Test**

## LogQL Queries

Example LogQL queries for log exploration:

```logql
# All logs from a specific host
{host="web-server-01"}

# Error logs only
{job="app-logs"} |= "ERROR"

# Filter by multiple terms (AND)
{job="system_logs"} |= "failed" |= "authentication"

# Filter by regex
{job="app-logs"} |~ "request_id=[a-f0-9]+"

# Rate of errors over time
rate({job="app-logs"} |= "ERROR"[5m])

# Count by log level
count_over_time({job="app-logs"}[1h])

# Top hosts by log volume
topk(10, sum by (host) (rate({job="system_logs"}[5m])))

# 99th percentile latency
quantile_over_time(0.99, {job="app-logs"} | json | latency_ms > 0 [5m])
```

## Alerting

Create alert rules in Grafana:

```yaml
# alerting-rules.yaml
groups:
  - name: loki_alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate({job="app-logs"} |= "ERROR"[5m]))
          / sum(rate({job="app-logs"}[5m])) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is above 10% for the past 5 minutes"

      - alert: MissingLogs
        expr: |
          absent({job="app-logs"}) > 10m
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "No logs received from app-logs"
          description: "No log entries received for more than 10 minutes"
```

## Verification

### Check Loki Status

```bash
# Check Loki is ready
curl -s http://localhost:3100/ready
# Expected output: ready

# Check Loki service status
sudo systemctl status loki
# Expected: active (running)

# Verify log push endpoint
curl -s -X POST http://localhost:3100/loki/api/v1/push \
  -H "Content-Type: application/json" \
  --data-raw '{"streams":[{"stream":{"job":"test"},"values":[["'"$(date +%s)"'000000","test log entry"]]}]}' | jq '.status'
# Expected: "success"
```

### Check Promtail Status

```bash
# Check Promtail is running
sudo systemctl status promtail

# Check Promtail metrics endpoint
curl -s http://localhost:9080/metrics | head -n 20

# Check Promtail is connected to Loki
curl -sG --data-urlencode 'query={job="system_logs"}' \
  http://localhost:3100/loki/api/v1/query | jq '.status'
# Expected: "success"
```

## Rollback

### Stop Services

```bash
sudo systemctl stop loki
sudo systemctl stop promtail
sudo systemctl disable loki
sudo systemctl disable promtail
```

### Backup and Restore

```bash
# Backup current data before removal
sudo tar -czf /tmp/loki-backup-$(date +%Y%m%d).tar.gz \
  /var/lib/loki /etc/loki /var/log/loki

# Restore from backup
sudo tar -xzf /tmp/loki-backup-*.tar.gz -C /

# Fix ownership after restore
sudo chown -R loki:loki /var/lib/loki /etc/loki /var/log/loki

# Restart Loki
sudo systemctl daemon-reload
sudo systemctl start loki
```

### Full Uninstall

```bash
sudo systemctl stop loki promtail
sudo systemctl disable loki promtail
sudo rm /etc/systemd/system/loki.service /etc/systemd/system/promtail.service
sudo rm -rf /var/lib/loki /var/lib/promtail /etc/loki /etc/promtail /var/log/loki /var/log/promtail
sudo userdel loki promtail
sudo systemctl daemon-reload
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `connection refused` | Loki not running or wrong port | Check: `systemctl status loki`; verify port 3100 |
| `endpoint not found` | Wrong URL in Promtail config | Verify Loki URL in `/etc/promtail/promtail-config.yaml` |
| `permission denied` | File permission issues | Check: `chown -R loki:loki /var/lib/loki`; ensure user is `loki` not `root` |
| `out of memory` | Not enough RAM allocated | Increase memory limit in systemd service `MemoryLimit=` |
| `disk full` | Log retention too long or no rotation | Reduce retention in config; check `df -h`; enable logrotate |
| `too many outstanding requests` | Promtail buffer full | Adjust `batch_timeout` and `max_clients` in config |
| `authentication failed` | Wrong Loki endpoint or firewall | Verify URL: `curl http://loki:3100/ready` |
| `400 Bad Request` | Invalid label format | Labels cannot contain `.`, `/`, or special chars; use `_` instead |
| `user loki does not exist` | Binary install without creating user | Create user: `sudo useradd -r -s /bin/false loki` |
| `No such file or directory` | Package install dirs differ from binary | Package uses `/usr/lib/loki`; binary uses `/usr/local/bin/loki` |

## References

- [Loki Official Documentation](https://grafana.com/docs/loki/latest/)
- [Promtail Configuration Guide](https://grafana.com/docs/loki/clients/promtail/configuration/)
- [LogQL Query Language](https://grafana.com/docs/loki/latest/query/)
- [Grafana Loki Data Source](https://grafana.com/docs/grafana/latest/datasources/loki/)
- [Loki Storage Configuration](https://grafana.com/docs/loki/latest/storage/)
- [Loki Production Deployment](https://grafana.com/docs/loki/latest/get-started/deploy/)