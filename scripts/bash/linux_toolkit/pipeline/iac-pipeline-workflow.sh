#!/usr/bin/env bash
# IaC Pipeline Workflow Script
# Level: L7 | Category: Linux | Purpose: Infrastructure-as-Code automation workflows for DevOps pipelines
# Features: Multi-environment support, dry-run mode, approval gates, rollback

set -euo pipefail

IAC_LIB="${IAC_LIB:-/usr/local/lib/iac/iac-operations.sh}"

# Configuration
ACTION="${ACTION:-plan}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TERRAFORM_DIR="${TERRAFORM_DIR:-./terraform}"
ANSIBLE_INVENTORY="${ANSIBLE_INVENTORY:-./ansible/inventory}"
ANSIBLE_PLAYBOOK="${ANSIBLE_PLAYBOOK:-./ansible/playbooks/site.yml}"
DRY_RUN="${DRY_RUN:-true}"
APPROVAL_REQUIRED="${APPROVAL_REQUIRED:-false}"
APPROVAL_TOKEN="${APPROVAL_TOKEN:-}"
VERBOSE="${VERBOSE:-false}"
LOG_FILE="${LOG_FILE:-/var/log/iac-pipeline.log}"
BACKUP_ENABLED="${BACKUP_ENABLED:-true}"
TF_STATE_BUCKET="${TF_STATE_BUCKET:-}"
TF_DYNAMO_TABLE="${TF_DYNAMO_TABLE:-terraform-locks}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Logging functions
log_info()    { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_debug()   { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_section() { echo -e "\n${CYAN}${BOLD}=== $* ===${NC}" | tee -a "$LOG_FILE"; }

# Load IaC operations library if available
load_iac_lib() {
    if [[ -f "$IAC_LIB" ]]; then
        source "$IAC_LIB"
        log_info "Loaded IaC operations library"
    else
        log_warn "IaC library not found at $IAC_LIB"
    fi
}

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

# Binary existence check
check_binary() {
    local binary="$1"
    if ! command -v "$binary" &>/dev/null; then
        log_error "$binary not found. Please install $binary."
        return 1
    fi
    log_debug "$binary found: $(command -v "$binary")"
}

# Pre-flight checks
preflight_checks() {
    log_section "Running pre-flight checks"
    
    local checks_passed=0
    local checks_total=5
    
    # Check required binaries
    ((checks_total++))
    if check_binary terraform; then
        ((checks_passed++))
        log_info "Terraform: $(terraform version | head -1)"
    fi
    
    ((checks_total++))
    if check_binary ansible-playbook; then
        ((checks_passed++))
        log_info "Ansible: $(ansible-playbook --version | head -1)"
    fi
    
    # Check directories
    ((checks_total++))
    if [[ -d "$TERRAFORM_DIR" ]]; then
        ((checks_passed++))
        log_info "Terraform directory: $TERRAFORM_DIR"
    else
        log_error "Terraform directory not found: $TERRAFORM_DIR"
    fi
    
    ((checks_total++))
    if [[ -d "$ANSIBLE_INVENTORY" ]]; then
        ((checks_passed++))
        log_info "Ansible inventory: $ANSIBLE_INVENTORY"
    else
        log_warn "Ansible inventory not found: $ANSIBLE_INVENTORY"
    fi
    
    ((checks_total++))
    if [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
        ((checks_passed++))
        log_info "Ansible playbook: $ANSIBLE_PLAYBOOK"
    else
        log_warn "Ansible playbook not found: $ANSIBLE_PLAYBOOK"
    fi
    
    log_info "Pre-flight checks: $checks_passed/$checks_total passed"
    [[ $checks_passed -ge 3 ]] || return 1
}

# Terraform operations
terraform_workflow() {
    log_section "Terraform Workflow - $ACTION"
    
    local tf_dir="$TERRAFORM_DIR/environments/$ENVIRONMENT"
    if [[ ! -d "$tf_dir" ]]; then
        tf_dir="$TERRAFORM_DIR"
    fi
    
    cd "$tf_dir"
    
    case "$ACTION" in
        init)
            run "terraform init -upgrade"
            ;;
        validate)
            run "terraform validate"
            ;;
        plan)
            run "terraform init -upgrade"
            run "terraform validate"
            run "terraform plan -out=tfplan -var-file=terraform.tfvars"
            log_info "Plan saved to tfplan"
            ;;
        apply)
            if [[ "$APPROVAL_REQUIRED" == "true" ]] && [[ "$ENVIRONMENT" == "prod" ]]; then
                if [[ -z "$APPROVAL_TOKEN" ]]; then
                    log_error "Production deployment requires approval token"
                    return 1
                fi
            fi
            
            if [[ "$BACKUP_ENABLED" == "true" ]]; then
                run "terraform state pull > terraform.state.backup"
                log_info "State backed up to terraform.state.backup"
            fi
            
            run "terraform apply -auto-approve tfplan"
            ;;
        destroy)
            log_warn "Destroy action requested"
            run "terraform destroy -auto-approve"
            ;;
        rollback)
            log_info "Rolling back to previous state"
            if [[ -f "terraform.state.backup" ]]; then
                run "terraform state push terraform.state.backup"
                log_info "State restored from backup"
            else
                log_error "No backup found for rollback"
                return 1
            fi
            ;;
    esac
}

# Ansible operations
ansible_workflow() {
    log_section "Ansible Workflow - $ACTION"
    
    local inventory_file="$ANSIBLE_INVENTORY/$ENVIRONMENT.yml"
    if [[ ! -f "$inventory_file" ]]; then
        inventory_file="$ANSIBLE_INVENTORY.ini"
    fi
    
    case "$ACTION" in
        validate|check)
            run "ansible-playbook -i '$inventory_file' '$ANSIBLE_PLAYBOOK' --syntax-check"
            run "ansible-playbook -i '$inventory_file' '$ANSIBLE_PLAYBOOK' --check --diff"
            ;;
        plan)
            run "ansible-playbook -i '$inventory_file' '$ANSIBLE_PLAYBOOK' --check"
            ;;
        apply)
            if [[ "$APPROVAL_REQUIRED" == "true" ]] && [[ "$ENVIRONMENT" == "prod" ]]; then
                if [[ -z "$APPROVAL_TOKEN" ]]; then
                    log_error "Production deployment requires approval token"
                    return 1
                fi
            fi
            run "ansible-playbook -i '$inventory_file' '$ANSIBLE_PLAYBOOK' --diff"
            ;;
        rollback)
            log_info "Ansible rollback not fully supported - use version control"
            ;;
    esac
}

# Full pipeline execution
execute_pipeline() {
    log_section "Executing IaC Pipeline"
    log_info "Environment: $ENVIRONMENT"
    log_info "Action: $ACTION"
    log_info "Dry-run: $DRY_RUN"
    
    # Run Terraform
    if [[ -d "$TERRAFORM_DIR" ]]; then
        terraform_workflow
    else
        log_warn "Skipping Terraform (directory not found)"
    fi
    
    # Run Ansible
    if [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
        ansible_workflow
    else
        log_warn "Skipping Ansible (playbook not found)"
    fi
}

# Validate pipeline configuration
validate_config() {
    log_section "Validating pipeline configuration"
    
    # Validate Terraform
    if [[ -d "$TERRAFORM_DIR" ]]; then
        local tf_dir="$TERRAFORM_DIR/environments/$ENVIRONMENT"
        [[ ! -d "$tf_dir" ]] && tf_dir="$TERRAFORM_DIR"
        
        cd "$tf_dir"
        if terraform validate 2>/dev/null; then
            log_info "Terraform configuration valid"
        else
            log_error "Terraform configuration has errors"
            return 1
        fi
    fi
    
    # Validate Ansible
    if [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
        if ansible-playbook -i "$ANSIBLE_INVENTORY/$ENVIRONMENT.yml" \
            "$ANSIBLE_PLAYBOOK" --syntax-check 2>/dev/null; then
            log_info "Ansible playbook syntax valid"
        else
            log_error "Ansible playbook has syntax errors"
            return 1
        fi
    fi
    
    log_info "Configuration validation complete"
}

# Show banner
show_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "====================================================================="
    echo "        IaC Pipeline Workflow - Infrastructure Automation"
    echo "====================================================================="
    echo -e "${NC}"
    echo -e "${BOLD}Configuration:${NC}"
    echo "  Action:         $ACTION"
    echo "  Environment:    $ENVIRONMENT"
    echo "  Terraform:     $TERRAFORM_DIR"
    echo "  Ansible Inv:   $ANSIBLE_INVENTORY"
    echo "  Ansible PB:    $ANSIBLE_PLAYBOOK"
    echo "  Dry Run:       $DRY_RUN"
    echo "  Approval:      $APPROVAL_REQUIRED"
    echo "  Verbose:       $VERBOSE"
    echo -e "${NC}"
}

# Show usage
show_usage() {
    cat << USAGE
Usage: $0 [OPTIONS]

Execute Infrastructure-as-Code automation workflows for DevOps pipelines.

Options:
    --action ACTION      Action: init, validate, plan, apply, destroy, rollback (default: plan)
    --env ENVIRONMENT    Target environment: dev, staging, prod (default: dev)
    --tf-dir DIR         Terraform directory (default: ./terraform)
    --inventory DIR     Ansible inventory directory (default: ./ansible/inventory)
    --playbook FILE      Ansible playbook file (default: ./ansible/playbooks/site.yml)
    --dry-run            Show what would be done without changes (default: true)
    --no-dry-run         Actually execute changes
    --approval           Require approval for production deployments
    --token TOKEN        Approval token for production deployments
    --backup             Enable state backup before apply (default: true)
    --no-backup          Disable state backup
    --verbose            Enable verbose output
    --validate           Validate configuration only
    --help               Show this help

Actions:
    init       Initialize Terraform configuration
    validate   Validate Terraform and Ansible configuration
    plan       Generate Terraform and Ansible plan
    apply      Apply Terraform and Ansible changes
    destroy    Destroy Terraform resources
    rollback   Restore previous Terraform state

Examples:
    # Plan for development
    $0 --action plan --env dev

    # Apply to staging (dry-run)
    $0 --action apply --env staging --dry-run

    # Apply to production (with approval)
    $0 --action apply --env prod --approval --token \$APPROVAL_TOKEN

    # Validate configuration
    $0 --validate --env staging

    # Rollback production
    $0 --action rollback --env prod

Environment Variables:
    ACTION              Pipeline action
    ENVIRONMENT         Target environment
    TERRAFORM_DIR       Terraform directory
    ANSIBLE_INVENTORY   Ansible inventory directory
    ANSIBLE_PLAYBOOK    Ansible playbook file
    DRY_RUN             Set to 'false' to actually execute
    APPROVAL_REQUIRED   Set to 'true' to require approval
    APPROVAL_TOKEN      Approval token for production
    VERBOSE             Set to 'true' for verbose output
    IAC_LIB             Path to iac-operations.sh library

USAGE
}

# Main execution
main() {
    show_banner
    
    load_iac_lib
    preflight_checks
    
    if [[ "$ACTION" == "validate" ]]; then
        validate_config
        exit $?
    fi
    
    execute_pipeline
    
    log_section "Pipeline Complete"
    log_info "Logs saved to: $LOG_FILE"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --action) ACTION="$2"; shift 2 ;;
        --env) ENVIRONMENT="$2"; shift 2 ;;
        --tf-dir) TERRAFORM_DIR="$2"; shift 2 ;;
        --inventory) ANSIBLE_INVENTORY="$2"; shift 2 ;;
        --playbook) ANSIBLE_PLAYBOOK="$2"; shift 2 ;;
        --token) APPROVAL_TOKEN="$2"; shift 2 ;;
        --backup) BACKUP_ENABLED="true"; shift ;;
        --no-backup) BACKUP_ENABLED="false"; shift ;;
        --dry-run) DRY_RUN="true"; shift ;;
        --no-dry-run) DRY_RUN="false"; shift ;;
        --approval) APPROVAL_REQUIRED="true"; shift ;;
        --verbose) VERBOSE="true"; shift ;;
        --validate) ACTION="validate"; shift ;;
        --help) show_usage; exit 0 ;;
        *) log_error "Unknown option: $1"; show_usage; exit 1 ;;
    esac
done

# Init log file
touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/iac-pipeline.log"

main

