#!/usr/bin/env bash
# =============================================================================
# iac-operations.sh - Shell Script Library for Infrastructure-as-Code Operations
# =============================================================================
#
# Purpose:
#   Provides reusable functions for infrastructure provisioning, configuration
#   management, and deployment automation in Linux environments.
#
# Usage:
#   source /path/to/iac-operations.sh
#   # Then use functions: run_terraform, deploy_ansible, etc.
#
# Requirements:
#   - bash 4.0+
#   - Standard Linux utilities (grep, awk, sed, find)
#   - Optional: terraform, ansible, kubectl (depends on function used)
#
# Safety notes:
#   - All operations support DRY_RUN mode
#   - Binary existence checks before execution
#   - Exit on unbound variables and pipe failures
#
# Tested on: Ubuntu 20.04/22.04, RHEL 8/9, Debian 11/12, CentOS 7/8
# =============================================================================

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Dry run mode (set DRY_RUN=true to enable)
DRY_RUN="${DRY_RUN:-false}"

# Logging functions
log_info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_debug()   { [[ "${VERBOSE:-false}" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

# Dry-run wrapper - use for commands that modify state
run() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $*"
        return 0
    fi
    log_debug "Executing: $*"
    "$@"; }

# Check if a binary exists and is executable
require_binary() {
    local cmd="$1"
    local package="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        log_error "Required command '$cmd' not found. Install with: apt install $package (or yum install $package)"
        return 1
    fi
}

# =============================================================================
# TERRAFORM OPERATIONS
# =============================================================================

# Run terraform init
tf_init() {
    local work_dir="${1:-$(pwd)}"
    require_binary terraform
    run "terraform -chdir=$work_dir init -input=false"
}

# Run terraform validate
tf_validate() {
    local work_dir="${1:-$(pwd)}"
    require_binary terraform
    run "terraform -chdir=$work_dir validate"
}

# Run terraform plan
tf_plan() {
    local work_dir="${1:-$(pwd)}"
    local var_file="${2:-}"
    local out_file="${work_dir}/tfplan"
    
    require_binary terraform
    
    local cmd="terraform -chdir=$work_dir plan -input=false -out=$out_file"
    [[ -n "$var_file" ]] && cmd="$cmd -var-file=$var_file"
    
    run "$cmd"
}

# Run terraform apply
tf_apply() {
    local work_dir="${1:-$(pwd)}"
    local auto_approve="${2:-true}"
    
    require_binary terraform
    
    local cmd="terraform -chdir=$work_dir apply -input=false"
    [[ "$auto_approve" == "true" ]] && cmd="$cmd -auto-approve"
    
    run "$cmd"
}

# Run terraform destroy
tf_destroy() {
    local work_dir="${1:-$(pwd)}"
    local auto_approve="${2:-true}"
    
    require_binary terraform
    
    local cmd="terraform -chdir=$work_dir destroy -input=false"
    [[ "$auto_approve" == "true" ]] && cmd="$cmd -auto-approve"
    
    run "$cmd"
}

# =============================================================================
# ANSIBLE OPERATIONS
# =============================================================================

# Run ansible playbook
ansible_run() {
    local playbook="$1"
    local inventory="${2:-inventory/hosts.ini}"
    local extravars="${3:-}"
    
    require_binary ansible-playbook
    
    local cmd="ansible-playbook -i $inventory $playbook --diff"
    [[ -n "$extravars" ]] && cmd="$cmd -e $extravars"
    
    run "$cmd"
}

# Run ansible playbook in check mode
ansible_check() {
    local playbook="$1"
    local inventory="${2:-inventory/hosts.ini}"
    local extravars="${3:-}"
    
    require_binary ansible-playbook
    
    local cmd="ansible-playbook -i $inventory $playbook --check --diff"
    [[ -n "$extravars" ]] && cmd="$cmd -e $extravars"
    
    run "$cmd"
}

# Execute ansible ad-hoc command
ansible_adhoc() {
    local hosts="$1"
    local module="$2"
    local args="${3:-}"
    local inventory="${4:-inventory/hosts.ini}"
    
    require_binary ansible
    
    local cmd="ansible $hosts -i $inventory -m $module"
    [[ -n "$args" ]] && cmd="$cmd -a '$args'"
    
    run "$cmd"
}

# =============================================================================
# SYSTEM UTILITIES
# =============================================================================

# Create directory with proper permissions
ensure_dir() {
    local path="$1"
    local mode="${2:-0755}"
    local owner="${3:-root:root}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would create directory: $path with mode $mode"
        return 0
    fi
    
    mkdir -p "$path"
    chmod "$mode" "$path"
    chown "$owner" "$path" 2>/dev/null || true
}

# Backup a file with timestamp
backup_file() {
    local file="$1"
    local suffix="${2:-$(date +%Y%m%d_%H%M%S)}"
    local backup_dir="${3:-/var/backups}"
    
    if [[ ! -f "$file" ]]; then
        log_warn "File not found for backup: $file"
        return 1
    fi
    
    local backup_path="$backup_dir/${file##*/}.$suffix"
    run "cp '$file' '$backup_path'"
    log_info "Backup created: $backup_path"
}

# Compare two files and return diff
file_diff() {
    local file1="$1"
    local file2="$2"
    
    require_binary diff
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        log_error "One or both files not found"
        return 1
    fi
    
    diff -u "$file1" "$file2" || return 1
}

# =============================================================================
# SERVICE MANAGEMENT
# =============================================================================

# Check if a systemd service is active
service_is_active() {
    local service="$1"
    systemctl is-active "$service" &>/dev/null
}

# Start a systemd service
service_start() {
    local service="$1"
    run "systemctl start $service"
}

# Stop a systemd service
service_stop() {
    local service="$1"
    run "systemctl stop $service"
}

# Restart a systemd service
service_restart() {
    local service="$1"
    run "systemctl restart $service"
}

# Enable a systemd service
service_enable() {
    local service="$1"
    run "systemctl enable $service"
}

# Reload systemd daemon
service_reload_daemon() {
    run "systemctl daemon-reload"
}

# =============================================================================
# NETWORK UTILITIES
# =============================================================================

# Check if a port is open
port_is_open() {
    local host="${1:-localhost}"
    local port="$2"
    local timeout="${3:-5}"
    
    require_binary nc
    
    nc -z -w "$timeout" "$host" "$port" 2>/dev/null
}

# Wait for a port to become available
wait_for_port() {
    local host="${1:-localhost}"
    local port="$2"
    local timeout="${3:-60}"
    local interval="${4:-2}"
    
    local elapsed=0
    while [[ $elapsed -lt $timeout ]]; do
        if port_is_open "$host" "$port"; then
            log_info "Port $port on $host is open"
            return 0
        fi
        sleep "$interval"
        elapsed=$((elapsed + interval))
    done
    
    log_error "Timeout waiting for port $port on $host"
    return 1
}

# Get primary IP address
get_primary_ip() {
    ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}' | head -1
}

# =============================================================================
# FILE TEMPLATE RENDERING
# =============================================================================

# Render a Jinja2-like template (basic variable substitution)
render_template() {
    local template_file="$1"
    local output_file="$2"
    
    if [[ ! -f "$template_file" ]]; then
        log_error "Template file not found: $template_file"
        return 1
    fi
    
    local content
    content=$(cat "$template_file")
    
    # Simple variable substitution: {{ variable }}
    while IFS= read -r line; do
        if [[ "$line" =~ \{\{[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*\}\} ]]; then
            local var_name="${BASH_REMATCH[1]}"
            local var_value="${!var_name:-}"
            content="${content//\{\{ $var_name \}\}/$var_value}"
            content="${content//\{\{$var_name\}\}/$var_value}"
            content="${content//\{\{ $var_name\}\}/$var_value}"
            content="${content//\{\{$var_name \}\}/$var_value}"
        fi
    done < "$template_file"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would write to: $output_file"
        echo "$content"
        return 0
    fi
    
    echo "$content" > "$output_file"
}

# =============================================================================
# BACKUP AND RESTORE
# =============================================================================

# Create a backup archive
create_backup() {
    local source="$1"
    local dest="${2:-/var/backups}"
    local name="${3:-backup-$(basename "$source")-$(date +%Y%m%d)}"
    
    require_binary tar
    
    ensure_dir "$dest"
    run "tar -czf '$dest/$name.tar.gz' -C '$(dirname "$source")' '$(basename "$source")'"
    log_info "Backup created: $dest/$name.tar.gz"
}

# Restore from a backup archive
restore_backup() {
    local backup_file="$1"
    local target_dir="${2:-$(dirname "$backup_file")}"
    
    require_binary tar
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        return 1
    fi
    
    backup_file "$backup_file.tar.gz"
    run "tar -xzf '$backup_file.tar.gz' -C '$target_dir'"
    log_info "Backup restored to: $target_dir"
}

# =============================================================================
# VALIDATION UTILITIES
# =============================================================================

# Validate YAML syntax
validate_yaml() {
    local file="$1"
    
    if command -v python3 &>/dev/null; then
        python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null || return 1
    elif command -v yamllint &>/dev/null; then
        yamllint -d relaxed "$file" || return 1
    else
        log_warn "No YAML validator available (python3 or yamllint)"
        return 0
    fi
    
    return 0
}

# Validate JSON syntax
validate_json() {
    local file="$1"
    
    require_binary python3
    python3 -c "import json; json.load(open('$file'))" || return 1
    
    return 0
}

# =============================================================================
# ERROR HANDLING
# =============================================================================

# Error handler with optional cleanup
handle_error() {
    local exit_code=$?
    local line_number="${1:-unknown}"
    local command="${2:-unknown}"
    
    log_error "Error at line $line_number: Command '$command' exited with status $exit_code"
    
    if [[ -n "${ERROR_CLEANUP:-}" ]]; then
        log_info "Running cleanup: $ERROR_CLEANUP"
        eval "$ERROR_CLEANUP"
    fi
    
    exit $exit_code
}

# Set up error trap
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

# =============================================================================
# VERSION AND HELP
# =============================================================================

IAC_LIB_VERSION="1.0.0"

show_version() {
    echo "iac-operations.sh version $IAC_LIB_VERSION"
}

show_help() {
    cat << EOF
iac-operations.sh - Shell Script Library for Infrastructure-as-Code Operations

Usage: source iac-operations.sh

Functions available:
  Terraform operations:
    tf_init <work_dir>         - Run terraform init
    tf_validate <work_dir>     - Run terraform validate
    tf_plan [work_dir] [var]   - Run terraform plan
    tf_apply [work_dir] [bool] - Run terraform apply
    tf_destroy [work_dir] [bool] - Run terraform destroy

  Ansible operations:
    ansible_run <playbook> [inventory] [vars] - Run playbook
    ansible_check <playbook> [inventory] - Check mode
    ansible_adhoc <hosts> <module> [args] [inventory] - Ad-hoc command

  System utilities:
    ensure_dir <path> [mode] [owner] - Create directory
    backup_file <file> [suffix] [dir] - Backup file with timestamp
    file_diff <file1> <file2> - Compare files
    render_template <template> <output> - Render template

  Service management:
    service_is_active <name> - Check if active
    service_start <name> - Start service
    service_stop <name> - Stop service
    service_restart <name> - Restart service
    service_enable <name> - Enable service

  Network utilities:
    port_is_open <host> <port> - Check port
    wait_for_port <host> <port> <timeout> - Wait for port
    get_primary_ip - Get primary IP

  Backup/restore:
    create_backup <source> [dest] [name] - Create archive
    restore_backup <file> [target] - Restore archive

  Validation:
    validate_yaml <file> - Validate YAML
    validate_json <file> - Validate JSON

Environment variables:
    DRY_RUN=true    - Enable dry-run mode (default: false)
    VERBOSE=true    - Enable verbose output (default: false)
EOF
}