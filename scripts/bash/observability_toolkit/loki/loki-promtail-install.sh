#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
LOKI_VERSION="${LOKI_VERSION:-3.2.0}"
PROMTAIL_VERSION="${PROMTAIL_VERSION:-3.2.0}"
INSTALL_DIR="/opt/loki"
CONFIG_DIR="/etc/loki"
SYSTEMD_DIR="/etc/systemd/system"
LOKI_PORT="${LOKI_PORT:-3100}"
PROMTAIL_PORT="${PROMTAIL_PORT:-9080}"
MODE="${MODE:-standalone}"
LOKI_SERVER="${LOKI_SERVER:-localhost}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure Grafana Loki with Promtail for log aggregation and pipeline configuration.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --loki-version VERSION   Loki version (default: 3.2.0)
    --promtail-version VERSION  Promtail version (default: 3.2.0)
    --install-dir DIR     Installation directory (default: /opt/loki)
    --loki-port PORT      Loki server port (default: 3100)
    --promtail-port PORT  Promtail server port (default: 9080)
    --mode MODE           Deployment mode: standalone, server, client (default: standalone)
    --loki-server HOST    Loki server hostname for Promtail (default: localhost)
    -h, --help           Show this help message

MODES:
    standalone  Single node Loki + Promtail (default)
    server      Loki server only (for multi-node setups)
    client      Promtail agent only (connects to remote Loki)

EXAMPLES:
    $0 --dry-run
    $0 --loki-version 3.1.0 --mode server
    $0 --loki-server loki.company.com --mode client
    DRY_RUN=true $0 --promtail-version 3.1.0

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
    for bin in curl tar systemctl jq; do
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

get_arch() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        *) echo "386" ;;
    esac
}

download_loki() {
    local version="$1"
    local install_dir="$2"
    local arch
    arch=$(get_arch)
    local download_url="https://github.com/grafana/loki/releases/download/v${version}/loki_${version}_${arch}.deb"
    local deb_path="/tmp/loki_${version}.deb"

    log "INFO" "Downloading Loki $version for $arch..."
    log "INFO" "URL: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download $download_url to $deb_path"
        log "DRY-RUN" "Would install Loki to $install_dir"
        return 0
    fi

    if ! curl -fsSL "$download_url" -o "$deb_path"; then
        log "ERROR" "Failed to download Loki from $download_url"
        return 1
    fi

    dpkg -i "$deb_path" || apt-get install -f -y
    rm -f "$deb_path"
    log "INFO" "Loki installed successfully"
}

download_promtail() {
    local version="$1"
    local arch
    arch=$(get_arch)
    local download_url="https://github.com/grafana/loki/releases/download/v${version}/promtail_${version}_${arch}.deb"
    local deb_path="/tmp/promtail_${version}.deb"

    log "INFO" "Downloading Promtail $version for $arch..."
    log "INFO" "URL: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download $download_url to $deb_path"
        log "DRY-RUN" "Would install Promtail"
        return 0
    fi

    if ! curl -fsSL "$download_url" -o "$deb_path"; then
        log "ERROR" "Failed to download Promtail from $download_url"
        return 1
    fi

    dpkg -i "$deb_path" || apt-get install -f -y
    rm -f "$deb_path"
    log "INFO" "Promtail installed successfully"
}

create_directories() {
    local mode="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create directories: $CONFIG_DIR, /var/lib/loki, /var/log/loki"
        if [ "$mode" = "standalone" ] || [ "$mode" = "client" ]; then
            log "DRY-RUN" "Would create directories: /var/lib/promtail, /var/log/promtail"
        fi
        return 0
    fi

    mkdir -p "$CONFIG_DIR" /var/lib/loki /var/log/loki
    chown loki:loki /var/lib/loki /var/log/loki

    if [ "$mode" = "standalone" ] || [ "$mode" = "client" ]; then
        mkdir -p /var/lib/promtail /var/log/promtail
        chown promtail:promtail /var/lib/promtail /var/log/promtail
    fi

    log "INFO" "Created required directories"
}

generate_loki_config() {
    local config_file="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate Loki config at $config_file"
        return 0
    fi

    cat > "$config_file" <<EOF
auth_enabled: false

server:
  http_listen_port: ${LOKI_PORT}
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

    chown loki:loki "$config_file"
    chmod 644 "$config_file"
    log "INFO" "Generated Loki configuration at $config_file"
}

generate_promtail_config() {
    local config_file="$1"
    local loki_server="$2"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate Promtail config at $config_file"
        return 0
    fi

    cat > "$config_file" <<EOF
server:
  http_listen_port: ${PROMTAIL_PORT}
  grpc_listen_port: 9081

clients:
  - url: http://${loki_server}:${LOKI_PORT}/loki/api/v1/push
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
          __path__: /var/log/auth.log*

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

    sed -i "s/__HOSTNAME__/$(hostname)/g" "$config_file"
    chown promtail:promtail "$config_file"
    chmod 644 "$config_file"
    log "INFO" "Generated Promtail configuration at $config_file"
}

install_loki_service() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create systemd service: loki.service"
        return 0
    fi

    cat > "${SYSTEMD_DIR}/loki.service" <<EOF
[Unit]
Description=Loki Log Aggregator
After=network.target

[Service]
Type=simple
User=loki
Group=loki
ExecStart=/usr/bin/loki -config.file=${CONFIG_DIR}/loki-config.yaml
Restart=on-failure
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/loki /var/log/loki ${CONFIG_DIR}

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "${SYSTEMD_DIR}/loki.service"
    systemctl daemon-reload
    log "INFO" "Loki systemd service installed"
}

install_promtail_service() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create systemd service: promtail.service"
        return 0
    fi

    cat > "${SYSTEMD_DIR}/promtail.service" <<EOF
[Unit]
Description=Promtail Log Shipper
After=network.target

[Service]
Type=simple
User=promtail
Group=promtail
ExecStart=/usr/bin/promtail -config.file=${CONFIG_DIR}/promtail-config.yaml
Restart=on-failure
RestartSec=10
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/var/lib/promtail /var/log/promtail /var/log ${CONFIG_DIR}

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "${SYSTEMD_DIR}/promtail.service"
    systemctl daemon-reload
    log "INFO" "Promtail systemd service installed"
}

configure_firewall() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would open firewall ports: ${LOKI_PORT}, ${PROMTAIL_PORT}"
        return 0
    fi

    if command -v firewall-cmd >/dev/null 2>&1; then
        firewall-cmd --add-port="${LOKI_PORT}/tcp" --permanent 2>/dev/null || true
        firewall-cmd --add-port="${PROMTAIL_PORT}/tcp" --permanent 2>/dev/null || true
        firewall-cmd --reload 2>/dev/null || true
        log "INFO" "Firewall ports opened"
    elif command -v ufw >/dev/null 2>&1; then
        ufw allow "${LOKI_PORT}/tcp" 2>/dev/null || true
        ufw allow "${PROMTAIL_PORT}/tcp" 2>/dev/null || true
        log "INFO" "UFW ports opened"
    fi
}

verify_installation() {
    log "INFO" "Verifying Loki/Promtail installation..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify Loki binary at /usr/bin/loki"
        log "DRY-RUN" "Would verify Promtail binary at /usr/bin/promtail"
        log "DRY-RUN" "Would check systemd services"
        return 0
    fi

    if command -v loki >/dev/null 2>&1; then
        /usr/bin/loki -version || log "WARN" "Loki version check failed"
        log "INFO" "Loki binary verified"
    else
        log "ERROR" "Loki binary not found at /usr/bin/loki"
        return 1
    fi

    if command -v promtail >/dev/null 2>&1; then
        /usr/bin/promtail -version || log "WARN" "Promtail version check failed"
        log "INFO" "Promtail binary verified"
    else
        log "ERROR" "Promtail binary not found at /usr/bin/promtail"
        return 1
    fi

    log "INFO" "Installation verification complete"
}

install() {
    local mode="$MODE"
    local loki_config="${CONFIG_DIR}/loki-config.yaml"
    local promtail_config="${CONFIG_DIR}/promtail-config.yaml"

    log "INFO" "Starting Loki/Promtail installation..."
    log "INFO" "Loki: $LOKI_VERSION | Promtail: $PROMTAIL_VERSION | Mode: $mode"

    check_dependencies
    detect_os
    check_root
    create_directories "$mode"

    if [ "$mode" = "standalone" ] || [ "$mode" = "server" ]; then
        download_loki "$LOKI_VERSION" "$INSTALL_DIR"
        generate_loki_config "$loki_config"
        install_loki_service
    fi

    if [ "$mode" = "standalone" ] || [ "$mode" = "client" ]; then
        download_promtail "$PROMTAIL_VERSION" "$INSTALL_DIR"
        generate_promtail_config "$promtail_config" "$LOKI_SERVER"
        install_promtail_service
    fi

    configure_firewall
    verify_installation

    if [ "$DRY_RUN" = "false" ]; then
        if [ "$mode" = "standalone" ] || [ "$mode" = "server" ]; then
            log "INFO" "Enabling and starting Loki service..."
            systemctl enable loki.service
            systemctl start loki.service
            sleep 3
            if systemctl is-active --quiet loki.service; then
                log "INFO" "Loki service is running"
            else
                log "WARN" "Loki service failed to start. Check logs with journalctl -u loki.service"
            fi
        fi

        if [ "$mode" = "standalone" ] || [ "$mode" = "client" ]; then
            log "INFO" "Enabling and starting Promtail service..."
            systemctl enable promtail.service
            systemctl start promtail.service
            sleep 3
            if systemctl is-active --quiet promtail.service; then
                log "INFO" "Promtail service is running"
            else
                log "WARN" "Promtail service failed to start. Check logs with journalctl -u promtail.service"
            fi
        fi
    fi

    log "INFO" "Installation complete!"
    log "INFO" "Loki HTTP: http://localhost:${LOKI_PORT}"
    log "INFO" "Promtail: http://localhost:${PROMTAIL_PORT}"
    log "INFO" "Config: $CONFIG_DIR"
}

cleanup() {
    log "INFO" "Cleaning up Loki/Promtail installation..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would stop and disable Loki and Promtail services"
        log "DRY-RUN" "Would remove $CONFIG_DIR and /var/lib/loki"
        return 0
    fi

    for svc in loki promtail; do
        if systemctl is-active --quiet "${svc}.service" 2>/dev/null; then
            systemctl stop "${svc}.service" || true
        fi
        systemctl disable "${svc}.service" 2>/dev/null || true
        rm -f "${SYSTEMD_DIR}/${svc}.service"
    done
    systemctl daemon-reload

    rm -rf "$CONFIG_DIR" /var/lib/loki /var/log/loki /var/lib/promtail /var/log/promtail

    log "INFO" "Cleanup complete"
}

status_check() {
    log "INFO" "Checking Loki/Promtail status..."

    local services=()
    [ "$MODE" = "standalone" ] || [ "$MODE" = "server" ] && services+=("loki")
    [ "$MODE" = "standalone" ] || [ "$MODE" = "client" ] && services+=("promtail")

    for svc in "${services[@]}"; do
        if systemctl is-active --quiet "${svc}.service" 2>/dev/null; then
            log "INFO" "${svc}: ACTIVE"
        else
            log "WARN" "${svc}: NOT ACTIVE"
        fi
    done

    if [ "$MODE" = "standalone" ] || [ "$MODE" = "server" ]; then
        if curl -sf "http://localhost:${LOKI_PORT}/ready" >/dev/null 2>&1; then
            log "INFO" "Loki ready endpoint: OK"
        else
            log "WARN" "Loki ready endpoint: UNREACHABLE"
        fi
    fi

    if [ "$MODE" = "standalone" ] || [ "$MODE" = "client" ]; then
        if curl -sf "http://localhost:${PROMTAIL_PORT}/metrics" >/dev/null 2>&1; then
            log "INFO" "Promtail metrics endpoint: OK"
        else
            log "WARN" "Promtail metrics endpoint: UNREACHABLE"
        fi
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --loki-version) LOKI_VERSION="$2"; shift 2 ;;
            --promtail-version) PROMTAIL_VERSION="$2"; shift 2 ;;
            --install-dir) INSTALL_DIR="$2"; shift 2 ;;
            --loki-port) LOKI_PORT="$2"; shift 2 ;;
            --promtail-port) PROMTAIL_PORT="$2"; shift 2 ;;
            --mode) MODE="$2"; shift 2 ;;
            --loki-server) LOKI_SERVER="$2"; shift 2 ;;
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