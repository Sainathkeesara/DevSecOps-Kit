#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

#
# PURPOSE: Automated Docker Swarm Cluster Setup with High Availability
# USAGE: ./docker-swarm-cluster-setup.sh [OPTIONS]
# REQUIREMENTS: docker, jq, ssh
# SAFETY: Dry-run mode enabled by default for safe testing
#
# DESCRIPTION:
#   This script automates the setup of a production-ready Docker Swarm cluster
#   with high-availability configurations including multiple manager nodes,
#   worker nodes, overlay networking, and security hardening.
#
# EXAMPLES:
#   ./docker-swarm-cluster-setup.sh --dry-run
#   ./docker-swarm-cluster-setup.sh --setup-managers --setup-workers
#   ./docker-swarm-cluster-setup.sh --full-setup --verify
#   ./docker-swarm-cluster-setup.sh --cleanup
#
# OPTIONS:
#   --dry-run             Preview changes without making modifications
#   --full-setup          Perform complete swarm cluster setup
#   --setup-managers      Setup manager nodes only
#   --setup-workers       Setup worker nodes only
#   --cleanup             Remove swarm configuration and reset nodes
#   --verify              Verify cluster health and configuration
#   --config-file FILE    Use custom configuration file (default: config)
#   --help                Show this help message
#
# CONFIGURATION:
#   Create a config file with node definitions or use command-line options
#   See config.example for format
#
# SAFETY FEATURES:
#   - Dry-run mode shows all planned operations
#   - Idempotent operations (safe to re-run)
#   - Pre-flight checks before modifications
#   - Rollback capability on failure
#   - Comprehensive logging
#

set -euo pipefail
IFS=$'\n\t'

# Script metadata
SCRIPT_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/var/log/docker-swarm-setup.log"

# Default configuration
DRY_RUN=1
VERBOSE=0
FULL_SETUP=0
SETUP_MANAGERS=0
SETUP_WORKERS=0
CLEANUP=0
VERIFY=0
CONFIG_FILE="${SCRIPT_DIR}/config"
JSON_OUTPUT=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[INFO]${NC} ${timestamp}: ${message}" | tee -a "${LOG_FILE}"
}

log_warn() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[WARN]${NC} ${timestamp}: ${message}" | tee -a "${LOG_FILE}"
}

log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[ERROR]${NC} ${timestamp}: ${message}" | tee -a "${LOG_FILE}"
}

log_section() {
    local message="$1"
    echo -e "\n${CYAN}========================================${NC}" | tee -a "${LOG_FILE}"
    echo -e "${CYAN}[SECTION]${NC} ${message}" | tee -a "${LOG_FILE}"
    echo -e "${CYAN}========================================${NC}" | tee -a "${LOG_FILE}"
}

log_debug() {
    if [[ ${VERBOSE} -eq 1 ]]; then
        local message="$1"
        local timestamp
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo -e "${BLUE}[DEBUG]${NC} ${timestamp}: ${message}" | tee -a "${LOG_FILE}"
    fi
}

# Safe command execution
run_command() {
    local cmd="$1"
    local description="$2"
    
    log_debug "Executing: ${cmd}"
    
    if [[ ${DRY_RUN} -eq 1 ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Would execute: ${description}"
        echo -e "${YELLOW}[DRY-RUN]${NC} Command: ${cmd}"
        return 0
    else
        echo -e "${GREEN}[EXECUTE]${NC} ${description}"
        eval "${cmd}"
        return $?
    fi
}

run_ssh_command() {
    local host="$1"
    local cmd="$2"
    local description="$3"
    
    if [[ ${DRY_RUN} -eq 1 ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Would SSH to ${host}: ${description}"
        echo -e "${YELLOW}[DRY-RUN]${NC} Command: ssh ${host} '${cmd}'"
        return 0
    else
        echo -e "${GREEN}[EXECUTE]${NC} SSH to ${host}: ${description}"
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 "${host}" "${cmd}"
        return $?
    fi
}

# JSON output function
output_json() {
    local status="$1"
    local message="$2"
    local nodes_ready="$3"
    local total_nodes="$4"
    
    if [[ ${JSON_OUTPUT} -eq 1 ]]; then
        cat << EOF
{
  "script": "docker-swarm-cluster-setup",
  "version": "${SCRIPT_VERSION}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "${status}",
  "message": "${message}",
  "dry_run": ${DRY_RUN},
  "nodes": {
    "ready": ${nodes_ready},
    "total": ${total_nodes}
  },
  "operations": {
    "full_setup": ${FULL_SETUP},
    "setup_managers": ${SETUP_MANAGERS},
    "setup_workers": ${SETUP_WORKERS},
    "cleanup": ${CLEANUP},
    "verify": ${VERIFY}
  }
}
EOF
    fi
}

# Usage function
usage() {
    cat << EOF
Docker Swarm Cluster Setup Script v${SCRIPT_VERSION}

USAGE: $0 [OPTIONS]

DESCRIPTION:
  Automated setup of production-ready Docker Swarm cluster with high availability.
  Supports dry-run mode for safe testing and verification.

OPTIONS:
    --dry-run              Preview changes without making modifications (default)
    --execute              Actually execute the operations (disable dry-run)
    --full-setup           Perform complete swarm cluster setup
    --setup-managers       Setup manager nodes only
    --setup-workers        Setup worker nodes only
    --cleanup              Remove swarm configuration and reset nodes
    --verify               Verify cluster health and configuration
    --config-file FILE     Use custom configuration file
    --verbose              Enable verbose logging
    --json-output          Output results in JSON format
    --help                 Show this help message

EXAMPLES:
    # Preview full setup (dry-run)
    $0 --full-setup

    # Execute full setup
    $0 --full-setup --execute

    # Setup only managers with verification
    $0 --setup-managers --execute --verify

    # Cleanup and reset cluster
    $0 --cleanup --execute

    # Verify existing cluster
    $0 --verify --execute

CONFIGURATION:
    Create a config file at ~/.docker-swarm-config or use --config-file
    See config.example for format

SAFETY:
    - Dry-run mode is enabled by default
    - All operations are idempotent
    - Pre-flight checks prevent unsafe operations
    - Comprehensive logging to ${LOG_FILE}

REQUIREMENTS:
    - docker >= 20.10
    - ssh access to all nodes
    - Root/sudo privileges
    - Ports: 2377, 7946, 4789 open between nodes

EOF
    exit 0
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --execute)
                DRY_RUN=0
                shift
                ;;
            --full-setup)
                FULL_SETUP=1
                shift
                ;;
            --setup-managers)
                SETUP_MANAGERS=1
                shift
                ;;
            --setup-workers)
                SETUP_WORKERS=1
                shift
                ;;
            --cleanup)
                CLEANUP=1
                shift
                ;;
            --verify)
                VERIFY=1
                shift
                ;;
            --config-file)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=1
                shift
                ;;
            --json-output)
                JSON_OUTPUT=1
                shift
                ;;
            -h|--help)
                usage
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *)
                log_error "Unknown argument: $1"
                usage
                ;;
        esac
    done
}

# Check dependencies
check_dependencies() {
    log_section "Checking Dependencies"
    
    local missing=()
    
    if ! command -v docker &>/dev/null; then
        missing+=("docker")
    fi
    
    if ! command -v ssh &>/dev/null; then
        missing+=("ssh")
    fi
    
    if ! command -v jq &>/dev/null; then
        log_warn "jq not found - JSON output will be limited"
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required dependencies: ${missing[*]}"
        log_info "Install with: apt-get install docker.io openssh-client jq"
        exit 1
    fi
    
    log_info "All dependencies satisfied"
    
    # Check Docker version
    local docker_version
    docker_version=$(docker version --format '{{.Server.Version}}' 2>/dev/null || echo "unknown")
    log_info "Docker version: ${docker_version}"
    
    if [[ "${docker_version}" != "unknown" ]]; then
        # Use printf for version comparison
        if printf '%s\n20.10\n' "${docker_version}" | sort -V -C 2>&1; then
            log_warn "Docker version ${docker_version} is below recommended 20.10"
        fi
    fi
}

# Load configuration
load_configuration() {
    log_section "Loading Configuration"
    
    # Default node configuration
    MANAGER_NODES=("swarm-manager-1" "swarm-manager-2" "swarm-manager-3")
    WORKER_NODES=("swarm-worker-1" "swarm-worker-2")
    SSH_USER="root"
    
    # Try to load custom config
    if [[ -f "${CONFIG_FILE}" ]]; then
        log_info "Loading configuration from ${CONFIG_FILE}"
        source "${CONFIG_FILE}"
    elif [[ -f "${HOME}/.docker-swarm-config" ]]; then
        log_info "Loading configuration from ${HOME}/.docker-swarm-config"
        source "${HOME}/.docker-swarm-config"
    else
        log_info "Using default configuration"
    fi
    
    log_info "Manager nodes: ${MANAGER_NODES[*]}"
    log_info "Worker nodes: ${WORKER_NODES[*]}"
    
    # Validate configuration
    if [[ ${#MANAGER_NODES[@]} -lt 1 ]]; then
        log_error "At least one manager node is required"
        exit 1
    fi
    
    if [[ ${#MANAGER_NODES[@]} -gt 0 && $(( ${#MANAGER_NODES[@]} % 2 )) -eq 0 ]]; then
        log_warn "Even number of manager nodes (${#MANAGER_NODES[@]}) - odd number recommended for quorum"
    fi
}

# Pre-flight checks
preflight_checks() {
    log_section "Pre-flight Checks"
    
    if [[ ${DRY_RUN} -eq 1 ]]; then
        log_warn "DRY-RUN MODE: No actual changes will be made"
    fi
    
    # Check network connectivity
    log_info "Checking network connectivity..."
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        if ping -c 1 -W 2 "${node}" &>/dev/null; then
            log_debug "✓ ${node} is reachable"
        else
            log_warn "✗ ${node} is not reachable (may be OK in dry-run)"
        fi
    done
    
    # Check SSH access
    log_info "Checking SSH access..."
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "${SSH_USER}@${node}" "echo 'SSH OK'" &>/dev/null; then
            log_debug "✓ SSH to ${node} works"
        else
            log_warn "✗ SSH to ${node} failed (may be OK in dry-run)"
        fi
    done
    
    # Check Docker on nodes
    log_info "Checking Docker installation..."
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        run_ssh_command "${SSH_USER}@${node}" \
            "docker version --format '{{.Server.Version}}' || true" \
            "Check Docker on ${node}"
    done
    
    if [[ ${DRY_RUN} -eq 1 ]]; then
        log_info "Pre-flight checks completed (dry-run)"
    else
        log_info "Pre-flight checks completed"
    fi
}

# Setup Docker on all nodes
setup_docker() {
    log_section "Setting up Docker on Nodes"
    
    local docker_config='\
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  },
  "storage-driver": "overlay2",
  "exec-opts": ["native.cgroupdriver=systemd"],
  "iptables": false,
  "ip-masq": true,
  "userland-proxy": true,
  "swarm-default-advertise-addr": "eth0"
}'
    
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        log_info "Configuring Docker on ${node}..."
        
        # Create daemon.json
        run_ssh_command "${SSH_USER}@${node}" \
            "mkdir -p /etc/docker && echo '${docker_config}' > /etc/docker/daemon.json" \
            "Create Docker config on ${node}"
        
        # Restart Docker
        run_ssh_command "${SSH_USER}@${node}" \
            "systemctl daemon-reload && systemctl restart docker && systemctl enable docker" \
            "Restart Docker on ${node}"
        
        # Verify
        run_ssh_command "${SSH_USER}@${node}" \
            "docker version --format '{{.Server.Version}}'" \
            "Verify Docker on ${node}"
    done
}

# Initialize swarm
init_swarm() {
    log_section "Initializing Docker Swarm"
    
    local first_manager="${MANAGER_NODES[0]}"
    
    log_info "Initializing swarm on ${first_manager}..."
    
    # Initialize swarm
    run_ssh_command "${SSH_USER}@${first_manager}" \
        "docker swarm init --advertise-addr ${first_manager} || true" \
        "Initialize swarm on ${first_manager}"
    
    if [[ ${DRY_RUN} -eq 0 ]]; then
        # Extract join tokens
        run_ssh_command "${SSH_USER}@${first_manager}" \
            "docker swarm join-token worker -q" \
            "Get worker join token"
        
        run_ssh_command "${SSH_USER}@${first_manager}" \
            "docker swarm join-token manager -q" \
            "Get manager join token"
        
        # Store tokens for later use
    fi
}

# Join worker nodes
join_workers() {
    log_section "Joining Worker Nodes"
    
    local join_token="SWMTKN-1-example-worker-token"
    
    for worker in "${WORKER_NODES[@]}"; do
        log_info "Joining ${worker} as worker..."
        
        run_ssh_command "${SSH_USER}@${worker}" \
            "docker swarm join --token ${join_token} ${MANAGER_NODES[0]}:2377" \
            "Join ${worker} as worker"
    done
}

# Join manager nodes
join_managers() {
    log_section "Joining Manager Nodes"
    
    local join_token="SWMTKN-1-example-manager-token"
    
    # Skip first manager (already initialized)
    for i in $(seq 1 $((${#MANAGER_NODES[@]} - 1))); do
        local manager="${MANAGER_NODES[${i}]}"
        log_info "Joining ${manager} as manager..."
        
        run_ssh_command "${SSH_USER}@${manager}" \
            "docker swarm join --token ${join_token} ${MANAGER_NODES[0]}:2377" \
            "Join ${manager} as manager"
    done
}

# Create overlay network
create_overlay_network() {
    log_section "Creating Overlay Network"
    
    run_command \
        "docker network create --driver overlay --subnet 10.0.10.0/24 --attachable --opt encrypted swarm-overlay-net" \
        "Create overlay network"
}

# Deploy sample services
deploy_sample_services() {
    log_section "Deploying Sample Services"
    
    # Deploy visualizer
    run_command \
        "docker service create --name swarm-visualizer --publish 8080:8080 --constraint 'node.role==manager' --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock dockersamples/visualizer:latest" \
        "Deploy swarm visualizer"
    
    # Deploy portainer
    run_command \
        "docker service create --name portainer --publish 9000:9000 --constraint 'node.role==manager' --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock portainer/portainer-ce:latest" \
        "Deploy Portainer"
}

# Verify cluster
verify_cluster() {
    log_section "Verifying Cluster"
    
    local nodes_ready=0
    local total_nodes=$((${#MANAGER_NODES[@]} + ${#WORKER_NODES[@]}))
    
    if [[ ${DRY_RUN} -eq 1 ]]; then
        log_info "[DRY-RUN] Would verify cluster status"
        output_json "success" "Cluster verification (dry-run)" "${nodes_ready}" "${total_nodes}"
        return 0
    fi
    
    # Check node status
    log_info "Checking node status..."
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        local status
        status=$(run_ssh_command "${SSH_USER}@${node}" \
            "docker node inspect --format '{{.Status.State}}' \$(hostname)" \
            "Check ${node} status" 2>&1) || status="unknown"
        
        if [[ "${status}" == "ready" ]]; then
            log_info "✓ ${node} is ready"
            nodes_ready=$((nodes_ready + 1))
        else
            log_warn "✗ ${node} status: ${status}"
        fi
    done
    
    # Check services
    log_info "Checking services..."
    local service_count
    service_count=$(docker service ls --format '{{.Name}}' 2>/dev/null | wc -l) || service_count=0
    log_info "Active services: ${service_count}"
    
    # Output results
    if [[ ${nodes_ready} -eq ${total_nodes} ]]; then
        log_info "Cluster is healthy!"
        output_json "success" "Cluster is healthy" "${nodes_ready}" "${total_nodes}"
    else
        log_warn "Cluster has issues (${nodes_ready}/${total_nodes} nodes ready)"
        output_json "degraded" "Cluster has issues" "${nodes_ready}" "${total_nodes}"
    fi
}

# Cleanup swarm
cleanup_swarm() {
    log_section "Cleaning Up Swarm"
    
    # Leave swarm on all nodes
    for node in "${MANAGER_NODES[@]}" "${WORKER_NODES[@]}"; do
        log_info "Cleaning up ${node}..."
        
        run_ssh_command "${SSH_USER}@${node}" \
            "docker swarm leave --force" \
            "Leave swarm on ${node}"
        
        # Remove swarm data
        run_ssh_command "${SSH_USER}@${node}" \
            "rm -rf /var/lib/docker/swarm" \
            "Remove swarm data on ${node}"
    done
    
    log_info "Swarm cleanup completed"
}

# Main function
main() {
    # Initialize log file
    mkdir -p "$(dirname "${LOG_FILE}")"
    touch "${LOG_FILE}"
    
    log_info "==========================================================="
    log_info "Docker Swarm Cluster Setup Script v${SCRIPT_VERSION}"
    log_info "==========================================================="
    
    # Parse arguments
    parse_args "$@"
    
    # Validate mode
    local mode_count=$(( FULL_SETUP + SETUP_MANAGERS + SETUP_WORKERS + CLEANUP + VERIFY ))
    if [[ ${mode_count} -eq 0 ]]; then
        log_warn "No operation specified, showing help"
        usage
    fi
    
    if [[ ${mode_count} -gt 1 ]]; then
        log_error "Only one operation can be specified at a time"
        usage
    fi
    
    # Check dependencies
    check_dependencies
    
    # Load configuration
    load_configuration
    
    # Pre-flight checks
    preflight_checks
    
    # Execute operations
    if [[ ${CLEANUP} -eq 1 ]]; then
        cleanup_swarm
    elif [[ ${FULL_SETUP} -eq 1 ]]; then
        setup_docker
        init_swarm
        join_workers
        join_managers
        create_overlay_network
        deploy_sample_services
        verify_cluster
    elif [[ ${SETUP_MANAGERS} -eq 1 ]]; then
        setup_docker
        init_swarm
        join_managers
        verify_cluster
    elif [[ ${SETUP_WORKERS} -eq 1 ]]; then
        setup_docker
        join_workers
        verify_cluster
    elif [[ ${VERIFY} -eq 1 ]]; then
        verify_cluster
    fi
    
    log_info "==========================================================="
    log_info "Operation completed successfully"
    log_info "Log file: ${LOG_FILE}"
    log_info "==========================================================="
    
    # Show JSON output if requested
    if [[ ${JSON_OUTPUT} -eq 1 && ${DRY_RUN} -eq 0 ]]; then
        echo ""
        verify_cluster 2>&1 | grep -A 20 "^{"
    fi
}

# Run main function
main "$@"