#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
VERSION="${VERSION:-0.114.0}"
INSTALL_DIR="/opt/otelcol"
CONFIG_DIR="/etc/otelcol"
SYSTEMD_DIR="/etc/systemd/system"
CONFIG_URL="${CONFIG_URL:-}"
MODE="${MODE:-agent}"
PORT="${PORT:-4317}"
PORT_GRPC="${PORT_GRPC:-4317}"
PORT_HTTP="${PORT_HTTP:-4318}"
PORT_EXPORTER="${PORT_EXPORTER:-8888}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure OpenTelemetry Collector for metrics collection and pipeline configuration.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --version VERSION     OTel Collector version (default: 0.114.0)
    --install-dir DIR     Installation directory (default: /opt/otelcol)
    --config-url URL      URL to download base configuration
    --mode MODE           Collector mode: agent, gateway, standalone (default: agent)
    --port PORT           gRPC receiver port (default: 4317)
    --http-port PORT      HTTP receiver port (default: 4318)
    --exporter-port PORT  Prometheus exporter port (default: 8888)
    -h, --help           Show this help message

MODES:
    agent      Lightweight collector for edge/host collection (default)
    gateway    Aggregating collector for multi-agent setups
    standalone Full-featured collector for single-node deployments

EXAMPLES:
    $0 --dry-run
    $0 --version 0.110.0 --mode gateway --port 4317
    DRY_RUN=true $0 --config-url https://example.com/otel-config.yaml

EOF
    exit 0
}

log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%dT%H:%M:%S%z')] [$level] $*"
}

check_binary() {
    command -v "$1" >/dev/null 2>&1 || {
        log "ERROR" "$1 is required but not installed."
        return 1
    }
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log "ERROR" "This script must be run as root. Use sudo or set UID=0."
        exit 1
    fi
}

check_dependencies() {
    log "INFO" "Checking dependencies..."
    local missing=()
    for bin in curl tar systemctl; do
        if ! command -v "$bin" >/dev/null 2>&1; then
            missing+=("$bin")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        log "ERROR" "Missing required binaries: ${missing[*]}"
        exit 1
    fi
    log "INFO" "All dependencies available."
}

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="${ID:-unknown}"
        OS_VERSION="${VERSION_ID:-}"
    else
        OS_ID="unknown"
        OS_VERSION=""
    fi
    log "INFO" "Detected OS: $OS_ID $OS_VERSION"
}

generate_default_config() {
    local config_file="$1"
    local mode="$2"
    cat > "$config_file" <<EOF
extensions:
  health_check:
    endpoint: 0.0.0.0:13133
  zpages:
    endpoint: 0.0.0.0:55679

receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:${PORT_GRPC}
      http:
        endpoint: 0.0.0.0:${PORT_HTTP}
  prometheus:
    config:
      scrape_configs:
        - job_name: 'otel-collector'
          scrape_interval: 15s
          static_configs:
            - targets: ['0.0.0.0:8888']

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
    namespace: "otelcol"
    const_labels:
      service: "${mode}"
  logging:
    verbosity: basic
EOF

    case "$mode" in
        gateway)
            cat >> "$config_file" <<'EOF'
  otlp:
    endpoint: "localhost:4317"
    tls:
      insecure: true
EOF
            ;;
    esac

    cat >> "$config_file" <<EOF

service:
  extensions: [health_check, zpages]
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch, memory_limiter]
      exporters: [logging]
    metrics:
      receivers: [otlp, prometheus]
      processors: [batch, memory_limiter]
      exporters: [prometheus, logging]
    logs:
      receivers: [otlp]
      processors: [batch, memory_limiter]
      exporters: [logging]
EOF
    log "INFO" "Generated default configuration at $config_file"
}

download_otelcol() {
    local version="$1"
    local install_dir="$2"
    local os_type arch download_url tar_path

    os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) arch="386" ;;
    esac

    local otel_version="v${version}"
    download_url="https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/${otel_version}/otelcol_${version}_${os_type}_${arch}.tar.gz"
    tar_path="/tmp/otelcol_${version}.tar.gz"

    log "INFO" "Downloading OTel Collector $version for $os_type/$arch..."
    log "INFO" "URL: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download $download_url to $tar_path"
        log "DRY-RUN" "Would extract to $install_dir"
        return 0
    fi

    if ! curl -fsSL "$download_url" -o "$tar_path"; then
        log "ERROR" "Failed to download OTel Collector from $download_url"
        return 1
    fi

    mkdir -p "$install_dir"
    if ! tar -xzf "$tar_path" -C "$install_dir"; then
        log "ERROR" "Failed to extract OTel Collector archive"
        rm -f "$tar_path"
        return 1
    fi

    chmod +x "${install_dir}/otelcol"
    rm -f "$tar_path"
    log "INFO" "OTel Collector installed at $install_dir/otelcol"
}

install_systemd_service() {
    local install_dir="$1"
    local config_file="$2"
    local mode="$3"
    local service_name="otelcol-${mode}.service"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create systemd service: $service_name"
        log "DRY-RUN" "Would start and enable otelcol-${mode} service"
        return 0
    fi

    cat > "${SYSTEMD_DIR}/${service_name}" <<EOF
[Unit]
Description=OpenTelemetry Collector ${mode^} Mode
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=otelcol
Group=otelcol
ExecStart=${install_dir}/otelcol --config=${config_file}
Restart=always
RestartSec=5
LimitNOFILE=131072

Environment=HOST_IP=127.0.0.1

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "${SYSTEMD_DIR}/${service_name}"
    systemctl daemon-reload
    log "INFO" "Systemd service installed: $service_name"
}

create_otelcol_user() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create user 'otelcol'"
        return 0
    fi
    if ! id otelcol >/dev/null 2>&1; then
        useradd --system --no-create-home --shell /sbin/nologin otelcol
        log "INFO" "Created system user: otelcol"
    else
        log "INFO" "User otelcol already exists"
    fi
}

configure_firewall() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would open firewall ports: ${PORT_GRPC}, ${PORT_HTTP}, ${PORT_EXPORTER}"
        return 0
    fi
    if command -v firewall-cmd >/dev/null 2>&1; then
        firewall-cmd --add-port="${PORT_GRPC}/tcp" --add-port="${PORT_HTTP}/tcp" --add-port="${PORT_EXPORTER}/tcp" --permanent 2>/dev/null || true
        firewall-cmd --reload 2>/dev/null || true
        log "INFO" "Firewall ports opened"
    elif command -v ufw >/dev/null 2>&1; then
        ufw allow "${PORT_GRPC}/tcp" 2>/dev/null || true
        ufw allow "${PORT_HTTP}/tcp" 2>/dev/null || true
        ufw allow "${PORT_EXPORTER}/tcp" 2>/dev/null || true
        log "INFO" "UFW ports opened"
    fi
}

verify_installation() {
    log "INFO" "Verifying OTel Collector installation..."
    local install_dir="$1"
    local config_file="$2"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify binary at ${install_dir}/otelcol"
        log "DRY-RUN" "Would check config at $config_file"
        log "DRY-RUN" "Would verify service status"
        return 0
    fi

    if [ ! -x "${install_dir}/otelcol" ]; then
        log "ERROR" "OTel Collector binary not found or not executable at ${install_dir}/otelcol"
        return 1
    fi

    "${install_dir}/otelcol" --version || {
        log "ERROR" "OTel Collector binary failed to execute"
        return 1
    }

    if [ ! -f "$config_file" ]; then
        log "ERROR" "Configuration file not found at $config_file"
        return 1
    fi

    log "INFO" "OTel Collector binary verified successfully"
    log "INFO" "Configuration file verified at $config_file"
}

install() {
    local mode="$MODE"
    local install_dir="$INSTALL_DIR"
    local config_file="${CONFIG_DIR}/otelcol-${mode}.yaml"

    log "INFO" "Starting OTel Collector installation..."
    log "INFO" "Version: $VERSION | Mode: $mode | Install Dir: $install_dir"

    check_dependencies
    detect_os
    create_otelcol_user

    mkdir -p "$install_dir" "$CONFIG_DIR"

    if [ -n "$CONFIG_URL" ]; then
        if [ "$DRY_RUN" = "true" ]; then
            log "DRY-RUN" "Would download config from $CONFIG_URL to $config_file"
        else
            log "INFO" "Downloading configuration from $CONFIG_URL"
            curl -fsSL "$CONFIG_URL" -o "$config_file" || {
                log "WARN" "Failed to download config, generating default"
                generate_default_config "$config_file" "$mode"
            }
        fi
    else
        generate_default_config "$config_file" "$mode"
    fi

    chown otelcol:otelcol "$config_file"
    chmod 640 "$config_file"

    download_otelcol "$VERSION" "$install_dir"
    install_systemd_service "$install_dir" "$config_file" "$mode"
    configure_firewall
    verify_installation "$install_dir" "$config_file"

    if [ "$DRY_RUN" = "false" ]; then
        log "INFO" "Enabling and starting otelcol-${mode} service..."
        systemctl enable "otelcol-${mode}.service"
        systemctl start "otelcol-${mode}.service"
        sleep 3
        if systemctl is-active --quiet "otelcol-${mode}.service"; then
            log "INFO" "OTel Collector service is running"
        else
            log "WARN" "OTel Collector service failed to start. Check logs with journalctl -u otelcol-${mode}.service"
        fi
    fi

    log "INFO" "Installation complete!"
    log "INFO" "gRPC endpoint: localhost:${PORT_GRPC}"
    log "INFO" "HTTP endpoint: localhost:${PORT_HTTP}"
    log "INFO" "Metrics exporter: localhost:${PORT_EXPORTER}"
    log "INFO" "Config: $config_file"
}

cleanup() {
    local mode="$MODE"
    local service_name="otelcol-${mode}.service"

    log "INFO" "Cleaning up OTel Collector installation..."
    if systemctl is-active --quiet "$service_name" 2>/dev/null; then
        log "INFO" "Stopping service: $service_name"
        systemctl stop "$service_name" || true
    fi
    systemctl disable "$service_name" 2>/dev/null || true
    rm -f "${SYSTEMD_DIR}/${service_name}"
    systemctl daemon-reload

    if [ "$DRY_RUN" = "false" ]; then
        rm -rf "$INSTALL_DIR" "$CONFIG_DIR"
        userdel otelcol 2>/dev/null || true
        log "INFO" "OTel Collector removed successfully"
    else
        log "DRY-RUN" "Would remove $INSTALL_DIR and $CONFIG_DIR"
        log "DRY-RUN" "Would remove user otelcol"
    fi
}

status_check() {
    local mode="$MODE"
    local service_name="otelcol-${mode}.service"
    local endpoints=("localhost:${PORT_GRPC}" "localhost:${PORT_HTTP}" "localhost:${PORT_EXPORTER}")

    log "INFO" "Checking OTel Collector status..."

    if systemctl is-active --quiet "$service_name" 2>/dev/null; then
        log "INFO" "Service is ACTIVE"
    else
        log "WARN" "Service is NOT ACTIVE"
        return 1
    fi

    log "INFO" "Checking endpoints..."
    for endpoint in "${endpoints[@]}"; do
        if curl -sf "http://${endpoint}" >/dev/null 2>&1; then
            log "INFO" "Endpoint $endpoint: OK"
        else
            log "WARN" "Endpoint $endpoint: UNREACHABLE"
        fi
    done
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --version) VERSION="$2"; shift 2 ;;
            --install-dir) INSTALL_DIR="$2"; shift 2 ;;
            --config-url) CONFIG_URL="$2"; shift 2 ;;
            --mode) MODE="$2"; shift 2 ;;
            --port) PORT="$2"; PORT_GRPC="$2"; shift 2 ;;
            --http-port) PORT_HTTP="$2"; shift 2 ;;
            --exporter-port) PORT_EXPORTER="$2"; shift 2 ;;
            -h|--help) usage ;;
            *) log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done
}

main() {
    parse_args "$@"

    if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" = "false" ]; then
        log "ERROR" "Root privileges required for installation. Use sudo."
        exit 1
    fi

    install
}

main "$@"