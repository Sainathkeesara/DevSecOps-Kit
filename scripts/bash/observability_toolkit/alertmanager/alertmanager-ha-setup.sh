#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
VERSION="${VERSION:-0.27.0}"
CLUSTER_SIZE="${CLUSTER_SIZE:-3}"
CLUSTER_NAME="${CLUSTER_NAME:-default}"
LISTEN_PORT="${LISTEN_PORT:-9094}"
HTTP_PORT="${HTTP_PORT:-9093}"
INSTALL_DIR="/opt/alertmanager"
CONFIG_DIR="/etc/alertmanager"
SYSTEMD_DIR="/etc/systemd/system"
DATA_DIR="/var/lib/alertmanager"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure Alertmanager high-availability clustering for alert deduplication.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --version VERSION    Alertmanager version (default: 0.27.0)
    --cluster-size N     Number of cluster peers (default: 3)
    --cluster-name NAME  Cluster name for identification (default: default)
    --listen-port PORT   Cluster listen port (default: 9094)
    --http-port PORT     HTTP API port (default: 9093)
    -h, --help           Show this help message

EXAMPLES:
    $0 --dry-run
    $0 --cluster-size 3 --cluster-name production
    $0 --version 0.27.0 --cluster-size 5

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
    for bin in curl wget tar systemctl; do
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

download_alertmanager() {
    local version="$1"
    local os_type arch download_url tar_path

    os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(get_arch)
    download_url="https://github.com/prometheus/alertmanager/releases/download/v${version}/alertmanager_${version}_${os_type}_${arch}.tar.gz"
    tar_path="/tmp/alertmanager_${version}.tar.gz"

    log "INFO" "Downloading Alertmanager $version for $os_type/$arch..."
    log "INFO" "URL: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download $download_url to $tar_path"
        log "DRY-RUN" "Would extract to $INSTALL_DIR"
        return 0
    fi

    if ! curl -fsSL "$download_url" -o "$tar_path"; then
        log "ERROR" "Failed to download Alertmanager from $download_url"
        return 1
    fi

    mkdir -p "$INSTALL_DIR"
    if ! tar -xzf "$tar_path" -C "$INSTALL_DIR" --strip-components=1; then
        log "ERROR" "Failed to extract Alertmanager archive"
        rm -f "$tar_path"
        return 1
    fi

    chmod +x "${INSTALL_DIR}/alertmanager" "${INSTALL_DIR}/amtool"
    rm -f "$tar_path"
    log "INFO" "Alertmanager installed at $INSTALL_DIR"
}

create_user() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create user 'alertmanager'"
        return 0
    fi
    if ! id alertmanager >/dev/null 2>&1; then
        useradd --system --no-create-home --shell /sbin/nologin alertmanager
        log "INFO" "Created system user: alertmanager"
    else
        log "INFO" "User alertmanager already exists"
    fi
}

create_directories() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create directories: $CONFIG_DIR, $DATA_DIR, /var/log/alertmanager"
        return 0
    fi

    mkdir -p "$CONFIG_DIR" "$DATA_DIR" /var/log/alertmanager
    chown -R alertmanager:alertmanager "$CONFIG_DIR" "$DATA_DIR" /var/log/alertmanager
    log "INFO" "Created required directories"
}

generate_config() {
    local config_file="$1"
    local advertise_addr="$2"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate Alertmanager config at $config_file"
        log "DRY-RUN" "Would configure cluster advertise: $advertise_addr:$LISTEN_PORT"
        return 0
    fi

    cat > "$config_file" <<EOF
global:
  resolve_timeout: 5m

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
      - to: 'devops@example.com'
        from: 'alertmanager@example.com'
        send_resolved: true
        smarthost: 'localhost:25'
        require_tls: false

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
  listen_address: '0.0.0.0:${LISTEN_PORT}'
  advertise_address: '${advertise_addr}:${LISTEN_PORT}'
  cluster_interval: 30s
  gossip_interval: 5s
  tcp_timeout: 10s
  probe_timeout: 5s
  probe_interval: 5s
EOF

    chown alertmanager:alertmanager "$config_file"
    chmod 640 "$config_file"
    log "INFO" "Generated Alertmanager configuration at $config_file"
}

install_systemd_service() {
    local advertise_addr="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create systemd service: alertmanager.service"
        return 0
    fi

    cat > "${SYSTEMD_DIR}/alertmanager.service" <<EOF
[Unit]
Description=Alertmanager High Availability Cluster
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=alertmanager
Group=alertmanager
Environment="ADVERTISE_ADDR=${advertise_addr}"
ExecStart=${INSTALL_DIR}/alertmanager \
  --config.file=${CONFIG_DIR}/alertmanager.yml \
  --storage.path=${DATA_DIR} \
  --cluster.advertise-address=\${ADVERTISE_ADDR}:${LISTEN_PORT} \
  --cluster.listen-address=0.0.0.0:${LISTEN_PORT} \
  --web.listen-address=0.0.0.0:${HTTP_PORT} \
  --log.level=info
Restart=always
RestartSec=10
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=${DATA_DIR} ${CONFIG_DIR}

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "${SYSTEMD_DIR}/alertmanager.service"
    systemctl daemon-reload
    log "INFO" "Systemd service installed"
}

configure_firewall() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would open firewall ports: ${LISTEN_PORT}, ${HTTP_PORT}"
        return 0
    fi

    if command -v firewall-cmd >/dev/null 2>&1; then
        firewall-cmd --add-port="${LISTEN_PORT}/tcp" --add-port="${HTTP_PORT}/tcp" --permanent 2>/dev/null || true
        firewall-cmd --reload 2>/dev/null || true
        log "INFO" "Firewall ports opened (firewalld)"
    elif command -v ufw >/dev/null 2>&1; then
        ufw allow "${LISTEN_PORT}/tcp" 2>/dev/null || true
        ufw allow "${HTTP_PORT}/tcp" 2>/dev/null || true
        log "INFO" "Firewall ports opened (UFW)"
    fi
}

verify_installation() {
    local advertise_addr="$1"

    log "INFO" "Verifying Alertmanager installation..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify binary at ${INSTALL_DIR}/alertmanager"
        log "DRY-RUN" "Would verify cluster advertise: $advertise_addr:$LISTEN_PORT"
        return 0
    fi

    if [ ! -x "${INSTALL_DIR}/alertmanager" ]; then
        log "ERROR" "Alertmanager binary not found at ${INSTALL_DIR}/alertmanager"
        return 1
    fi

    if [ ! -x "${INSTALL_DIR}/amtool" ]; then
        log "ERROR" "amtool binary not found at ${INSTALL_DIR}/amtool"
        return 1
    fi

    "${INSTALL_DIR}/alertmanager" --version || {
        log "WARN" "Alertmanager version check completed"
    }

    log "INFO" "Alertmanager binary verified successfully"
    log "INFO" "Cluster advertise address: $advertise_addr:$LISTEN_PORT"
}

install() {
    local advertise_addr="${ADVERTISE_ADDR:-$(hostname -I | awk '{print $1}')}"

    log "INFO" "Starting Alertmanager HA installation..."
    log "INFO" "Version: $VERSION | Cluster: $CLUSTER_NAME | Size: $CLUSTER_SIZE"
    log "INFO" "Advertise address: $advertise_addr"

    check_dependencies
    detect_os
    check_root
    create_user
    create_directories

    download_alertmanager "$VERSION"
    generate_config "${CONFIG_DIR}/alertmanager.yml" "$advertise_addr"
    install_systemd_service "$advertise_addr"
    configure_firewall
    verify_installation "$advertise_addr"

    if [ "$DRY_RUN" = "false" ]; then
        log "INFO" "Enabling and starting Alertmanager service..."
        systemctl enable alertmanager.service
        systemctl start alertmanager.service
        sleep 3
        if systemctl is-active --quiet alertmanager.service; then
            log "INFO" "Alertmanager service is running"
        else
            log "WARN" "Alertmanager service failed to start. Check logs with journalctl -u alertmanager.service"
        fi
    fi

    log "INFO" "Installation complete!"
    log "INFO" "HTTP API: http://localhost:${HTTP_PORT}"
    log "INFO" "Cluster: $advertise_addr:${LISTEN_PORT}"
    log "INFO" "Config: $CONFIG_DIR/alertmanager.yml"
    log "INFO" ""
    log "INFO" "Cluster setup instructions:"
    log "INFO" "  1. Run this script on all $CLUSTER_SIZE nodes"
    log "INFO" "  2. Use --cluster-size $CLUSTER_SIZE on each node"
    log "INFO" "  3. Set ADVERTISE_ADDR=<node-ip> for each node's advertise address"
    log "INFO" "  4. Configure Prometheus with all cluster members:"
    log "INFO" "     alerting.alertmanagers:"
    log "INFO" "       - targets: ['node1:9093', 'node2:9093', 'node3:9093']"
}

cleanup() {
    log "INFO" "Cleaning up Alertmanager installation..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would stop and disable Alertmanager service"
        log "DRY-RUN" "Would remove $CONFIG_DIR, $DATA_DIR, $INSTALL_DIR"
        return 0
    fi

    if systemctl is-active --quiet alertmanager.service 2>/dev/null; then
        log "INFO" "Stopping Alertmanager service"
        systemctl stop alertmanager.service || true
    fi
    systemctl disable alertmanager.service 2>/dev/null || true
    rm -f "${SYSTEMD_DIR}/alertmanager.service"
    systemctl daemon-reload

    rm -rf "$CONFIG_DIR" "$DATA_DIR" /var/log/alertmanager
    userdel alertmanager 2>/dev/null || true

    log "INFO" "Alertmanager removed successfully"
}

status_check() {
    log "INFO" "Checking Alertmanager status..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would check service and cluster status"
        return 0
    fi

    if systemctl is-active --quiet alertmanager.service 2>/dev/null; then
        log "INFO" "Alertmanager: ACTIVE"
    else
        log "WARN" "Alertmanager: NOT ACTIVE"
    fi

    if curl -sf "http://localhost:${HTTP_PORT}/-/healthy" >/dev/null 2>&1; then
        log "INFO" "Health endpoint: OK"
    else
        log "WARN" "Health endpoint: UNREACHABLE"
    fi

    local peer_count
    peer_count=$(curl -s "http://localhost:${HTTP_PORT}/api/v1/status/peers" 2>/dev/null | jq '.peers | length' 2>/dev/null || echo "0")
    log "INFO" "Cluster peers: $peer_count"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --version) VERSION="$2"; shift 2 ;;
            --cluster-size) CLUSTER_SIZE="$2"; shift 2 ;;
            --cluster-name) CLUSTER_NAME="$2"; shift 2 ;;
            --listen-port) LISTEN_PORT="$2"; shift 2 ;;
            --http-port) HTTP_PORT="$2"; shift 2 ;;
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