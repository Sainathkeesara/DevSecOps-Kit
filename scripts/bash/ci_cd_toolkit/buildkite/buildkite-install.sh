#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
BUILDKITE_VERSION="${BUILDKITE_VERSION:-3.58.0}"
INSTALL_DIR="/usr/local/bin"
AGENT_USER="buildkite-agent"
AGENT_GROUP="buildkite-agent"
CONFIG_DIR="/etc/buildkite-agent"
TOKEN="${BUILDKITE_TOKEN:-}"
TAGS="${BUILDKITE_TAGS:-}"
MAX_RUNS="${MAX_RUNS:-1}"
QUEUE="${BUILDKITE_QUEUE:-default}"
METRICS="${BUILDKITE_METRICS:-true}"
LOG_LEVEL="${LOG_LEVEL:-info}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure Buildkite agent for CI/CD pipeline execution.

Buildkite is a distributed CI/CD platform that runs builds in containers
on your own infrastructure. This script installs and configures the
Buildkite agent as a systemd service with customizable tags and queues.

OPTIONS:
    --dry-run             Preview installation steps without executing (default: false)
    --version VERSION     Buildkite agent version (default: 3.58.0)
    --install-dir DIR     Installation directory for binary (default: /usr/local/bin)
    --token TOKEN         Buildkite agent token (required, or set BUILDKITE_TOKEN env)
    --tags TAGS           Comma-separated list of agent tags (e.g., "linux,x64,docker")
    --queue QUEUE         Agent queue name (default: default)
    --max-runs N          Maximum concurrent runs (default: 1)
    --metrics true|false  Enable/disable metrics collection (default: true)
    --log-level LEVEL     Logging level: debug,info,warn,error (default: info)
    --uninstall           Remove Buildkite agent and configuration
    -h, --help           Show this help message

EXAMPLES:
    # Basic installation with token
    $0 --token abc123def456ghi789

    # Dry-run to preview
    $0 --dry-run --token abc123

    # Custom tags and queue
    $0 --token abc123 --tags "linux,amd64,highmem" --queue high-priority

    # Multiple concurrent builds
    $0 --token abc123 --max-runs 2

    # Uninstall agent
    $0 --uninstall

ENVIRONMENT VARIABLES:
    BUILDKITE_TOKEN       Agent token (overrides --token)
    BUILDKITE_TAGS        Agent tags (overrides --tags)
    BUILDKITE_QUEUE       Queue name (overrides --queue)
    MAX_RUNS              Max concurrent runs (overrides --max-runs)
    BUILDKITE_METRICS     Enable metrics (overrides --metrics)
    LOG_LEVEL             Log level (overrides --log-level)

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

get_download_url() {
    local version="$1"
    local arch="$2"

    case "$arch" in
        x86_64|amd64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        armv7l) arch="armhf" ;;
        *)
            log "ERROR" "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    echo "https://github.com/buildkite/agent/releases/download/v${version}/buildkite-agent-linux-${arch}.tar.gz"
}

install_buildkite() {
    local version="$1"
    local install_dir="$2"
    local token="$3"
    local tags="$4"
    local queue="$5"
    local max_runs="$6"
    local metrics="$7"
    local log_level="$8"

    log "INFO" "Installing Buildkite agent v${version}..."

    local download_url
    download_url=$(get_download_url "$version" "$(uname -m)")

    log "INFO" "Downloading from: $download_url"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download: $download_url"
        log "DRY-RUN" "Would extract to: $install_dir"
        log "DRY-RUN" "Would create system user: $AGENT_USER"
        log "DRY-RUN" "Would create config directory: $CONFIG_DIR"
        log "DRY-RUN" "Would create systemd service"
        return 0
    fi

    # Download and extract
    log "INFO" "Downloading Buildkite agent..."
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    curl -fsSL "$download_url" -o "${tmp_dir}/buildkite-agent.tar.gz"

    log "INFO" "Extracting archive..."
    tar -xzf "${tmp_dir}/buildkite-agent.tar.gz" -C "$tmp_dir"

    # Find the binary in extracted files
    local binary_src
    binary_src=$(find "$tmp_dir" -name "buildkite-agent" -type f | head -1)

    if [ -z "$binary_src" ]; then
        log "ERROR" "Could not find buildkite-agent binary in archive"
        exit 1
    fi

    # Create install directory if needed
    mkdir -p "$install_dir"

    # Copy binary
    cp "$binary_src" "${install_dir}/buildkite-agent"
    chmod +x "${install_dir}/buildkite-agent"
    log "INFO" "Installed binary to ${install_dir}/buildkite-agent"

    # Create system user
    if ! id "$AGENT_USER" &>/dev/null; then
        log "INFO" "Creating system user: $AGENT_USER"
        useradd --system --no-create-home --home-dir /nonexistent "$AGENT_USER"
    fi

    # Create config directory
    mkdir -p "$CONFIG_DIR"
    chown "$AGENT_USER:$AGENT_GROUP" "$CONFIG_DIR"

    # Generate token file
    echo "$token" > "${CONFIG_DIR}/token"
    chmod 600 "${CONFIG_DIR}/token"
    chown "$AGENT_USER:$AGENT_GROUP" "${CONFIG_DIR}/token"

    # Generate configuration
    log "INFO" "Generating agent configuration..."
    local tags_array=()
    if [ -n "$tags" ]; then
        IFS=',' read -ra tags_array <<< "$tags"
    fi
    if [ ${#tags_array[@]} -gt 0 ]; then
        printf -v tags_quoted '"%s",' "${tags_array[@]}"
        tags_quoted="${tags_quoted%,}"
    else
        tags_quoted=""
    fi

    cat > "${CONFIG_DIR}/agent.cfg" <<AGENTCFG
--- # Buildkite Agent Configuration
tags: [${tags_quoted}]
name: "$(hostname)"
tags-from-file: "/etc/buildkite-agent/tags"
queue: "$queue"
max-run-builds: $max_runs
metrics: $metrics
log-level: "$log_level"
disconnect-after-job: false
spawn-method: "process"
hooks-path: "/etc/buildkite-agent/hooks"
agent-directory: "/var/lib/buildkite-agent"
temporary-directory: "/tmp/buildkite"
debug-args: []
AGENTCFG

    chown "$AGENT_USER:$AGENT_GROUP" "${CONFIG_DIR}/agent.cfg"
    chmod 640 "${CONFIG_DIR}/agent.cfg"

    # Create hooks directory
    mkdir -p "${CONFIG_DIR}/hooks"

    # Create systemd service
    log "INFO" "Creating systemd service..."
    cat > /etc/systemd/system/buildkite-agent.service <<SYSTEMD
[Unit]
Description=Buildkite Agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$AGENT_USER
Group=$AGENT_GROUP
Environment="BUILDKITE_AGENT_TOKEN=$(cat ${CONFIG_DIR}/token)"
ExecStart=${install_dir}/buildkite-agent start --config ${CONFIG_DIR}/agent.cfg
ExecStop=${install_dir}/buildkite-agent stop
Restart=always
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
SYSTEMD

    # Reload systemd
    systemctl daemon-reload

    # Enable and start service
    systemctl enable buildkite-agent
    systemctl start buildkite-agent

    sleep 2

    if systemctl is-active --quiet buildkite-agent; then
        log "INFO" "Buildkite agent started successfully."
        log "INFO" "Agent token: ${token:0:8}..."
        log "INFO" "Agent tags: $tags"
        log "INFO" "Agent queue: $queue"
    else
        log "ERROR" "Buildkite agent failed to start. Check: journalctl -u buildkite-agent"
        return 1
    fi
}

uninstall_buildkite() {
    log "INFO" "Uninstalling Buildkite agent..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would stop and disable buildkite-agent service"
        log "DRY-RUN" "Would remove files in $CONFIG_DIR and $INSTALL_DIR/buildkite-agent"
        return 0
    fi

    # Stop service
    if systemctl is-active --quiet buildkite-agent; then
        log "INFO" "Stopping buildkite-agent service..."
        systemctl stop buildkite-agent
    fi

    systemctl disable buildkite-agent || true
    rm -f /etc/systemd/system/buildkite-agent.service
    systemctl daemon-reload

    rm -rf "$CONFIG_DIR"
    rm -f "${INSTALL_DIR}/buildkite-agent"

    # Remove user
    if id "$AGENT_USER" &>/dev/null; then
        log "INFO" "Removing system user: $AGENT_USER"
        userdel "$AGENT_USER" || true
    fi

    log "INFO" "Buildkite agent uninstalled successfully."
}

verify_installation() {
    log "INFO" "Verifying installation..."

    if [ ! -x "${INSTALL_DIR}/buildkite-agent" ]; then
        log "ERROR" "Binary not found at ${INSTALL_DIR}/buildkite-agent"
        return 1
    fi

    if ! systemctl is-enabled buildkite-agent &>/dev/null; then
        log "WARN" "Service is not enabled."
    fi

    if ! systemctl is-active --quiet buildkite-agent; then
        log "ERROR" "Service is not running."
        return 1
    fi

    log "INFO" "Buildkite agent binary: ${INSTALL_DIR}/buildkite-agent"
    "${INSTALL_DIR}/buildkite-agent" --version || true

    log "INFO" "Service status: active"
    log "INFO" "Config directory: $CONFIG_DIR"
    log "INFO" "Verification successful."
}

# Parse arguments
UNINSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        --version)
            BUILDKITE_VERSION="$2"
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
        --tags)
            TAGS="$2"
            shift 2
            ;;
        --queue)
            QUEUE="$2"
            shift 2
            ;;
        --max-runs)
            MAX_RUNS="$2"
            shift 2
            ;;
        --metrics)
            METRICS="$2"
            shift 2
            ;;
        --log-level)
            LOG_LEVEL="$2"
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

# Use environment token if not provided via flag
TOKEN="${TOKEN:-${BUILDKITE_TOKEN:-}}"

# Validate required token
if [ "$UNINSTALL" = false ] && [ -z "$TOKEN" ]; then
    log "ERROR" "Buildkite token is required. Use --token or set BUILDKITE_TOKEN."
    exit 1
fi

# Main execution
check_root
check_dependencies
detect_os

if [ "$UNINSTALL" = true ]; then
    uninstall_buildkite
else
    install_buildkite "$BUILDKITE_VERSION" "$INSTALL_DIR" "$TOKEN" "$TAGS" "$QUEUE" "$MAX_RUNS" "$METRICS" "$LOG_LEVEL"
    verify_installation
fi

log "INFO" "Script execution completed."
