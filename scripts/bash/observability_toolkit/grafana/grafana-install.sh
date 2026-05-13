#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
GRAFANA_VERSION="${GRAFANA_VERSION:-10.4.0}"
INSTALL_DIR="/opt/grafana"
CONFIG_DIR="/etc/grafana"
SYSTEMD_DIR="/etc/systemd/system"
DATA_DIR="/var/lib/grafana"
LOG_DIR="/var/log/grafana"
HTTP_PORT="${HTTP_PORT:-3000}"
PROTOCOL="${PROTOCOL:-http}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure Grafana for metric visualization with Prometheus data source.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --version VERSION     Grafana version (default: 10.4.0)
    --install-dir DIR     Installation directory (default: /opt/grafana)
    --http-port PORT      HTTP port for Grafana (default: 3000)
    --protocol PROTO      Protocol to use: http or https (default: http)
    -h, --help           Show this help message

EXAMPLES:
    $0 --dry-run
    $0 --version 10.4.0
    $0 --http-port 3000 --protocol https
    DRY_RUN=true $0

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

download_grafana() {
    local version="$1"
    local install_dir="$2"
    local arch
    arch=$(get_arch)
    local os_type
    os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    local download_url="https://dl.grafana.com/oss/release/grafana-${version}.${os_type}-${arch}.tar.gz"
    local tar_path="/tmp/grafana_${version}.tar.gz"

    log "INFO" "Downloading Grafana $version for $os_type/$arch..."
    log "INFO" "URL: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download $download_url to $tar_path"
        log "DRY-RUN" "Would extract to $install_dir"
        return 0
    fi

    if ! curl -fsSL "$download_url" -o "$tar_path"; then
        log "ERROR" "Failed to download Grafana from $download_url"
        return 1
    fi

    mkdir -p "$install_dir"
    if ! tar -xzf "$tar_path" -C "$install_dir" --strip-components=1; then
        log "ERROR" "Failed to extract Grafana archive"
        rm -f "$tar_path"
        return 1
    fi

    rm -f "$tar_path"
    log "INFO" "Grafana installed at $install_dir"
}

create_user() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create user 'grafana'"
        return 0
    fi
    if ! id grafana >/dev/null 2>&1; then
        useradd --system --no-create-home --shell /usr/sbin/nologin grafana
        log "INFO" "Created system user: grafana"
    else
        log "INFO" "User grafana already exists"
    fi
}

create_directories() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create directories: $CONFIG_DIR, $DATA_DIR, $LOG_DIR"
        return 0
    fi

    mkdir -p "$CONFIG_DIR" "$DATA_DIR" "$LOG_DIR"
    chown -R grafana:grafana "$INSTALL_DIR" "$DATA_DIR" "$LOG_DIR"
    log "INFO" "Created required directories"
}

generate_config() {
    local config_file="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate Grafana config at $config_file"
        return 0
    fi

    cat > "$config_file" <<EOF
[server]
http_addr = 0.0.0.0
http_port = ${HTTP_PORT}
protocol = ${PROTOCOL}

[paths]
data = ${DATA_DIR}
logs = ${LOG_DIR}

[security]
admin_user = admin
admin_password = admin123

[auth]
disable_login_form = false

[users]
allow_sign_up = false
allow_org_create = false
auto_assign_org = true

[auth.anonymous]
enabled = false

[auth.basic]
enabled = true

[session]
provider = file
provider_config = ${DATA_DIR}/sessions
EOF

    chown grafana:grafana "$config_file"
    chmod 640 "$config_file"
    log "INFO" "Generated Grafana configuration at $config_file"
}

generate_datasource_config() {
    local datasource_file="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate Prometheus data source config at $datasource_file"
        return 0
    fi

    cat > "$datasource_file" <<'EOF'
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
EOF

    log "INFO" "Generated Prometheus data source configuration at $datasource_file"
}

install_systemd_service() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create systemd service: grafana-server.service"
        return 0
    fi

    cat > "${SYSTEMD_DIR}/grafana-server.service" <<EOF
[Unit]
Description=Grafana Visualization Server
After=network.target

[Service]
Type=simple
User=grafana
Group=grafana
ExecStart=${INSTALL_DIR}/bin/grafana-server \
    --config=${CONFIG_DIR}/grafana.ini \
    --homepath=${INSTALL_DIR}
Restart=always
RestartSec=10
EnvironmentFile=-etc/default/grafana-server
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=${DATA_DIR} ${LOG_DIR} ${CONFIG_DIR}

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "${SYSTEMD_DIR}/grafana-server.service"
    systemctl daemon-reload
    log "INFO" "Systemd service installed"
}

configure_firewall() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would open firewall port: ${HTTP_PORT}"
        return 0
    fi

    if command -v firewall-cmd >/dev/null 2>&1; then
        firewall-cmd --add-port="${HTTP_PORT}/tcp" --permanent 2>/dev/null || true
        firewall-cmd --reload 2>/dev/null || true
        log "INFO" "Firewall port opened (firewalld)"
    elif command -v ufw >/dev/null 2>&1; then
        ufw allow "${HTTP_PORT}/tcp" 2>/dev/null || true
        log "INFO" "Firewall port opened (UFW)"
    fi
}

verify_installation() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify Grafana binary at ${INSTALL_DIR}/bin/grafana-server"
        log "DRY-RUN" "Would check HTTP endpoint on port ${HTTP_PORT}"
        return 0
    fi

    if [ ! -x "${INSTALL_DIR}/bin/grafana-server" ]; then
        log "ERROR" "Grafana binary not found at ${INSTALL_DIR}/bin/grafana-server"
        return 1
    fi

    "${INSTALL_DIR}/bin/grafana-server" -v || {
        log "WARN" "Grafana version check completed"
    }

    log "INFO" "Grafana binary verified successfully"
    log "INFO" "Web interface: ${PROTOCOL}://localhost:${HTTP_PORT}"
    log "INFO" "Default credentials: admin / admin123"
}

install() {
    log "INFO" "Starting Grafana installation..."
    log "INFO" "Version: $GRAFANA_VERSION | Port: $HTTP_PORT | Protocol: $PROTOCOL"

    check_dependencies
    detect_os
    check_root
    create_user
    create_directories

    download_grafana "$GRAFANA_VERSION" "$INSTALL_DIR"
    generate_config "${CONFIG_DIR}/grafana.ini"
    generate_datasource_config "${CONFIG_DIR}/provisioning/datasources/prometheus.yml"
    install_systemd_service
    configure_firewall
    verify_installation

    if [ "$DRY_RUN" = "false" ]; then
        log "INFO" "Enabling and starting Grafana service..."
        systemctl enable grafana-server.service
        systemctl start grafana-server.service
        sleep 5
        if systemctl is-active --quiet grafana-server.service; then
            log "INFO" "Grafana service is running"
        else
            log "WARN" "Grafana service failed to start. Check logs with journalctl -u grafana-server.service"
        fi
    fi

    log "INFO" "Installation complete!"
    log "INFO" ""
    log "INFO" "Access Grafana: ${PROTOCOL}://localhost:${HTTP_PORT}"
    log "INFO" "Default credentials: admin / admin123"
    log "INFO" "Data source config: ${CONFIG_DIR}/provisioning/datasources/prometheus.yml"
    log "INFO" ""
    log "INFO" "Post-installation steps:"
    log "INFO" "  1. Open ${PROTOCOL}://localhost:${HTTP_PORT} in a browser"
    log "INFO" "  2. Log in with admin / admin123"
    log "INFO" "  3. Change the default password immediately"
    log "INFO" "  4. Navigate to Configuration → Data Sources"
    log "INFO" "  5. Verify Prometheus data source (http://localhost:9090)"
    log "INFO" "  6. Import dashboard ID 1860 for Node Exporter metrics"
}

cleanup() {
    log "INFO" "Cleaning up Grafana installation..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would stop and disable Grafana service"
        log "DRY-RUN" "Would remove $CONFIG_DIR, $DATA_DIR, $LOG_DIR, $INSTALL_DIR"
        return 0
    fi

    if systemctl is-active --quiet grafana-server.service 2>/dev/null; then
        log "INFO" "Stopping Grafana service"
        systemctl stop grafana-server.service || true
    fi
    systemctl disable grafana-server.service 2>/dev/null || true
    rm -f "${SYSTEMD_DIR}/grafana-server.service"
    systemctl daemon-reload

    rm -rf "$INSTALL_DIR" "$CONFIG_DIR" "$DATA_DIR" "$LOG_DIR"
    userdel grafana 2>/dev/null || true

    log "INFO" "Grafana removed successfully"
}

status_check() {
    log "INFO" "Checking Grafana status..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would check service and HTTP status"
        return 0
    fi

    if systemctl is-active --quiet grafana-server.service 2>/dev/null; then
        log "INFO" "Grafana: ACTIVE"
    else
        log "WARN" "Grafana: NOT ACTIVE"
    fi

    if curl -sf "${PROTOCOL}://localhost:${HTTP_PORT}/api/health" >/dev/null 2>&1; then
        log "INFO" "Health endpoint: OK"
        curl -sf "${PROTOCOL}://localhost:${HTTP_PORT}/api/health" | jq '.commit' 2>/dev/null || true
    else
        log "WARN" "Health endpoint: UNREACHABLE"
    fi

    if curl -sf "${PROTOCOL}://localhost:${HTTP_PORT}/api/datasources" >/dev/null 2>&1; then
        local ds_count
        ds_count=$(curl -sf "${PROTOCOL}://localhost:${HTTP_PORT}/api/datasources" | jq 'length' 2>/dev/null || echo "0")
        log "INFO" "Configured data sources: $ds_count"
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --version) GRAFANA_VERSION="$2"; shift 2 ;;
            --install-dir) INSTALL_DIR="$2"; shift 2 ;;
            --http-port) HTTP_PORT="$2"; shift 2 ;;
            --protocol) PROTOCOL="$2"; shift 2 ;;
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