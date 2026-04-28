# Log Aggregation with Loki and Promtail

## Purpose

This project provides comprehensive guidance on setting up Loi for log aggregation and Promtail for log collection in a Linux environment. The stack enables centralized logging, querying, and visualization of logs across multiple servers and applications. This guide emphasizes security-hardened, production-ready deployments with proper user isolation, least-privilege service accounts, and safe installation practices that work consistently across both package-managed and binary installations.

## When to Use

- Centralizing logs from multiple Linux servers
- Building a centralized logging infrastructure
- Implementing log-based alerting and monitoring
- Troubleshooting distributed applications
- Meeting compliance logging requirements
- Creating audit trails for security analysis
- Replacing syslog-ng/rsyslog with modern Loki/Promtail stack

## Prerequisites

- Linux servers (Ubuntu 20.04+, RHEL 8+, Debian 11+)
- Root or sudo access on all servers
- At least 10GB free disk space for log storage
- Network connectivity between all servers
- Basic understanding of systemd and logging
- Grafana installed for visualization (optional but recommended)
- curl and wget available on all target systems

## Steps

### Step 1: Plan the Architecture

Design your Loki deployment:

- Single instance: For small environments (up to 10 servers)
- HA cluster: For production environments requiring high availability
- Scalable: For large environments with many servers

Plan the storage requirements:

- Default retention: 30 days
- Average log rate: 100MB/hour per server
- Storage per server/month: ~70GB

### Step 2: Install Loki on the Central Server

Choose installation method: **Package (Debian/Ubuntu/RHEL)** or **Binary**. Both methods create the `loki` system user automatically, but handled differently.

#### Method A: Package Installation (Recommended)

Package managers (apt/yum/dnf) create the `loki` user automatically. We just need to ensure correct ownership.

```bash
# Download Loki package
curl -s -L https://github.com/grafana/loki/releases/download/v3.2.0/loki_3.2.0_amd64.deb -o /tmp/loki.deb
sudo dpkg -i /tmp/loki.deb

# Verify loki user was created
id loki
# Should show: uid=... gid=... groups=...

# Create required directories (some may already exist)
sudo mkdir -p /var/lib/loki /etc/loki /var/log/loki

# Set correct ownership - loki user owns its data and config
sudo chown -R loki:loki /var/lib/loki
sudo chown -R loki:loki /var/log/loki
sudo chown -R loki:loki /etc/loki
```

#### Method B: Binary Installation

For binary installs, we must create the `loki` user ourselves **before** running the service.

```bash
# Create loki system user FIRST (if not already present)
if ! id loki &>/dev/null; then
    sudo useradd -r -s /bin/false -M -d /nonexistent loki
fi

# Download and install Loki binary
cd /tmp
wget -q https://github.com/grafana/loki/releases/download/v3.2.0/loki-linux-amd64.zip
unzip -o loki-linux-amd64.zip

# Install binary with correct ownership
sudo install -o loki -g loki -m 0755 loki-linux-amd64 /usr/local/bin/loki

# Create required directories
sudo mkdir -p /var/lib/loki /etc/loki /var/log/loki

# Set correct ownership - loki:loki (NOT root:root)
sudo chown -R loki:loki /var/lib/loki
sudo chown -R loki:loki /var/log/loki
sudo chown -R loki:loki /etc/loki
```

### Step 3: Configure Loki

Create the Loki configuration file with proper permissions:

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

# Set ownership to loki user
sudo chown loki:loki /etc/loki/local-config.yaml
sudo chmod 0644 /etc/loki/local-config.yaml
```

### Step 4: Create Systemd Service for Loki

Create the systemd service file running as the `loki` user:

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

# Reload systemd, enable and start Loki
sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki

# Verify Loki is running
sudo systemctl status loki
```

### Step 5: Install Promtail on Client Servers

Each log-sending server needs Promtail installed. Again, choose **Package** or **Binary**:

#### Method A: Package Installation

```bash
# Download Promtail package
curl -s -L https://github.com/grafana/loki/releases/download/v3.2.0/promtail_3.2.0_amd64.deb -o /tmp/promtail.deb
sudo dpkg -i /tmp/promtail.deb

# Verify promtail user was created
id promtail
```

#### Method B: Binary Installation

Create the `promtail` user **before** installing the binary:

```bash
# Create promtail system user FIRST
if ! id promtail &>/dev/null; then
    sudo useradd -r -s /bin/false -M -d /nonexistent promtail
fi

# Download and install Promtail binary
cd /tmp
wget -q https://github.com/grafana/loki/releases/download/v3.2.0/promtail-linux-amd64.zip
unzip -o promtail-linux-amd64.zip

# Install binary with correct ownership
sudo install -o promtail -g promtail -m 0755 promtail-linux-amd64 /usr/local/bin/promtail

# Create required directories
sudo mkdir -p /var/lib/promtail /etc/promtail /var/log/promtail

# Set ownership to promtail:promtail (NOT root:root)
sudo chown -R promtail:promtail /var/lib/promtail
sudo chown -R promtail:promtail /var/log/promtail
sudo chown -R promtail:promtail /etc/promtail
```

### Step 6: Configure Promtail

Replace `loki-server` with the actual hostname/IP of your Loki server:

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

# Set ownership to promtail user
sudo chown promtail:promtail /etc/promtail/promtail-config.yaml
sudo chmod 0644 /etc/promtail/promtail-config.yaml

# Replace placeholders
sudo sed -i "s/__HOSTNAME__/$(hostname)/g" /etc/promtail/promtail-config.yaml
# Note: Manually replace LOKI_SERVER_HOSTNAME with your Loki server's hostname or IP
```

### Step 7: Create Systemd Service for Promtail

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

# Reload systemd, enable and start Promtail
sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail

# Verify Promtail is running
sudo systemctl status promtail
```

### Step 8: Configure Log Rotation

Prevent disk space issues with proper log rotation:

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
        /bin/kill -HUP $(cat /run/loki/loki.pid 2>/dev/null) 2>/dev/null || true
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

echo

```

### Step 9: Integrate with Grafana

Connect Loki to Grafana for visualization:

1. Open Grafana: `http://grafana-server:3000`
2. Go to **Configuration** → **Data Sources**
3. Click **Add data source** → Select **Loki**
4. Set URL: `http://loki-server:3100`
5. Click **Save & Test**

### Step 10: Query Logs in Grafana

Example LogQL queries:

```logql
# All logs from a specific host
{host="web-server-01"}

# Error logs only
{job="app-logs"} |= "ERROR"

# Filter by message content (multiple matches)
{job="system_logs"} |= "failed" |= "authentication"

# Performance metrics
rate({job="app-logs"}[5m])

# Count by level over time
count_over_time({job="app-logs"}[1h])

# Top 10 most common log lines
# TYPE TOPK range
# TYPE RATE counter
```

### Step 11: Set Up Alerts

Create alert rules in Grafana (Alertmanager format):

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
          description: "Error rate is above 10%"

      - alert: MissingLogs
        expr: |
          absent({job="app-logs"}) > 10m
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "No logs received from app-logs"
```

Apply alert rules via Grafana or Loki's ruler configuration.

## Verify

```bash
# Check Loki is ready
curl -s http://localhost:3100/ready
# Expected output: ready

# Check Loki service status
sudo systemctl status loki
# Expected: active (running)

# Check Loki process ownership
ps aux | grep loki | grep -v grep
# Expected: running as loki user

# Check Promtail is ready
curl -s http://localhost:9080/metrics
# Expected: Prometheus metrics output

# Check Promtail service status
sudo systemctl status promtail
# Expected: active (running)

# Verify log ingestion
curl -s -G --data-urlencode 'query={job="system_logs"}' \
  http://localhost:3100/loki/api/v1/query | jq '.status'
# Expected: "success"

# Check disk usage
sudo df -h /var/lib/loki
sudo df -h /var/lib/promtail

# Verify log push endpoint
curl -s -X POST http://localhost:3100/loki/api/v1/push \
  -H "Content-Type: application/json" \
  --data-raw '{"streams":[{"stream":{"job":"test"},"values":[["'$(date +%s)000000'","test log entry"]]}]}' | jq '.status'
# Expected: "success"
```

## Rollback

```bash
# Stop Loki and Promtail services
sudo systemctl stop loki
sudo systemctl stop promtail
sudo systemctl disable loki
sudo systemctl disable promtail

# Backup current data before removal
sudo tar -czf /tmp/loki-backup-$(date +%Y%m%d).tar.gz \
  /var/lib/loki /etc/loki /var/log/loki

# Restore from backup
sudo systemctl stop loki
sudo rm -rf /var/lib/loki/*
sudo rm -rf /etc/loki/*
sudo tar -xzf /tmp/loki-backup-*.tar.gz -C /

# Fix ownership after restore
sudo chown -R loki:loki /var/lib/loki
sudo chown -R loki:loki /etc/loki
sudo chown -R loki:loki /var/log/loki

# Restart Loki
sudo systemctl daemon-reload
sudo systemctl start loki
sudo systemctl status loki

# Alternative: use object storage (S3/GCS/Azure)
# Update /etc/loki/local-config.yaml storage_config section:
# storage_config:
#   aws:
#     s3: s3://access_key:secret_key@bucket_name/loki
#     s3forcepathstyle: true
#   boltdb:
#     directory: /var/lib/loki/index
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
| `authentication failed` | Wrong Loki endpoint or firewall | Verify URL is accessible: `curl http://loki:3100/ready` |
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
- [Systemd Service Security](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
