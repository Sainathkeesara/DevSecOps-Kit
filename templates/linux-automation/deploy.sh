#!/usr/bin/env bash
#
# Linux System Automation Deployment Script
# Purpose: Deploy and manage Linux automation templates
# Usage: ./deploy.sh [environment] [action]
#

set -euo pipefail

# Configuration
ENVIRONMENT="${1:-development}"
ACTION="${2:-deploy}"
INSTALL_DIR="${INSTALL_DIR:-$(pwd)}"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Check prerequisites
check_prerequisites() {
    if ! command -v ansible &>/dev/null; then
        log_error "Ansible is not installed"
        exit 1
    fi

    if [[ ! -f "$INSTALL_DIR/playbooks/deploy.yml" ]]; then
        log_error "Playbook not found: $INSTALL_DIR/playbooks/deploy.yml"
        exit 1
    fi
}

# Deploy configuration
deploy() {
    log_info "Deploying to environment: $ENVIRONMENT"

    local extra_args=()
    [[ "$DRY_RUN" == "true" ]] && extra_args+=(--check --diff)
    [[ "$VERBOSE" == "true" ]] && extra_args+=(-vvv)

    ansible-playbook \
        -i "$INSTALL_DIR/inventory/${ENVIRONMENT}.yml" \
        "$INSTALL_DIR/playbooks/deploy.yml" \
        "${extra_args[@]}"
}

# Verify deployment
verify() {
    log_info "Verifying deployment..."
    ansible-playbook \
        -i "$INSTALL_DIR/inventory/${ENVIRONMENT}.yml" \
        "$INSTALL_DIR/playbooks/deploy.yml" \
        --check --diff
}

# Main
main() {
    case "$ACTION" in
        deploy)  deploy ;;
        verify)  verify ;;
        *)       log_error "Unknown action: $ACTION"; exit 1 ;;
    esac
}

main "$@"