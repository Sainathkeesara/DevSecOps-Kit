#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
CIRCLECI_VERSION="${CIRCLECI_VERSION:-3.0.1}"
INSTALL_DIR="/opt/circleci"
AGENT_USER="circleci"
AGENT_GROUP="circleci"
CONFIG_DIR="/etc/circleci"
TOKEN="${CIRCLECI_TOKEN:-}"
RESOURCE_CLASS="${RESOURCE_CLASS:-}"
AGENT_NAME="${AGENT_NAME:-}"
RUNNER_NAME="${RUNNER_NAME:-}"
MAX_RUNS="${MAX_RUNS:-1}"
LABELS="${LABELS:-}"
WORK_DIR="${WORK_DIR:-/var/lib/circleci-runner}"
DISTRIBUTOR_URL="${DISTRIBUTOR_URL:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    local level="$1"
    shift
    echo -e "${GREEN}[$(date '+%Y-%m-%dT%H:%M:%S%z')]${NC} [${level}] $*"
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

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure CircleCI self-hosted runner for CI/CD pipeline execution.

CircleCI self-hosted runners allow you to execute CI/CD jobs on your own
infrastructure with custom resource classes, labels, and namespace support.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --version VERSION     CircleCI runner version (default: 3.0.1)
    --install-dir DIR     Installation directory (default: /opt/circleci)
    --token TOKEN         CircleCI runner token (required, or set CIRCLECI_TOKEN)
    --resource-class RC   Resource class (e.g., namespace/name)
    --name NAME           Runner name (default: hostname)
    --labels LABELS       Comma-separated list of labels
    --max-runs N          Maximum concurrent runs (default: 1)
    --work-dir DIR        Working directory (default: /var/lib/circleci-runner)
    --namespace NS        CircleCI namespace (required for resource class)
    --uninstall           Remove CircleCI runner and configuration
    -h, --help            Show this help message

EXAMPLES:
    # Basic installation with token
    $0 --token abc123def456

    # Custom resource class and labels
    $0 --token abc123 --resource-class my-namespace/linux --labels "linux,x64,docker"

    # Dry-run to preview
    $0 --dry-run --token abc123 --resource-class my-namespace/linux

    # Uninstall runner
    $0 --uninstall

ENVIRONMENT VARIABLES:
    CIRCLECI_TOKEN        Runner token (overrides --token)
    CIRCLECI_VERSION      Runner version (overrides --version)
    CIRCLECI_RESOURCE_CLASS Resource class (overrides --resource-class)
    CIRCLECI_LABELS       Runner labels (overrides --labels)

EOF
    exit 0
}

download_runner() {
    local version="$1"
    local arch="$2"
    local tmp_dir="$3"

    local base_url="https://circleci-public.s3.amazonaws.com/runner"
    local download_url="${base_url}/circleci-runner_${version}_${arch}.tar.gz"

    case "$arch" in
        x86_64|amd64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)
            log "ERROR" "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    download_url="${base_url}/circleci-runner_${version}_${arch}.tar.gz"

    log "INFO" "Downloading CircleCI runner from: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download: $download_url"
        log "DRY-RUN" "Would extract to: ${tmp_dir}"
        return 0
    fi

    curl -fsSL "$download_url" -o "${tmp_dir}/circleci-runner.tar.gz"
    log "INFO" "Download complete."
}

install_runner() {
    local version="$1"
    local install_dir="$2"
    local token="$3"
    local resource_class="$4"
    local runner_name="$5"
    local max_runs="$6"
    local labels="$7"
    local work_dir="$8"

    log "INFO" "Installing CircleCI runner v${version}..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would install runner to: $install_dir"
        log "DRY-RUN" "Would create system user: $AGENT_USER"
        log "DRY-RUN" "Would create config directory: $CONFIG_DIR"
        log "DRY-RUN" "Would create systemd service"
        return 0
    fi

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    download_runner "$version" "$(uname -m)" "$tmp_dir"

    log "INFO" "Extracting archive..."
    tar -xzf "${tmp_dir}/circleci-runner.tar.gz" -C "$tmp_dir"

    local binary_src
    binary_src=$(find "$tmp_dir" -name "circleci-runner" -o -name "runner" 2>/dev/null | head -1)

    if [ -z "$binary_src" ]; then
        binary_src=$(find "$tmp_dir" -type f -executable 2>/dev/null | head -1)
    fi

    if [ -z "$binary_src" ]; then
        log "ERROR" "Could not find CircleCI runner binary in archive"
        exit 1
    fi

    mkdir -p "$install_dir"
    cp "$binary_src" "${install_dir}/circleci-runner"
    chmod +x "${install_dir}/circleci-runner"
    log "INFO" "Installed binary to ${install_dir}/circleci-runner"

    if ! id "$AGENT_USER" &>/dev/null; then
        log "INFO" "Creating system user: $AGENT_USER"
        useradd --system --no-create-home --home-dir /nonexistent --shell /usr/sbin/nologin "$AGENT_USER"
    fi

    mkdir -p "$CONFIG_DIR"
    chown "$AGENT_USER:$AGENT_GROUP" "$CONFIG_DIR"

    local runner_config_json="${CONFIG_DIR}/runner-config.json"
    cat > "$runner_config_json" <<RUNNERCFG
{
  "api": {
    "auth_token": "$token"
  },
  "runner": {
    "name": "${runner_name}",
    "resource_class": "${resource_class}",
    "max_runups": ${max_runs},
    "working_directory": "${work_dir}",
    "labels": [${labels}]
  }
}
RUNNERCFG

    chown "$AGENT_USER:$AGENT_GROUP" "$runner_config_json"
    chmod 600 "$runner_config_json"

    mkdir -p "$work_dir"
    chown "$AGENT_USER:$AGENT_GROUP" "$work_dir"

    log "INFO" "Creating systemd service..."
    cat > /etc/systemd/system/circleci-runner.service <<SYSTEMD
[Unit]
Description=CircleCI Runner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${AGENT_USER}
Group=${AGENT_GROUP}
ExecStart=${install_dir}/circleci-runner start --config ${runner_config_json}
Restart=always
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
SYSTEMD

    systemctl daemon-reload
    systemctl enable circleci-runner
    systemctl start circleci-runner

    sleep 3

    if systemctl is-active --quiet circleci-runner; then
        log "INFO" "CircleCI runner started successfully."
        log "INFO" "Resource class: $resource_class"
        log "INFO" "Runner name: $runner_name"
        log "INFO" "Max concurrent runs: $max_runs"
    else
        log "ERROR" "CircleCI runner failed to start. Check: journalctl -u circleci-runner"
        return 1
    fi
}

uninstall_runner() {
    log "INFO" "Uninstalling CircleCI runner..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would stop and disable circleci-runner service"
        log "DRY-RUN" "Would remove files in $CONFIG_DIR and $INSTALL_DIR"
        return 0
    fi

    if systemctl is-active --quiet circleci-runner; then
        log "INFO" "Stopping circleci-runner service..."
        systemctl stop circleci-runner
    fi

    systemctl disable circleci-runner || true
    rm -f /etc/systemd/system/circleci-runner.service
    systemctl daemon-reload

    rm -rf "$CONFIG_DIR"
    rm -rf "$INSTALL_DIR/circleci-runner"
    rm -rf "$WORK_DIR"

    if id "$AGENT_USER" &>/dev/null; then
        log "INFO" "Removing system user: $AGENT_USER"
        userdel "$AGENT_USER" || true
    fi

    log "INFO" "CircleCI runner uninstalled successfully."
}

verify_installation() {
    log "INFO" "Verifying installation..."

    if [ ! -x "${INSTALL_DIR}/circleci-runner" ]; then
        log "ERROR" "Binary not found at ${INSTALL_DIR}/circleci-runner"
        return 1
    fi

    if ! systemctl is-enabled circleci-runner &>/dev/null; then
        log "WARN" "Service is not enabled."
    fi

    if ! systemctl is-active --quiet circleci-runner; then
        log "ERROR" "Service is not running."
        return 1
    fi

    log "INFO" "CircleCI runner binary: ${INSTALL_DIR}/circleci-runner"
    "${INSTALL_DIR}/circleci-runner" version 2>/dev/null || "${INSTALL_DIR}/circleci-runner" --version 2>/dev/null || true

    log "INFO" "Service status: active"
    log "INFO" "Config directory: $CONFIG_DIR"
    log "INFO" "Verification successful."
}

UNINSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        --version)
            CIRCLECI_VERSION="$2"
            shift 2
            ;;
        --install-dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --token)
            TOKEN="$2"
            shift 2
            ;;
        --resource-class)
            RESOURCE_CLASS="$2"
            shift 2
            ;;
        --name)
            RUNNER_NAME="$2"
            shift 2
            ;;
        --labels)
            LABELS="$2"
            shift 2
            ;;
        --max-runs)
            MAX_RUNS="$2"
            shift 2
            ;;
        --work-dir)
            WORK_DIR="$2"
            shift 2
            ;;
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            log "ERROR" "Unknown option: $1"
            usage
            ;;
    esac
done

TOKEN="${TOKEN:-${CIRCLECI_TOKEN:-}}"
RESOURCE_CLASS="${RESOURCE_CLASS:-${CIRCLECI_RESOURCE_CLASS:-}}"
LABELS="${LABELS:-${CIRCLECI_LABELS:-}}"

if [ -z "$RUNNER_NAME" ]; then
    RUNNER_NAME="$(hostname)-$(date +%s)"
fi

if [ "$UNINSTALL" = false ] && [ -z "$TOKEN" ]; then
    log "ERROR" "CircleCI token is required. Use --token or set CIRCLECI_TOKEN."
    exit 1
fi

check_root
check_dependencies
detect_os

if [ "$UNINSTALL" = true ]; then
    uninstall_runner
else
    install_runner "$CIRCLECI_VERSION" "$INSTALL_DIR" "$TOKEN" "$RESOURCE_CLASS" "$RUNNER_NAME" "$MAX_RUNS" "$LABELS" "$WORK_DIR"
    verify_installation
fi

log "INFO" "Script execution completed."