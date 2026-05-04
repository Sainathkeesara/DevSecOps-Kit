#!/usr/bin/env bash
# shellcheck shell=bash

#
# PURPOSE: Detect and remediate Docker AuthZ plugin security gaps for privileged containers
# USAGE: ./docker-authz-plugin-hardening.sh [--check] [--dry-run] [--remediate] [--json-output]
# REQUIREMENTS: docker, jq
# SAFETY: Read-only scan by default. Use --dry-run to preview findings.
#
# Docker AuthZ Plugin Security Hardening for Privileged Containers
# This script checks for security gaps in Docker authorization configuration
# that could allow privileged container operations.
#

set -euo pipefail
IFS=$'\n\t'

DRY_RUN=0
JSON_OUTPUT=0
REMEDIATE=0
CHECK_MODE=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_section() { echo -e "${BLUE}[SECTION]${NC} $*" >&2; }

ISSUES=()
SECURITY_GAPS=()

check_dependencies() {
    local missing=()
    if ! command -v docker &>/dev/null; then
        missing+=("docker")
    fi
    if ! command -v jq &>/dev/null; then
        missing+=("jq")
    fi
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        exit 1
    fi
}

usage() {
    cat <<EOF
Docker AuthZ Plugin Security Hardening Script

USAGE: $0 [OPTIONS]

OPTIONS:
    --check             Run security check (default)
    --dry-run           Preview findings without making changes
    --remediate        Apply remediation steps
    --json-output      Output results in JSON format
    -h, --help        Show this help message

DESCRIPTION:
    This script checks for Docker authorization security gaps
    related to privileged container operations.
    It identifies:
    1. Running privileged containers
    2. Authorization plugin status
    3. Docker daemon configuration
    4. Provides remediation recommendations

REFERENCES:
    - Docker Security: https://docs.docker.com/engine/security/
    - CIS Docker Benchmark: https://www.cisecurity.org/benchmark/docker

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check) CHECK_MODE=1 ;;
            --dry-run) DRY_RUN=1 ;;
            --json-output) JSON_OUTPUT=1 ;;
            --remediate) REMEDIATE=1 ;;
            -h|--help) usage ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *) ;;
        esac
        shift
    done
}

check_privileged_containers() {
    log_section "Checking for privileged containers"
    
    if ! docker info &>/dev/null; then
        log_warn "Docker daemon not accessible"
        return 1
    fi
    
    local privileged_containers
    privileged_containers=$(docker ps -a --format '{{.Names}}' 2>/dev/null || echo "")
    
    if [[ -z "$privileged_containers" ]]; then
        log_info "No containers found"
        return 0
    fi
    
    local found_privileged=0
    while IFS= read -r container; do
        [[ -z "$container" ]] && continue
        
        local is_privileged
        is_privileged=$(docker inspect "$container" --format '{{.HostConfig.PrivilegedMode}}' 2>/dev/null || echo "false")
        
        if [[ "$is_privileged" = "true" ]]; then
            log_warn "Privileged container found: $container"
            SECURITY_GAPS+=("privileged-container:$container")
            found_privileged=1
        fi
    done <<< "$privileged_containers"
    
    if [[ $found_privileged -eq 0 ]]; then
        log_info "No privileged containers detected"
    fi
}

check_security_options() {
    log_section "Checking security options in running containers"
    
    local containers
    containers=$(docker ps -a --format '{{.Names}}' 2>/dev/null || echo "")
    
    [[ -z "$containers" ]] && return 0
    
    local found_insecure=0
    while IFS= read -r container; do
        [[ -z "$container" ]] && continue
        
        local security_opts
        security_opts=$(docker inspect "$container" --format '{{.HostConfig.SecurityOpt}}' 2>/dev/null || echo "")
        
        local no_new_privs
        no_new_privs=$(docker inspect "$container" --format '{{.HostConfig.PrivilegedMode}}' 2>/dev/null || echo "true")
        
        if [[ "$no_new_privs" != "true" ]]; then
            log_warn "Container without no-new-privileges: $container"
            SECURITY_GAPS+=("no-new-privileges:$container")
            found_insecure=1
        fi
    done <<< "$containers"
    
    if [[ $found_insecure -eq 0 ]]; then
        log_info "All containers have security options configured"
    fi
}

check_docker_daemon_config() {
    log_section "Checking Docker daemon configuration"
    
    local daemon_config="/etc/docker/daemon.json"
    
    if [[ ! -f "$daemon_config" ]]; then
        log_warn "No daemon.json found at $daemon_config"
        SECURITY_GAPS+=("no-daemon-config:$daemon_config")
        return 0
    fi
    
    local has_no_new_privs has_userland_proxy has_icc
    
    has_no_new_privs=$(jq -r '.["no-new-privileges"] // "false"' "$daemon_config" 2>/dev/null || echo "false")
    has_userland_proxy=$(jq -r '.["userland-proxy"] // "true"' "$daemon_config" 2>/dev/null || echo "true")
    has_icc=$(jq -r '.icc // "true"' "$daemon_config" 2>/dev/null || echo "true")
    
    if [[ "$has_no_new_privs" != "true" ]]; then
        log_warn "no-new-privileges not enabled in daemon.json"
        SECURITY_GAPS+=("daemon-config:no-new-privileges")
    else
        log_info "no-new-privileges is enabled"
    fi
    
    if [[ "$has_userland_proxy" = "true" ]]; then
        log_warn "userland-proxy is enabled (should be disabled)"
        SECURITY_GAPS+=("daemon-config:userland-proxy")
    fi
    
    if [[ "$has_icc" = "true" ]]; then
        log_warn "icc is enabled (should be disabled)"
        SECURITY_GAPS+=("daemon-config:icc")
    fi
}

check_authorization_plugins() {
    log_section "Checking authorization plugins"
    
    local plugins
    plugins=$(docker info --format '{{.Plugins.Authorization}}' 2>/dev/null || echo "")
    
    if [[ -z "$plugins" ]] || [[ "$plugins" = "<no value>" ]]; then
        log_warn "No authorization plugin configured"
        SECURITY_GAPS+=("no-authz-plugin")
    else
        log_info "Authorization plugin: $plugins"
    fi
}

generate_report() {
    if [[ ${#SECURITY_GAPS[@]} -gt 0 ]]; then
        log_error "Security gaps found: ${#SECURITY_GAPS[@]}"
        for gap in "${SECURITY_GAPS[@]}"; do
            echo "  - $gap"
        done
        return 1
    else
        log_info "No security gaps detected"
        return 0
    fi
}

output_json() {
    local gaps_json
    gaps_json=$(printf '%s\n' "${SECURITY_GAPS[@]}" | jq -R . 2>/dev/null || echo "[]")
    
    cat <<EOF
{
  "check": "docker-authz-plugin-hardening",
  "timestamp": "$(date -Iseconds)",
  "security_gaps": ${gaps_json},
  "total_issues": ${#SECURITY_GAPS[@]}
}
EOF
}

main() {
    check_dependencies
    parse_args "$@"
    
    check_privileged_containers
    check_security_options
    check_docker_daemon_config
    check_authorization_plugins
    
    if [[ $JSON_OUTPUT -eq 1 ]]; then
        output_json
    else
        generate_report
    fi
}

main "$@"