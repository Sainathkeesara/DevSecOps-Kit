#!/usr/bin/env bash
# last_verified: 2026-10-25 · environments n/a
# Environment promotion workflow: dev -> staging -> prod
# Validates, plans, and applies Terraform changes through promotion gates

set -euo pipefail

ENVS_ROOT="/work/DevSecOps-Kit/environments"
TERRAFORM_DIRS=("dev" "staging" "prod")
PROMOTION_ORDER=("dev" "staging" "prod")

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Environment promotion workflow for dev -> staging -> prod.

Options:
    -e, --environment ENV    Target environment (dev, staging, prod). Default: dev
    -s, --step STEP          Step to execute: validate, plan, apply, promote. Default: promote
    -a, --auto-approve       Skip manual approval prompts (use with caution)
    -v, --verbose            Enable verbose output
    -h, --help               Show this help

Steps:
    validate    Run terraform validate and fmt check
    plan        Generate and save terraform plan
    apply       Apply saved plan (requires approval unless --auto-approve)
    promote     Full promotion: validate -> plan -> apply for target and all prior envs

Examples:
    $(basename "$0") -e staging -s validate
    $(basename "$0") -e prod -s promote --auto-approve
    $(basename "$0") -e dev -s plan
EOF
}

log() {
    local level="$1"
    shift
    local msg="$*"
    case "$level" in
        INFO)  echo "[INFO]  $msg" ;;
        WARN)  echo "[WARN]  $msg" >&2 ;;
        ERROR) echo "[ERROR] $msg" >&2 ;;
        DEBUG) [[ "${VERBOSE:-false}" == "true" ]] && echo "[DEBUG] $msg" ;;
    esac
}

check_prerequisites() {
    log INFO "Checking prerequisites..."
    
    if ! command -v terraform >/dev/null 2>&1; then
        log ERROR "terraform not found in PATH"
        return 1
    fi
    
    if ! command -v aws >/dev/null 2>&1; then
        log WARN "aws CLI not found — backend init may fail without credentials"
    fi
    
    for env in "${TERRAFORM_DIRS[@]}"; do
        if [[ ! -d "$ENVS_ROOT/$env" ]]; then
            log ERROR "Environment directory missing: $ENVS_ROOT/$env"
            return 1
        fi
        for f in main.tf variables.tf outputs.tf terraform.tfvars; do
            if [[ ! -f "$ENVS_ROOT/$env/$f" ]]; then
                log ERROR "Required file missing: $ENVS_ROOT/$env/$f"
                return 1
            fi
        done
    done
    
    log INFO "Prerequisites check passed"
    return 0
}

validate_env() {
    local env="$1"
    local env_dir="$ENVS_ROOT/$env"
    
    log INFO "Validating $env environment..."
    
    cd "$env_dir"
    
    if ! terraform fmt -check -diff >/dev/null 2>&1; then
        log WARN "$env: terraform fmt would make changes"
        terraform fmt -diff
    else
        log INFO "$env: formatting OK"
    fi
    
    if ! terraform validate; then
        log ERROR "$env: terraform validate failed"
        return 1
    fi
    
    log INFO "$env: validation passed"
    return 0
}

plan_env() {
    local env="$1"
    local env_dir="$ENVS_ROOT/$env"
    local plan_file="$env_dir/${env}.tfplan"
    
    log INFO "Planning $env environment..."
    
    cd "$env_dir"
    
    if ! terraform init -backend-config="key=${env}/terraform.tfstate" >/dev/null 2>&1; then
        log ERROR "$env: terraform init failed"
        return 1
    fi
    
    if ! terraform plan -out="$plan_file"; then
        log ERROR "$env: terraform plan failed"
        return 1
    fi
    
    log INFO "$env: plan saved to $plan_file"
    
    # Show plan summary
    terraform show -no-color "$plan_file" | head -50
    
    return 0
}

apply_env() {
    local env="$1"
    local env_dir="$ENVS_ROOT/$env"
    local plan_file="$env_dir/${env}.tfplan"
    
    log INFO "Applying $env environment..."
    
    if [[ ! -f "$plan_file" ]]; then
        log ERROR "No plan file found: $plan_file. Run plan step first."
        return 1
    fi
    
    cd "$env_dir"
    
    if [[ "${AUTO_APPROVE:-false}" != "true" ]]; then
        log WARN "About to apply changes to $env environment."
        read -rp "Continue? [y/N] " -n 1
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Apply cancelled by user"
            return 1
        fi
    fi
    
    if ! terraform apply "$plan_file"; then
        log ERROR "$env: terraform apply failed"
        return 1
    fi
    
    log INFO "$env: apply completed successfully"
    
    # Clean up plan file after successful apply
    rm -f "$plan_file"
    
    return 0
}

run_verification() {
    local env="$1"
    local verify_type="${2:-smoke}"
    
    log INFO "Running $verify_type verification for $env..."
    
    # Placeholder for actual verification logic
    # In practice, this would run smoke tests, integration tests, etc.
    case "$verify_type" in
        "smoke")
            log INFO "Smoke test placeholder — would check basic connectivity"
            ;;
        "integration")
            log INFO "Integration test placeholder — would run full test suite"
            ;;
        "post-deploy")
            log INFO "Post-deploy verification placeholder — would verify running services"
            ;;
    esac
    
    return 0
}

promote_through() {
    local target_env="$1"
    local target_index=-1
    
    for i in "${!PROMOTION_ORDER[@]}"; do
        if [[ "${PROMOTION_ORDER[$i]}" == "$target_env" ]]; then
            target_index=$i
            break
        fi
    done
    
    if [[ $target_index -eq -1 ]]; then
        log ERROR "Unknown environment: $target_env"
        return 1
    fi
    
    log INFO "Starting promotion to $target_env (will process: ${PROMOTION_ORDER[0]}, ${PROMOTION_ORDER[1]}, ..., ${PROMOTION_ORDER[$target_index]})"
    
    for ((i=0; i<=target_index; i++)); do
        local env="${PROMOTION_ORDER[$i]}"
        local verify_type="smoke"
        
        case "$env" in
            "staging") verify_type="integration" ;;
            "prod") verify_type="post-deploy" ;;
        esac
        
        log INFO "=== Processing $env ==="
        
        if ! validate_env "$env"; then
            log ERROR "Validation failed for $env, stopping promotion"
            return 1
        fi
        
        if ! plan_env "$env"; then
            log ERROR "Planning failed for $env, stopping promotion"
            return 1
        fi
        
        if ! apply_env "$env"; then
            log ERROR "Apply failed for $env, stopping promotion"
            return 1
        fi
        
        if ! run_verification "$env" "$verify_type"; then
            log ERROR "Verification failed for $env, stopping promotion"
            return 1
        fi
        
        log INFO "$env promotion step completed"
    done
    
    log INFO "Promotion to $target_env completed successfully"
    return 0
}

main() {
    local target_env="dev"
    local step="promote"
    local auto_approve=false
    local verbose=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e|--environment)
                target_env="$2"
                shift 2
                ;;
            -s|--step)
                step="$2"
                shift 2
                ;;
            -a|--auto-approve)
                auto_approve=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log ERROR "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    export VERBOSE="$verbose"
    export AUTO_APPROVE="$auto_approve"
    
    if [[ ! " ${TERRAFORM_DIRS[*]} " =~ ${target_env} ]]; then
        log ERROR "Invalid environment: $target_env. Must be one of: ${TERRAFORM_DIRS[*]}"
        exit 1
    fi
    
    if ! check_prerequisites; then
        exit 1
    fi
    
    case "$step" in
        validate)
            validate_env "$target_env"
            ;;
        plan)
            validate_env "$target_env" && plan_env "$target_env"
            ;;
        apply)
            apply_env "$target_env"
            ;;
        promote)
            promote_through "$target_env"
            ;;
        *)
            log ERROR "Invalid step: $step. Must be one of: validate, plan, apply, promote"
            exit 1
            ;;
    esac
}

main "$@"