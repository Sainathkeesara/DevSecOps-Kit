---
SQUIRREL:
  title: "Prometheus Node Exporter Installation and Configuration"
  category: "observability"
  tags: ["prometheus", "node-exporter", "metrics", "monitoring", "system-metrics", "observability", "linux"]
  last_verified: "2026-05-12"
  version: "node-exporter 1.8+"
---

# Prometheus Node Exporter Installation and Configuration

## Purpose

This guide provides steps to install and configure Prometheus node_exporter for collecting system-level metrics from Linux servers. Covers standalone installation, systemd service setup, firewall configuration, and Prometheus integration for centralized monitoring.

## When to Use

- Setting up Prometheus-based system monitoring infrastructure
- Collecting CPU, memory, disk, network, and process metrics from Linux servers
- Building observability foundation before deploying application metrics
- Integrating with Grafana dashboards for visualization
- Setting up alerts for system resource exhaustion

## Prerequisites

- Linux system (RHEL 7+, Ubuntu 18.04+, Debian 10+)
- Root or sudo privileges for installation
- Network access to download node_exporter binary
- Prometheus server already deployed or planned
- 100MB+ disk space for binary and metrics storage

## Installation

### Quick Install with Setup Script

```bash
# Download and run the setup script
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh | sudo bash -s -- --version 1.8.2 --port 9100

# Preview installation steps without executing
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh | sudo bash -s -- --dry-run --version 1.8.2
```

### Manual Installation

```bash
# Set variables
VERSION="1.8.2"
INSTALL_DIR="/opt/prometheus"
PORT=9100
MONITORING_USER="node_exporter"

# Create monitoring user
sudo useradd --no-create-home --shell /usr/sbin/nologin "$MONITORING_USER" 2>/dev/null || true

# Download node_exporter
curl -fsSL "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz" -o /tmp/node_exporter.tar.gz

# Extract and install
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf /tmp/node_exporter.tar.gz -C /tmp/
sudo cp /tmp/node_exporter-${VERSION}.linux-amd64/node_exporter "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/node_exporter"
sudo chown "$MONITORING_USER:$MONITORING_USER" "$INSTALL_DIR/node_exporter"

# Clean up
rm -rf /tmp/node_exporter*

# Create textfile collector directory
sudo mkdir -p /var/lib/node_exporter/textfile_collector
sudo chown "$MONITORING_USER:$MONITORING_USER" /var/lib/node_exporter/textfile_collector
```

### Systemd Service Configuration

```bash
sudo cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
After=network-online.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter
ExecStart=/opt/prometheus/node_exporter \
    --collector.textfile.directory=/var/lib/node_exporter/textfile_collector \
    --web.listen-address=:9100 \
    --collector.cpu \
    --collector.meminfo \
    --collector.diskstats \
    --collector.filesystem \
    --collector.netdev \
    --collector.loadavg \
    --collector.stat \
    --collector.time \
    --collector.uname
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

### Firewall Configuration

```bash
# For firewalld
sudo firewall-cmd --permanent --add-port=9100/tcp
sudo firewall-cmd --reload

# For ufw
sudo ufw allow 9100/tcp

# For iptables
sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
```

## Configuration Options

| Flag | Description | Default |
|------|-------------|---------|
| `--web.listen-address` | Listen address | `:9100` |
| `--collector.textfile.directory` | Textfile collector path | `/var/lib/node_exporter/textfile_collector` |
| `--collector.disable-defaults` | Disable default collectors | false |
| `--collector.cpu` | Enable CPU collector | enabled |
| `--collector.meminfo` | Enable memory collector | enabled |
| `--collector.diskstats` | Enable disk stats collector | enabled |
| `--collector.filesystem` | Enable filesystem collector | enabled |
| `--collector.netdev` | Enable network device collector | enabled |
| `--collector.loadavg` | Enable load average collector | enabled |
| `--collector.stat` | Enable system stat collector | enabled |
| `--web.telemetry-path` | Metrics path | `/metrics` |

## Prometheus Integration

### Add to Prometheus Scrape Config

Edit `/etc/prometheus/prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
        labels:
          instance: 'localhost'
          env: 'production'
    scrape_interval: 30s
```

### Multi-Server Configuration

```yaml
scrape_configs:
  - job_name: 'linux-servers'
    static_configs:
      - targets:
          - 'server1.example.com:9100'
          - 'server2.example.com:9100'
          - 'server3.example.com:9100'
        labels:
          group: 'production'
      - targets:
          - 'dev-server1.example.com:9100'
          - 'dev-server2.example.com:9100'
        labels:
          group: 'development'
```

### Prometheus Service Discovery

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    dns_sd_configs:
      - names:
          - 'node-exporter.service.example.com'
        type: A
        port: 9100
```

## Verification

### Check Service Status

```bash
# Check systemd service
systemctl status node_exporter

# Check process is running
ps aux | grep node_exporter

# Check listening port
ss -tlnp | grep 9100
```

### Verify Metrics Endpoint

```bash
# Check metrics are exposed
curl -s http://localhost:9100/metrics | head -n 30

# Verify specific metrics exist
curl -s http://localhost:9100/metrics | grep -E "^node_" | wc -l

# Expected output includes:
# node_cpu_seconds_total{mode="idle"}
# node_memory_MemAvailable_bytes
# node_filesystem_avail_bytes
# node_load1
```

### Test Prometheus Scraping

```bash
# Check Prometheus can reach node-exporter
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.job=="node-exporter")'

# Query metrics in Prometheus
curl -s 'http://localhost:9090/api/v1/query?query=up{job="node-exporter"}' | jq
```

## Rollback

### Remove Node Exporter

```bash
# Stop and disable service
sudo systemctl stop node_exporter
sudo systemctl disable node_exporter

# Remove systemd service file
sudo rm /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload

# Remove binary and directories
sudo rm -rf /opt/prometheus
sudo rm -rf /var/lib/node_exporter

# Remove user
sudo userdel node_exporter 2>/dev/null || true
```

### Restore Previous Configuration

```bash
# If replacing config, restore backup
sudo cp /etc/prometheus/prometheus.yml.backup /etc/prometheus/prometheus.yml
sudo systemctl reload prometheus
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Unit node_exporter.service not found` | Service file not created | Re-run setup script or manually create service file |
| `connection refused` on port 9100 | Service not running | Check `systemctl status node_exporter` |
| `permission denied` on /opt/prometheus | Insufficient permissions | Run as root or fix ownership |
| `firewalld` port not open | Firewall blocking | Add port via firewall-cmd or ufw |
| `Prometheus context deadline exceeded` | Network connectivity | Check firewall rules and network |
| `no metrics exposed` | Collectors disabled | Check enabled collectors in service |

## Collectors Reference

### Default Collectors

| Collector | Metrics Provided |
|-----------|------------------|
| cpu | CPU usage per mode |
| meminfo | Memory usage |
| diskstats | Disk I/O statistics |
| filesystem | Filesystem usage |
| netdev | Network traffic |
| loadavg | System load |
| netstat | Network connections |
| stat | System statistics |
| time | System time |
| uname | System information |

### Custom Collectors

Enable textfile collector for custom metrics:

```bash
# Create custom metrics script
cat > /usr/local/bin/custom-metrics.sh <<'EOF'
#!/bin/bash
echo '# HELP app_requests_total Total application requests'
echo '# TYPE app_requests_total counter'
app_requests_total 12345
EOF
chmod +x /usr/local/bin/custom-metrics.sh

# Add to cron
echo '* * * * * /usr/local/bin/custom-metrics.sh > /var/lib/node_exporter/textfile_collector/app.prom' | sudo tee /etc/cron.d/custom-metrics
```

## References

- [node_exporter GitHub](https://github.com/prometheus/node_exporter)
- [node_exporter Collectors](https://github.com/prometheus/node_exporter#enabled-by-default)
- [Prometheus Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Grafana Node Exporter Dashboard](https://grafana.com/dashboards/1860)