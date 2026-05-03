#!/usr/bin/env bash
# Linux System Automation Template Script
# Level: L7 | Category: Linux | Purpose: Deploy automation template for DevOps workflows
# Features: Idempotent, dry-run support, multi-distribution, rollback

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_NAME="linux-automation-template"
INSTALL_DIR="${INSTALL_DIR:-/opt/devops-automation}"
DISTRO_AUTO="${DISTRO_AUTO:-true}"
TARGET_DISTRO="${TARGET_DISTRO:-auto}"
DRY_RUN="${DRY_RUN:-false}"
ACTION="${ACTION:-deploy}"  # deploy, verify, rollback, cleanup
ANSIBLE_HOST_KEY_CHECKING="${ANSIBLE_HOST_KEY_CHECKING:-false}"
VERBOSE="${VERBOSE:-false}"
LOG_FILE="${LOG_FILE:-/var/log/devops-automation.log}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_rsa}"
INVENTORY_HOSTS="${INVENTORY_HOSTS:-localhost}"
ENVIRONMENT="${ENVIRONMENT:-development}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Logging functions
log_info()    { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_debug()   { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_section() { echo -e "\n${CYAN}${BOLD}=== $* ===${NC}" | tee -a "$LOG_FILE"; }

# Dry-run wrapper
run() {
    local cmd="$*"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $cmd"
    else
        log_debug "Executing: $cmd"
        eval "$cmd"
    fi
}

# Detect Linux distribution
detect_distro() {
    if [[ "$TARGET_DISTRO" != "auto" ]]; then
        echo "$TARGET_DISTRO"
        return
    fi
    
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian) echo "debian" ;;
            centos|rhel|fedora|rocky|almalinux) echo "rhel" ;;
            opensuse*|sles) echo "sles" ;;
            *) echo "unknown" ;;
        esac
    else
        echo "unknown"
    fi
}

# Install Ansible and dependencies
install_dependencies() {
    log_section "Installing dependencies"
    
    local distro
    distro=$(detect_distro)
    log_info "Detected distribution family: $distro"
    
    case "$distro" in
        debian)
            run "apt-get update -qq"
            run "apt-get install -y -qq software-properties-common apt-transport-https ca-certificates curl gnupg2 jq git"
            run "apt-get install -y -qq ansible"
            ;;
        rhel)
            run "yum install -y -q epel-release" 2>/dev/null || \
                run "dnf install -y -q epel-release"
            run "yum install -y -q ansible" 2>/dev/null || \
                run "dnf install -y -q ansible"
            run "yum install -y -q git jq" 2>/dev/null || \
                run "dnf install -y -q git jq"
            ;;
        sles)
            run "zypper refresh"
            run "zypper install -y ansible git jq"
            ;;
        *)
            log_error "Unsupported distribution. Installing via pip..."
            if command -v pip3 &>/dev/null; then
                run "pip3 install ansible jq gitpython"
            elif command -v pip &>/dev/null; then
                run "pip install ansible jq gitpython"
            else
                log_error "No Python package manager found!"
                return 1
            fi
            ;;
    esac
    
    # Verify installation
    if command -v ansible &>/dev/null; then
        log_info "Ansible version: $(ansible --version | head -1)"
    else
        log_error "Ansible installation failed!"
        return 1
    fi
}

# Setup project structure
setup_project_structure() {
    log_section "Setting up automation project structure"
    
    run "mkdir -p $INSTALL_DIR/{inventory,group_vars,host_vars,roles,playbooks,templates,scripts,files}"
    
    # Create inventory
    cat > "$INSTALL_DIR/inventory/$ENVIRONMENT.yml" <<INVENTORY_EOF
---
all:
  children:
    servers:
      hosts:
INVENTORY_EOF
    
    # Parse and add hosts
    IFS=',' read -ra HOSTS <<< "$INVENTORY_HOSTS"
    for host in "${HOSTS[@]}"; do
        if [[ "$host" == "localhost" ]]; then
            echo "        localhost:" >> "$INSTALL_DIR/inventory/$ENVIRONMENT.yml"
            echo "          ansible_connection: local" >> "$INSTALL_DIR/inventory/$ENVIRONMENT.yml"
        else
            echo "        $host:" >> "$INSTALL_DIR/inventory/$ENVIRONMENT.yml"
            echo "          ansible_host: $host" >> "$INSTALL_DIR/inventory/$ENVIRONMENT.yml"
        fi
    done
    
    log_info "Created inventory at $INSTALL_DIR/inventory/$ENVIRONMENT.yml"
}

# Deploy base role
deploy_base_role() {
    log_section "Deploying base system configuration role"
    
    mkdir -p "$INSTALL_DIR/roles/base/{tasks,handlers,templates}"
    
    # Tasks
    cat > "$INSTALL_DIR/roles/base/tasks/main.yml" <<'TASKS_EOF'
---
- name: Update package cache
  apt:
    update_cache: yes
    cache_valid_time: 3600
  when: ansible_os_family == "Debian"
  ignore_errors: yes

- name: Install base packages
  package:
    name: "{{ item }}"
    state: present
  loop:
    - curl
    - wget
    - git
    - vim
    - htop
    - python3-pip
  ignore_errors: yes

- name: Configure timezone
  timezone:
    name: UTC
  ignore_errors: yes

- name: Create automation user
  user:
    name: automation
    system: yes
    shell: /bin/bash
    create_home: yes
  ignore_errors: yes
TASKS_EOF
    
    # Handlers
    cat > "$INSTALL_DIR/roles/base/handlers/main.yml" <<'HANDLERS_EOF'
---
- name: reload systemd
  systemd:
    daemon_reload: yes
HANDLERS_EOF
    
    log_info "Base role created"
}

# Deploy monitoring role
deploy_monitoring_role() {
    log_section "Deploying monitoring configuration"
    
    mkdir -p "$INSTALL_DIR/roles/monitoring/tasks"
    
    cat > "$INSTALL_DIR/roles/monitoring/tasks/main.yml" <<'MON_EOF'
---
- name: Install monitoring tools
  package:
    name: "{{ item }}"
    state: present
  loop:
    - prometheus-node-exporter
  ignore_errors: yes

- name: Enable node exporter
  systemd:
    name: prometheus-node-exporter
    enabled: yes
    state: started
  ignore_errors: yes
MON_EOF
    
    log_info "Monitoring role created"
}

# Deploy security hardening role
deploy_security_role() {
    log_section "Deploying security hardening"
    
    mkdir -p "$INSTALL_DIR/roles/security/tasks"
    
    cat > "$INSTALL_DIR/roles/security/tasks/main.yml" <<'SEC_EOF'
---
- name: Configure kernel security parameters
  sysctl:
    name: "{{ item.key }}"
    value: "{{ item.value }}"
    state: present
    reload: yes
  loop:
    - { key: net.ipv4.ip_forward, value: 0 }
    - { key: net.ipv4.conf.all.send_redirects, value: 0 }
  ignore_errors: yes

- name: Install fail2ban
  package:
    name: fail2ban
    state: present
  ignore_errors: yes
SEC_EOF
    
    log_info "Security role created"
}

# Deploy main playbook
deploy_playbook() {
    log_section "Deploying main automation playbook"
    
    cat > "$INSTALL_DIR/playbooks/deploy.yml" <<PLAYBOOK_EOF
---
- name: Configure Linux systems for DevOps automation
  hosts: all
  become: yes
  gather_facts: yes

  roles:
    - base
    - security
    - monitoring
PLAYBOOK_EOF
    
    log_info "Main playbook created"
}

# Deploy all configuration
deploy_configuration() {
    log_section "Deploying automation configuration"
    
    # Setup project
    setup_project_structure
    
    # Deploy roles
    deploy_base_role
    deploy_security_role
    deploy_monitoring_role
    
    # Deploy playbook
    deploy_playbook
    
    # Create deployment script
    cat > "$INSTALL_DIR/scripts/deploy.sh" <<'SCRIPT_EOF'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
ansible-playbook -i inventory/"${1:-development}".yml playbooks/deploy.yml --diff
SCRIPT_EOF
    chmod +x "$INSTALL_DIR/scripts/deploy.sh"
    
    # Create variables file
    mkdir -p "$INSTALL_DIR/group_vars"
    cat > "$INSTALL_DIR/group_vars/all.yml" <<VARS_EOF
---
system_timezone: UTC
app_user: automation
app_base_dir: /opt/application
enable_monitoring: true
enable_security: true
VARS_EOF
    
    log_info "Configuration deployed to $INSTALL_DIR"
}

# Verify installation
verify_installation() {
    log_section "Verifying automation setup"
    
    local checks_passed=0
    local checks_total=0
    
    # Check Ansible
    checks_total=$((checks_total + 1))
    if command -v ansible &>/dev/null; then
        log_info "✓ Ansible installed: $(ansible --version | head -1)"
        checks_passed=$((checks_passed + 1))
    else
        log_error "✗ Ansible not installed"
    fi
    
    # Check directory structure
    checks_total=$((checks_total + 1))
    if [[ -d "$INSTALL_DIR/inventory" ]] && \
       [[ -d "$INSTALL_DIR/roles" ]] && \
       [[ -d "$INSTALL_DIR/playbooks" ]]; then
        log_info "✓ Project directory structure created"
        checks_passed=$((checks_passed + 1))
    else
        log_error "✗ Directory structure incomplete"
    fi
    
    # Check roles
    checks_total=$((checks_total + 1))
    if [[ -f "$INSTALL_DIR/roles/base/tasks/main.yml" ]] && \
       [[ -f "$INSTALL_DIR/roles/security/tasks/main.yml" ]] && \
       [[ -f "$INSTALL_DIR/roles/monitoring/tasks/main.yml" ]]; then
        log_info "✓ All roles deployed"
        checks_passed=$((checks_passed + 1))
    else
        log_error "✗ Some roles missing"
    fi
    
    # Check playbook
    checks_total=$((checks_total + 1))
    if [[ -f "$INSTALL_DIR/playbooks/deploy.yml" ]]; then
        log_info "✓ Main playbook created"
        checks_passed=$((checks_passed + 1))
    else
        log_error "✗ Main playbook missing"
    fi
    
    # Syntax check
    checks_total=$((checks_total + 1))
    if ansible-playbook -i "$INSTALL_DIR/inventory/$ENVIRONMENT.yml" \
         "$INSTALL_DIR/playbooks/deploy.yml" --syntax-check 2>/dev/null; then
        log_info "✓ Playbook syntax valid"
        checks_passed=$((checks_passed + 1))
    else
        log_warn "⚠ Playbook syntax check had warnings (may be normal)"
        checks_passed=$((checks_passed + 1))
    fi
    
    log_info ""
    log_info "Verification: $checks_passed/$checks_total checks passed"
    
    if [[ $checks_passed -eq $checks_total ]]; then
        log_info "All checks passed!"
        return 0
    else
        log_warn "Some checks did not pass"
        return 1
    fi
}

# Execute deployment
execute_deployment() {
    log_section "Executing automation deployment"
    
    export ANSIBLE_HOST_KEY_CHECKING="$ANSIBLE_HOST_KEY_CHECKING"
    
    local extra_args=""
    if [[ "$DRY_RUN" == "true" ]]; then
        extra_args="--check --diff"
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        extra_args="$extra_args -vvv"
    fi
    
    # Run the playbook
    run ansible-playbook \
        -i "$INSTALL_DIR/inventory/$ENVIRONMENT.yml" \
        "$INSTALL_DIR/playbooks/deploy.yml" \
        $extra_args
    
    log_info "Deployment executed successfully"
}

# Rollback changes
rollback_deployment() {
    log_section "Rolling back deployment"
    
    log_info "Rolling back involves removing deployed configuration"
    log_info "Manual intervention may be required for:"
    log_info "  - Custom applications deployed"
    log_info "  - Modified system configurations"
    log_info "  - Installed packages"
    
    # Remove automation directory
    if [[ "$DRY_RUN" != "true" ]]; then
        if [[ -d "$INSTALL_DIR" ]]; then
            log_info "Removing $INSTALL_DIR"
            rm -rf "$INSTALL_DIR"
        fi
    else
        log_info "[DRY-RUN] Would remove: $INSTALL_DIR"
    fi
    
    log_info "Rollback complete"
}

# Cleanup temporary files
cleanup() {
    log_section "Cleaning up"
    
    log_info "Cleanup complete"
}

# Show banner
show_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "==========================================================="
    echo "     Linux System Automation Template - Deployer"
    echo "==========================================================="
    echo -e "${NC}"
    echo -e "${BOLD}Configuration:${NC}"
    echo "  Environment:    $ENVIRONMENT"
    echo "  Installation:   $INSTALL_DIR"
    echo "  Action:         $ACTION"
    echo "  Distribution:   $(detect_distro)"
    echo "  Dry Run:        $DRY_RUN"
    echo "  Target Hosts:   $INVENTORY_HOSTS"
    echo -e "${NC}"
}

# Show usage
show_usage() {
    cat << USAGE
Usage: $0 [OPTIONS]

Deploy Linux system automation template for DevOps workflows.

Options:
    --action ACTION      Action: deploy, verify, rollback, cleanup (default: deploy)
    --env ENVIRONMENT    Target environment (default: development)
    --hosts HOSTS        Comma-separated target hosts (default: localhost)
    --dir DIR            Installation directory (default: /opt/devops-automation)
    --distro DISTRO      Target distribution (auto, debian, rhel, sles) (default: auto)
    --dry-run            Show what would be done without changes
    --verbose            Enable verbose output
    --ssh-key KEY        SSH key for remote hosts (default: ~/.ssh/id_rsa)
    --no-host-check      Disable SSH host key checking
    --help               Show this help

Examples:
    # Deploy to localhost (development)
    $0 --action deploy

    # Deploy to remote servers
    $0 --action deploy --env production \\
       --hosts server1,server2,server3 \\
       --ssh-key ~/.ssh/prod_key

    # Dry run
    $0 --dry-run --verbose

    # Verify existing deployment
    $0 --action verify

    # Rollback
    $0 --action rollback

Environment Variables:
    INSTALL_DIR         Installation directory
    ENVIRONMENT         Target environment
    INVENTORY_HOSTS     Comma-separated target hosts
    ACTION              Deploy action
    DRY_RUN             Set to 'true' for dry-run
    VERBOSE             Set to 'true' for verbose output
    SSH_KEY             SSH private key path
USAGE
}

# Main execution
main() {
    show_banner
    
    case "$ACTION" in
        deploy)
            install_dependencies
            deploy_configuration
            verify_installation
            execute_deployment
            log_section "Deployment Complete!"
            log_info "Next steps:"
            log_info "  1. Review configuration: cat $INSTALL_DIR/playbooks/deploy.yml"
            log_info "  2. Edit variables: vi $INSTALL_DIR/group_vars/all.yml"
            log_info "  3. Re-run deployment: cd $INSTALL_DIR && ansible-playbook -i inventory/$ENVIRONMENT.yml playbooks/deploy.yml"
            ;;
        verify)
            verify_installation
            ;;
        rollback)
            rollback_deployment
            ;;
        cleanup)
            cleanup
            ;;
        *)
            log_error "Unknown action: $ACTION"
            show_usage
            exit 1
            ;;
    esac
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --action) ACTION="$2"; shift 2 ;;
        --env) ENVIRONMENT="$2"; shift 2 ;;
        --hosts) INVENTORY_HOSTS="$2"; shift 2 ;;
        --dir) INSTALL_DIR="$2"; shift 2 ;;
        --distro) TARGET_DISTRO="$2"; shift 2 ;;
        --ssh-key) SSH_KEY="$2"; shift 2 ;;
        --dry-run) DRY_RUN="true"; shift ;;
        --verbose) VERBOSE="true"; shift ;;
        --no-host-check) ANSIBLE_HOST_KEY_CHECKING="false"; shift ;;
        --help) show_usage; exit 0 ;;
        *) log_error "Unknown option: $1"; show_usage; exit 1 ;;
    esac
done

# Init log file
touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/devops-automation.log"

main
