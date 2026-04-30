#!/usr/bin/env bash
# GitHub Actions Self-Hosted Runner Installation Script
# Level: L2 | Category: Git | Purpose: Install and configure GitHub Actions self-hosted runners
# Supports: Linux (x64, ARM64), Docker-based runners

set -euo pipefail

# Configuration
RUNNER_VERSION="${RUNNER_VERSION:-2.317.0}"
RUNNER_DIR="${RUNNER_DIR:-/opt/github-runner}"
RUNNER_NAME="${RUNNER_NAME:-$(hostname)-runner}"
RUNNER_LABELS="${RUNNER_LABELS:-linux,x64,auto}"
GITHUB_URL="${GITHUB_URL:-}"
RUNNER_TOKEN="${RUNNER_TOKEN:-}"
DRY_RUN="${DRY_RUN:-false}"
REMOVE_RUNNER="${REMOVE_RUNNER:-false}"
EPHEMERAL="${EPHEMERAL:-false}"
DOCKER_MODE="${DOCKER_MODE:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Dry-run wrapper
run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would execute: $*"
    else
        log_info "Executing: $*"
        eval "$@"
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check architecture
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) RUNNER_ARCH="x64" ;;
        aarch64|arm64) RUNNER_ARCH="arm64" ;;
        *) log_error "Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    log_info "Architecture: $ARCH ($RUNNER_ARCH)"
    
    # Check required commands
    for cmd in curl tar; do
        if ! command -v $cmd &> /dev/null; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    # Validate required parameters
    if [[ -z "$GITHUB_URL" ]]; then
        log_error "GITHUB_URL is required (e.g., https://github.com/owner/repo or https://github.com/org)"
        exit 1
    fi
    
    if [[ "$REMOVE_RUNNER" != "true" ]] && [[ -z "$RUNNER_TOKEN" ]]; then
        log_error "RUNNER_TOKEN is required for installation"
        exit 1
    fi
    
    # Check if running as root for systemd installation
    if [[ "$(id -u)" -eq 0 ]]; then
        SUDO=""
    else
        SUDO="sudo"
        log_warn "Not running as root. systemd installation may fail."
    fi
}

# Download runner
install_runner() {
    local version="$1"
    local arch="$2"
    
    log_info "Installing GitHub Actions Runner v${version} for ${arch}"
    
    run_cmd mkdir -p "$RUNNER_DIR"
    cd "$RUNNER_DIR"
    
    local runner_url="https://github.com/actions/runner/releases/download/v${version}/actions-runner-linux-${arch}-${version}.tar.gz"
    log_info "Downloading runner from: $runner_url"
    
    run_cmd curl -f -o actions-runner.tar.gz -L "$runner_url"
    run_cmd tar xzf actions-runner.tar.gz
    run_cmd rm -f actions-runner.tar.gz
    
    if [[ "$DRY_RUN" != "true" ]]; then
        if [[ ! -f "config.sh" ]]; then
            log_error "Failed to extract runner - config.sh not found"
            exit 1
        fi
        log_info "Runner extracted successfully"
    fi
}

# Configure runner
configure_runner() {
    log_info "Configuring runner: $RUNNER_NAME"
    
    local config_cmd="./config.sh --url \"$GITHUB_URL\" --token \"$RUNNER_TOKEN\" --name \"$RUNNER_NAME\" --labels \"$RUNNER_LABELS\" --unattended"
    
    if [[ "$EPHEMERAL" == "true" ]]; then
        config_cmd="$config_cmd --ephemeral"
        log_info "Configuring as ephemeral runner"
    fi
    
    run_cmd $config_cmd
    
    if [[ "$DRY_RUN" != "true" ]]; then
        log_info "Runner configured successfully"
    fi
}

# Install as systemd service
install_service() {
    log_info "Installing runner as systemd service"
    
    run_cmd ./svc.sh install
    run_cmd ./svc.sh start
    
    if [[ "$DRY_RUN" != "true" ]]; then
        sleep 2
        if systemctl is-active --quiet actions.runner.*.service 2>/dev/null; then
            log_info "Service started successfully"
        else
            log_warn "Service may not have started correctly. Check with: systemctl status actions.runner.*.service"
        fi
    fi
}

# Remove runner
remove_runner() {
    log_info "Removing runner: $RUNNER_NAME"
    
    cd "$RUNNER_DIR"
    
    if [[ -f "./svc.sh" ]]; then
        run_cmd ./svc.sh stop
        run_cmd ./svc.sh uninstall
    fi
    
    if [[ -n "$RUNNER_TOKEN" ]]; then
        local remove_url=$(echo "$GITHUB_URL" | sed 's|\(https://github.com/.*\)|\1/settings/actions/runners|')
        log_info "Get removal token from: $remove_url"
        run_cmd ./config.sh remove --token "$RUNNER_TOKEN"
    fi
    
    run_cmd rm -rf "$RUNNER_DIR"
    
    log_info "Runner removed successfully"
}

# Docker-based runner
install_docker_runner() {
    log_info "Installing Docker-based runner"
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is required but not installed"
        exit 1
    fi
    
    local compose_dir="${RUNNER_DIR}-docker"
    run_cmd mkdir -p "$compose_dir"
    cd "$compose_dir"
    
    cat > docker-compose.yml << COMPOSE_EOF
version: '3.8'
services:
  github-runner:
    image: ghcr.io/actions/runner:latest
    container_name: ${RUNNER_NAME}
    environment:
      - CONFIG_URL=${GITHUB_URL}
      - RUNNER_TOKEN=${RUNNER_TOKEN}
      - RUNNER_NAME=${RUNNER_NAME}
      - RUNNER_LABELS=${RUNNER_LABELS}
      - RUNNER_WORKDIR=/home/runner/work
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - runner-data:/home/runner
    restart: always
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G

volumes:
  runner-data:
COMPOSE_EOF
    
    run_cmd docker compose up -d
    
    log_info "Docker runner started"
    log_info "View logs with: docker compose logs -f"
}

# Show usage
show_usage() {
    cat << USAGE
Usage: $0 [OPTIONS]

Install and configure GitHub Actions self-hosted runner.

Options:
    --url URL              GitHub repository or organization URL (required)
    --token TOKEN          Runner configuration token (required for install)
    --name NAME            Runner name (default: hostname-runner)
    --labels LABELS        Runner labels, comma-separated (default: linux,x64,auto)
    --version VERSION      Runner version (default: 2.317.0)
    --dir DIR              Installation directory (default: /opt/github-runner)
    --docker               Install as Docker container instead of systemd service
    --ephemeral            Configure as ephemeral runner
    --remove               Remove existing runner
    --dry-run              Show commands without executing
    --help                 Show this help

Examples:
    # Install repository-level runner
    GITHUB_URL=https://github.com/owner/repo RUNNER_TOKEN=gcm_xxx $0
    
    # Install with custom name and labels
    $0 --url https://github.com/owner/repo \
       --token gcm_xxx \
       --name build-runner \
       --labels linux,x64,docker
    
    # Install as ephemeral runner (for autoscaling)
    $0 --url https://github.com/owner/repo \
       --token gcm_xxx \
       --ephemeral
    
    # Install as Docker runner
    $0 --url https://github.com/owner/repo \
       --token gcm_xxx \
       --docker
    
    # Remove runner
    $0 --remove --dir /opt/github-runner

Environment Variables:
    GITHUB_URL     GitHub repository or organization URL
    RUNNER_TOKEN   Runner configuration token
    RUNNER_NAME    Runner name
    RUNNER_LABELS  Runner labels
    DRY_RUN        Set to 'true' for dry-run mode
USAGE
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --url) GITHUB_URL="$2"; shift 2 ;;
        --token) RUNNER_TOKEN="$2"; shift 2 ;;
        --name) RUNNER_NAME="$2"; shift 2 ;;
        --labels) RUNNER_LABELS="$2"; shift 2 ;;
        --version) RUNNER_VERSION="$2"; shift 2 ;;
        --dir) RUNNER_DIR="$2"; shift 2 ;;
        --docker) DOCKER_MODE="true"; shift ;;
        --ephemeral) EPHEMERAL="true"; shift ;;
        --remove) REMOVE_RUNNER="true"; shift ;;
        --dry-run) DRY_RUN="true"; shift ;;
        --help) show_usage; exit 0 ;;
        *) log_error "Unknown option: $1"; show_usage; exit 1 ;;
    esac
done

# Main execution
if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "DRY-RUN MODE - No changes will be made"
fi

check_prerequisites

if [[ "$REMOVE_RUNNER" == "true" ]]; then
    if [[ "$DOCKER_MODE" == "true" ]]; then
        log_info "Stopping Docker runner..."
        run_cmd docker compose -f "${RUNNER_DIR}-docker/docker-compose.yml" down -v
    fi
    remove_runner
else
    if [[ "$DOCKER_MODE" == "true" ]]; then
        install_docker_runner
    else
        install_runner "$RUNNER_VERSION" "$RUNNER_ARCH"
        configure_runner
        install_service
    fi
fi

log_info "Done!"
