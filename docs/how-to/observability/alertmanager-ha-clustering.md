# Alertmanager High-Availability Clustering for Alert Deduplication

---
SQUIRREL:
  title: "Alertmanager High-Availability Clustering for Alert Deduplication"
  category: "observability"
  tags: ["alertmanager", "prometheus", "alerting", "ha-clustering", "high-availability", "alert-deduplication", "observability"]
  last_verified: "2026-05-11"
  version: "Alertmanager 0.27+"
---

## Purpose

This guide provides steps to install and configure Alertmanager high-availability clustering for alert deduplication across multiple Prometheus Alertmanager instances. It covers cluster setup with gossip protocol,沉默 (silence) and notification routing, deduplication strategies, and operational best practices for production alert management.

## When to use

- Deploying HA Alertmanager clusters to avoid single points of failure
- Implementing alert deduplication across multiple Prometheus instances
- Setting up cross-site or cross-region alert routing
- Managing alerts from multiple clusters that need coordination
- Configuring active/passive Alertmanager failover
- Setting up alert deduplication for alerts that may fire from multiple sources

## Prerequisites

- Linux servers (Ubuntu 20.04+, RHEL 8+, Debian 11+)
- Root or sudo privileges for installation
- 2-3 Alertmanager instances for HA (minimum 2 for basic HA)
- Network connectivity between Alertmanager nodes on port 9094
- Alertmanager binary (v0.27+) installed on each node
- Basic understanding of Prometheus alerting concepts

## Installation

### Option 1: Automated Installation

```bash
# Download and run Alertmanager HA cluster setup script
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh | bash -s -- --cluster-size 3 --cluster-name production

# Dry-run preview
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh | bash -s -- --dry-run --cluster-size 3
```

### Option 2: Manual Installation

#### Download Alertmanager

```bash
VERSION="0.27.0"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH="amd64"
[ "$ARCH" = "aarch64" ] && ARCH="arm64"

cd /tmp
wget -q https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager_${VERSION}_${OS}_${ARCH}.tar.gz
tar -xzf alertmanager_${VERSION}_${OS}_${ARCH}.tar.gz
sudo mv alertmanager /usr/local/bin/
sudo mv amtool /usr/local/bin/

# Create alertmanager user
sudo useradd --system --no-create-home --shell /sbin/nologin alertmanager
```

#### Create Required Directories

```bash
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager/data /var/log/alertmanager
sudo chown -R alertmanager:alertmanager /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
```

## Configuration

### Basic HA Cluster Configuration (alertmanager.yml)

```yaml
global:
  resolve_timeout: 5m
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@company.com'

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

receivers:
  - name: 'team-notifications'
    email_configs:
      - to: 'devops@company.com'
        send_resolved: true

  - name: 'critical-alerts'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#critical-alerts'
        send_resolved: true

  - name: 'warning-alerts'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#warning-alerts'
        send_resolved: true

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']

cluster:
  listen_address: '0.0.0.0:9094'
  advertise_address: 'HOSTNAME:9094'
  cluster_interval: 30s
  gossip_interval: 5s
  tcp_timeout: 10s
  probe_timeout: 5s
  probe_interval: 5s
```

### Cluster Configuration Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `listen_address` | `0.0.0.0:9094` | Address to listen for cluster peers |
| `advertise_address` | (required) | Public address of this instance for cluster communication |
| `cluster_interval` | 30s | Interval for cluster state syncs |
| `gossip_interval` | 5s | Interval for gossip protocol messages |
| `tcp_timeout` | 10s | Timeout for TCP connections |
| `probe_timeout` | 5s | Timeout for cluster health probes |
| `probe_interval` | 5s | Interval for health probes |

### Deduplication Strategies

#### Strategy 1: Identical Alert Deduplication

Alerts with the same labels are deduplicated across instances:

```yaml
route:
  group_by: ['alertname', 'cluster', 'service']
  # All alerts with same group_by labels will be deduplicated
```

#### Strategy 2: Geographic Deduplication

```yaml
route:
  group_by: ['alertname', 'cluster', 'region']
  routes:
    - match:
        region: us-east-1
      receiver: 'us-east-notifications'
    - match:
        region: us-west-2
      receiver: 'us-west-notifications'
```

#### Strategy 3: Hierarchical Deduplication

```yaml
route:
  group_by: ['alertname']
  routes:
    - match:
        environment: production
      receiver: 'prod-escalation'
      continue: true
    - match:
        environment: staging
      receiver: 'staging-notifications'
```

## Systemd Service

Create the systemd service file for each Alertmanager instance:

```bash
sudo tee /etc/systemd/system/alertmanager.service > /dev/null << 'EOF'
[Unit]
Description=Alertmanager High Availability Cluster
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=alertmanager
Group=alertmanager
ExecStart=/usr/local/bin/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager/data \
  --cluster.advertise-address=${ADVERTISE_ADDR} \
  --cluster.listen-address=0.0.0.0:9094 \
  --web.listen-address=0.0.0.0:9093 \
  --log.level=info
Restart=always
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/alertmanager

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager
```

## Prometheus Configuration

Update Prometheus to send alerts to all Alertmanager instances:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager-1.company.com:9093
            - alertmanager-2.company.com:9093
            - alertmanager-3.company.com:9093
```

### Load Balancer Configuration (Optional)

For simpler client configuration, place Alertmanager instances behind a load balancer:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager-lb.company.com:9093
```

Note: Load balancer approach does not provide true HA if the LB itself is not HA. Use direct cluster configuration for true HA.

## Verifying Cluster Health

### Check Cluster Members

```bash
# Check cluster status via API
curl -s http://localhost:9093/api/v1/status/peers | jq .

# Check which instance is active for a silence
curl -s http://localhost:9093/api/v1/silences | jq '.[].status.state'
```

### Test Alert Routing

```bash
# Send a test alert
curl -X POST http://localhost:9093/api/v1/alerts \
  -H "Content-Type: application/json" \
  -d '[{
    "labels": {
      "alertname": "TestAlert",
      "severity": "warning",
      "cluster": "prod-1"
    },
    "annotations": {
      "summary": "Test alert for HA cluster verification"
    }
  }]'
```

### Check Cluster State

```bash
# Get cluster status
curl -s http://localhost:9093/api/v1/status/peers | jq '.peers | length'

# Verify all instances agree on silences
for host in alertmanager-1 alertmanager-2 alertmanager-3; do
  echo "=== $host ==="
  curl -s "http://$host:9093/api/v1/silences" | jq 'length'
done
```

## Silence Management in HA

### Create Silences

```bash
# Create silence via amtool on any cluster member
amtool silence add \
  --alertmanager.url=http://alertmanager-1:9093 \
  --labels.alertname=TestAlert \
  --duration=4h \
  --comment="Maintenance window for test alert"

# Create silence on all instances
for host in alertmanager-1 alertmanager-2 alertmanager-3; do
  amtool silence add \
    --alertmanager.url=http://$host:9093 \
    --labels.alertname=TestAlert \
    --duration=4h
done
```

### Query Silences

```bash
# Query silences across cluster
amtool silence query --alertmanager.url=http://alertmanager-1:9093
```

## High Availability Patterns

### Active-Passive Failover

For strict active-passive where only one instance sends notifications:

```yaml
# Passive instance configuration
route:
  receiver: 'null-receiver'  # Drop all alerts on passive

receivers:
  - name: 'null-receiver'
    # No notification configs - drops all alerts
```

### Active-Active (Gossip-Based)

Default mode - all instances participate in notification delivery:

```yaml
# All instances send notifications
receivers:
  - name: 'team-notifications'
    email_configs:
      - to: 'team@company.com'
        send_resolved: true
```

## Rollback

### Remove Instance from Cluster

```bash
# Stop the instance
sudo systemctl stop alertmanager

# Update Prometheus to remove the instance
# Edit prometheus.yml and remove the instance from alertmanagers list

# Restart Prometheus
sudo systemctl restart prometheus
```

### Restore Single Instance

```yaml
# Remove cluster section for single-instance operation
cluster:
  listen_address: '0.0.0.0:9094'
  # advertise_address removed for single instance
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Failed to join cluster` | Network connectivity or port blocked | Check firewall: port 9094; verify advertise_address is reachable |
| `Cluster has no peers` | Other instances not running | Start all instances; check `--cluster.advertise-address` is correct |
| `Duplicate notifications` | No deduplication config | Configure `group_by` in route; ensure identical labels |
| `Silence not propagated` | Gossip not working | Check cluster_interval and gossip_interval; verify network connectivity |
| `Instance becoming primary` | Split-brain in cluster | Use odd number of instances; configure proper advertise_address |
| `Notifications delayed` | High cluster traffic | Increase cluster_interval; reduce gossip_interval |

## References

- [Alertmanager High Availability](https://prometheus.io/docs/alerting/latest/ha/)
- [Alertmanager Clustering](https://github.com/prometheus/alertmanager#high-availability)
- [Alertmanager Configuration](https://prometheus.io/docs/alerting/latest/configuration/)
- [Alertmanager API](https://prometheus.io/docs/alerting/latest/cli's/)