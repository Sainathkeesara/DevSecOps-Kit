# Grafana Installation and Data Source Configuration for Metric Visualization

---
SQUIRREL:
  title: "Grafana Installation and Data Source Configuration for Metric Visualization"
  category: "observability"
  tags: ["grafana", "prometheus", "metrics", "visualization", "dashboard", "datasource", "observability"]
  last_verified: "2026-05-13"
  version: "Grafana 10.4.0"
---

## Purpose

This guide provides steps to install and configure Grafana for metric visualization with Prometheus as a data source. It covers installation via automated script or manual package installation, data source provisioning for Prometheus, basic security configuration, and dashboard setup.

## When to Use

- When you need a web-based dashboard for visualizing Prometheus metrics
- When setting up a monitoring stack with Grafana and Prometheus
- When configuring data sources for metric visualization
- When you want automated Grafana provisioning with Prometheus integration

## Prerequisites

- Linux server (Ubuntu 20.04+, RHEL 8+, Debian 11+, AlmaLinux 9+)
- Root or sudo privileges for installation
- Prometheus already installed and running (port 9090)
- 2GB+ RAM recommended for Grafana
- Ports available: 3000 (HTTP) or 443 (HTTPS)
- curl and wget available

## Installation

### Option 1: Automated Installation Script

Use the provided deployment script for automated installation:

```bash
# Download and run Grafana installation script
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/grafana/grafana-install.sh | bash -s -- --dry-run

# Actual installation (requires root)
sudo curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/grafana/grafana-install.sh | sudo bash -s -- --version 10.4.0 --http-port 3000

# Install with HTTPS
sudo curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/grafana/grafana-install.sh | sudo bash -s -- --protocol https --http-port 443
```

### Option 2: Manual Package Installation (Debian/Ubuntu)

#### Install Grafana via APT

```bash
# Add Grafana APT repository
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add repository for OSS version
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
sudo apt-get update
sudo apt-get install grafana
```

#### Install Grafana via Binary

```bash
# Download binary
VERSION="10.4.0"
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *) ARCH="386" ;;
esac

curl -fsSL "https://dl.grafana.com/oss/release/grafana-${VERSION}.linux-${ARCH}.tar.gz" -o /tmp/grafana.tar.gz

# Extract and install
sudo mkdir -p /opt/grafana
sudo tar -xzf /tmp/grafana.tar.gz -C /opt/grafana --strip-components=1
rm /tmp/grafana.tar.gz

# Create grafana user
sudo useradd --system --no-create-home --shell /usr/sbin/nologin grafana

# Create directories
sudo mkdir -p /etc/grafana /var/lib/grafana /var/log/grafana
sudo chown -R grafana:grafana /opt/grafana /var/lib/grafana /var/log/grafana
```

### Option 3: Docker Installation

```bash
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  -v grafana-data:/var/lib/grafana \
  grafana/grafana:10.4.0
```

## Configuration

### Grafana Server Configuration (grafana.ini)

```ini
[server]
http_addr = 0.0.0.0
http_port = 3000
protocol = http

[paths]
data = /var/lib/grafana
logs = /var/log/grafana

[security]
admin_user = admin
admin_password = <CHANGE_THIS_STRONG_PASSWORD>

[auth]
disable_login_form = false

[users]
allow_sign_up = false
allow_org_create = false
auto_assign_org = true

[session]
provider = file
provider_config = /var/lib/grafana/sessions
```

### Prometheus Data Source Provisioning

Create the data source configuration file:

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

```yaml
# /etc/grafana/provisioning/datasources/prometheus.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
    jsonData:
      httpMethod: GET
      timeInterval: 15s
    version: 1
```

### Dashboard Provisioning (Optional)

```yaml
# /etc/grafana/provisioning/dashboards/default.yml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: /etc/grafana/provisioning/dashboards
```

## Systemd Service

```bash
sudo tee /etc/systemd/system/grafana-server.service > /dev/null <<'EOF'
[Unit]
Description=Grafana Visualization Server
After=network.target

[Service]
Type=simple
User=grafana
Group=grafana
ExecStart=/opt/grafana/bin/grafana-server \
    --config=/etc/grafana/grafana.ini \
    --homepath=/opt/grafana
Restart=always
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/grafana /var/log/grafana /etc/grafana

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

## Verify

### Check Service Status

```bash
# Service status
sudo systemctl status grafana-server

# Health check API
curl -s http://localhost:3000/api/health | jq .

# Check data sources
curl -s http://localhost:3000/api/datasources | jq '.[].name'
```

Expected output:
```json
{
  "commit": "abc123",
  "database": "ok",
  "version": "10.4.0"
}
```

### Test Prometheus Data Source

```bash
# Verify Prometheus is accessible from Grafana
curl -s 'http://localhost:3000/api/datasources/proxy/1/api/v1/query?query=up' | jq '.status'
# Expected: "success"
```

### Access Dashboard

1. Open http://localhost:3000 in a browser
2. Log in with credentials (default: admin / admin123)
3. Navigate to **Dashboards** → **Browse**
4. Import Node Exporter dashboard: **ID 1860**
5. Select the Prometheus data source

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Failed to start grafana-server` | Port already in use | Check: `ss -tlnp \| grep 3000` |
| `Cannot connect to Prometheus` | Wrong URL in datasource config | Verify Prometheus is running: `curl localhost:9090/-/healthy` |
| `Permission denied` on startup | Wrong file ownership | `chown -R grafana:grafana /var/lib/grafana` |
| `Database migration failed` | Corrupted database | Remove `/var/lib/grafana/grafana.db` and restart |
| `Dashboard shows "No data"` | Incorrect Prometheus URL | Check datasource URL matches Prometheus endpoint |
| `Port conflict` | Another service on port 3000 | Change `http_port` in grafana.ini |

## Rollback

### Stop and Remove Grafana

```bash
# Stop service
sudo systemctl stop grafana-server
sudo systemctl disable grafana-server
sudo rm /etc/systemd/system/grafana-server.service
sudo systemctl daemon-reload

# Remove files
sudo rm -rf /opt/grafana /etc/grafana /var/lib/grafana /var/log/grafana

# Remove user
sudo userdel grafana 2>/dev/null || true
```

## Security Hardening

### Change Default Credentials

```bash
# After first login, change password via UI
# Or via API:
curl -s -X PUT http://localhost:3000/api/user/password \
  -H "Content-Type: application/json" \
  -d '{"oldPassword":"admin123","newPassword":"<NEW_STRONG_PASSWORD>"}' \
  -u admin:admin123
```

### Enable HTTPS

```ini
[server]
protocol = https
cert_file = /etc/grafana/ssl/cert.pem
cert_key = /etc/grafana/ssl/key.pem
```

### Disable Anonymous Access

```ini
[auth.anonymous]
enabled = false
```

## References

- [Grafana Official Documentation](https://grafana.com/docs/grafana/latest/)
- [Grafana Installation Guide](https://grafana.com/docs/grafana/latest/installation/)
- [Data Source Configuration](https://grafana.com/docs/grafana/latest/datasources/)
- [Prometheus Data Source](https://grafana.com/docs/grafana/latest/datasources/prometheus/)
- [Grafana Dashboard Repository](https://grafana.com/grafana/dashboards/)
- [Node Exporter Dashboard 1860](https://grafana.com/dashboards/1860)