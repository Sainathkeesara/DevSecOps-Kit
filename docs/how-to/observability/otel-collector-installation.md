# OpenTelemetry Collector Installation and Pipeline Configuration

---
SQUIRREL:
  title: "OpenTelemetry Collector Installation and Pipeline Configuration"
  category: "observability"
  tags: ["opentelemetry", "otel", "collector", "metrics", "traces", "logs", "observability", "telemetry"]
  last_verified: "2026-05-10"
  version: "OTel Collector 0.114+"
---

## Purpose

This guide provides steps to install and configure the OpenTelemetry Collector for centralized telemetry data collection, processing, and export across distributed systems. Covers agent and gateway deployment modes, pipeline configuration, and operational verification.

## When to use

- Setting up observability infrastructure for microservices
- Centralizing metrics, traces, and logs from multiple sources
- Implementing vendor-agnostic telemetry collection
- Replacing proprietary agent solutions with OTel standards
- Building multi-cloud observability pipelines

## Prerequisites

- Linux system (RHEL 7+, Ubuntu 18.04+, Debian 10+)
- Root or sudo privileges for installation
- Network access to download OTel Collector binary
- 500MB+ disk space for binary and database
- Ports available: 4317 (gRPC), 4318 (HTTP), 8888 (metrics)

## Installation

### Install OTel Collector (Agent Mode)

```bash
# Download and install OTel Collector with default configuration
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/otel/otel-collector-install.sh | bash -s -- --version 0.114.0 --mode agent

# Dry-run to preview installation steps
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/otel/otel-collector-install.sh | bash -s -- --dry-run --version 0.114.0 --mode agent
```

### Install OTel Collector (Gateway Mode)

```bash
# Install as aggregating gateway for multi-agent setups
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/observability_toolkit/otel/otel-collector-install.sh | bash -s -- --version 0.114.0 --mode gateway
```

### Manual Installation

```bash
# Download OTel Collector binary
VERSION="0.114.0"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH="amd64"
[ "$ARCH" = "aarch64" ] && ARCH="arm64"

curl -fsSL "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${VERSION}/otelcol_${VERSION}_${OS}_${ARCH}.tar.gz" -o /tmp/otelcol.tar.gz

# Extract and install
sudo mkdir -p /opt/otelcol
sudo tar -xzf /tmp/otelcol.tar.gz -C /opt/otelcol
sudo chmod +x /opt/otelcol/otelcol
sudo rm /tmp/otelcol.tar.gz

# Create otelcol user
sudo useradd --system otelcol

# Create configuration
sudo mkdir -p /etc/otelcol
sudo cat > /etc/otelcol/otelcol-agent.yaml <<'EOF'
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 10s

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
  logging:
    verbosity: basic

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus, logging]
EOF

# Create systemd service
sudo cat > /etc/systemd/system/otelcol-agent.service <<EOF
[Unit]
Description=OpenTelemetry Collector Agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=otelcol
Group=otelcol
ExecStart=/opt/otelcol/otelcol --config=/etc/otelcol/otelcol-agent.yaml
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable otelcol-agent
sudo systemctl start otelcol-agent
```

## Pipeline Configuration

### Basic Pipeline (Agent Mode)

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  prometheus:
    config:
      scrape_configs:
        - job_name: 'node'
          static_configs:
            - targets: ['localhost:9100']

processors:
  batch:
    timeout: 10s
    send_batch_size: 1024
  memory_limiter:
    check_interval: 1s
    limit_percentage: 75
    spike_limit_percentage: 25

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
  otlp:
    endpoint: "gateway:4317"
    tls:
      insecure: true

service:
  pipelines:
    metrics:
      receivers: [otlp, prometheus]
      processors: [batch, memory_limiter]
      exporters: [prometheus, otlp]
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
```

### Gateway Pipeline with Load Balancing

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 5s
    send_batch_size: 2048

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
  jaeger:
    endpoint: "jaeger:14250"
    tls:
      insecure: true
  loki:
    endpoint: "http://loki:3100/loki/api/v1/push"

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [jaeger]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [loki]
```

### Kubernetes Deployment (DaemonSet Agent)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
data:
  collector.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    processors:
      batch:
        timeout: 10s
    exporters:
      otlp:
        endpoint: "otel-collector-gateway:4317"
        tls:
          insecure: true
      prometheus:
        endpoint: "0.0.0.0:8889"
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [otlp]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [prometheus, otlp]
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: otel-collector-agent
spec:
  selector:
    matchLabels:
      app: otel-collector-agent
  template:
    metadata:
      labels:
        app: otel-collector-agent
    spec:
      containers:
        - name: otel-collector
          image: otel/opentelemetry-collector:0.114.0
          args: ["--config=/conf/collector.yaml"]
          ports:
            - containerPort: 4317
            - containerPort: 4318
            - containerPort: 8889
          volumeMounts:
            - name: config
              mountPath: /conf
      volumes:
        - name: config
          configMap:
            name: otel-collector-config
```

## Configuration Options

| Component | Option | Description | Default |
|-----------|--------|-------------|---------|
| Receiver | `endpoint` | Listen address for OTLP | `0.0.0.0:4317` |
| Processor | `batch.timeout` | Batch timeout in seconds | `10s` |
| Processor | `batch.send_batch_size` | Max batch size | `1024` |
| Processor | `memory_limiter.limit_percentage` | Memory limit % | `75` |
| Exporter | `prometheus.endpoint` | Prometheus metrics endpoint | `0.0.0.0:8889` |
| Exporter | `otlp.endpoint` | OTLP endpoint for forwarding | `localhost:4317` |

## Verification

### Check Service Status

```bash
# Check if OTel Collector service is running
systemctl status otelcol-agent

# Or with the install script
/opt/otelcol/otelcol --version
```

### Verify Endpoints

```bash
# Check gRPC endpoint (OTLP)
curl -sf http://localhost:4317/

# Check HTTP endpoint (OTLP)
curl -sf http://localhost:4318/

# Check Prometheus metrics endpoint
curl -sf http://localhost:8889/metrics | head -n 20

# Check health endpoint (if configured)
curl -sf http://localhost:13133/
```

### Test Data Pipeline

```bash
# Send test trace via gRPC
echo '{"resourceSpans":[{"spans":[{"name":"test-span"}]}]}' | \
  curl -sf -X POST http://localhost:4318/v1/traces \
  -H "Content-Type: application/json" \
  -d @-

# Send test metrics via HTTP
curl -sf http://localhost:4318/v1/metrics \
  -H "Content-Type: application/json" \
  -d '{
    "resourceMetrics":[{
      "scopeMetrics":[{
        "metrics":[{
          "name":"test_metric",
          "gauge":{"dataPoints":[{"asInt":42}]}
        }]
      }]
    }]
  }'
```

## Rollback

### Stop and Disable Service

```bash
# Stop OTel Collector
sudo systemctl stop otelcol-agent
sudo systemctl disable otelcol-agent

# Remove systemd service
sudo rm /etc/systemd/system/otelcol-agent.service
sudo systemctl daemon-reload

# Remove binary and config
sudo rm -rf /opt/otelcol /etc/otelcol

# Remove user
sudo userdel otelcol
```

### Restore Previous Configuration

```bash
# If replacing existing config, restore backup
sudo cp /etc/otelcol/otelcol-agent.yaml.backup /etc/otelcol/otelcol-agent.yaml
sudo systemctl restart otelcol-agent
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|---------|
| `Failed to bind address 0.0.0.0:4317` | Port already in use | Check for existing OTel or Jaeger agent. Stop conflicting process or use different port |
| `exporter helper: failed to push data` | Downstream unreachable | Verify network connectivity, check firewall rules, ensure receiving service is up |
| `failed to unmarshal config` | YAML syntax error | Validate YAML structure, check indentation, verify file encoding |
| `permission denied: /opt/otelcol` | Insufficient permissions | Run as root or grant otelcol user permissions on install directory |
| `database not found` | Trivy database not initialized | Initialize with `trivy image --download-db-only` |
| `connection refused` | Receiver not listening | Verify service is running, check listening ports with `ss -tlnp` |

## References

- [OTel Collector Documentation](https://opentelemetry.io/docs/collector/)
- [OTel Collector GitHub Releases](https://github.com/open-telemetry/opentelemetry-collector-releases/releases)
- [OTel Collector Configuration](https://opentelemetry.io/docs/collector/configuration/)
- [OTel Protocol (OTLP)](https://opentelemetry.io/docs/specs/otlp/)