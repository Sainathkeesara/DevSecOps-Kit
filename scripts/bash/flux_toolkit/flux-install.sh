#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
NAMESPACE="${NAMESPACE:-flux-system}"
GIT_URL="${GIT_URL:-}"
GIT_BRANCH="${GIT_BRANCH:-main}"
GIT_PATH="${GIT_PATH:-./clusters}"
GITHUB_OWNER="${GITHUB_OWNER:-}"
GITHUB_REPO="${GITHUB_REPO:-}"
BOOTSTRAP="${BOOTSTRAP:-false}"
VERSION="${VERSION:-2.4.0}"

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

check_dependencies() {
    log "INFO" "Checking dependencies..."
    local missing=()
    for bin in kubectl curl; do
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

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install and configure Flux v2 GitOps toolkit on Kubernetes for declarative cluster management.

Flux provides GitOps-based continuous delivery with Git repository synchronization,
Helm release management, and Kustomize reconciliation.

OPTIONS:
    --dry-run                 Preview installation steps without executing (default: false)
    --namespace NS            Kubernetes namespace (default: flux-system)
    --git-url URL             Git repository URL for manifests
    --git-branch BRANCH       Git branch to track (default: main)
    --git-path PATH           Path within repository for manifests (default: ./clusters)
    --github-owner OWNER      GitHub organization/user for bootstrap
    --github-repo REPO        GitHub repository name for bootstrap
    --bootstrap               Perform full bootstrap with GitHub
    --version VERSION         Flux version (default: 2.4.0)
    -h, --help                Show this help message

EXAMPLES:
    # Basic installation
    $0

    # Install with Git repository
    $0 --git-url https://github.com/myorg/my-cluster.git --git-branch main

    # Full GitHub bootstrap
    GITHUB_TOKEN=xxx $0 --bootstrap --github-owner myorg --github-repo my-cluster

    # Dry-run preview
    $0 --dry-run

ENVIRONMENT VARIABLES:
    NAMESPACE               Kubernetes namespace (overrides --namespace)
    GITHUB_TOKEN            GitHub personal access token for bootstrap
    FLUX_VERSION            Flux version (overrides --version)

EOF
    exit 0
}

install_flux_cli() {
    local version="$1"

    if command -v flux >/dev/null 2>&1; then
        local current_version
        current_version=$(flux --version 2>/dev/null | head -1 | awk '{print $3}')
        log "INFO" "Flux CLI already installed: $current_version"
        return 0
    fi

    log "INFO" "Installing Flux CLI $version..."

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would download and install Flux CLI $version"
        return 0
    fi

    curl -fsSL https://fluxcd.io/install.sh | sudo bash

    log "INFO" "Flux CLI installed."
}

install_flux_components() {
    local ns="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would install Flux components in namespace: $ns"
        return 0
    fi

    log "INFO" "Installing Flux components in namespace: $ns"

    # Create namespace if it doesn't exist
    kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -

    # Install Flux without bootstrap
    flux install -n "$ns" --no-bootstrap

    log "INFO" "Flux components installed."
}

configure_git_repository() {
    local ns="$1"
    local git_url="$2"
    local git_branch="$3"
    local git_path="$4"

    if [ -z "$git_url" ]; then
        return 0
    fi

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create GitRepository source: $git_url"
        return 0
    fi

    log "INFO" "Creating GitRepository source..."

    kubectl -n "$ns" apply -f - <<EOF
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: flux-system
  namespace: $ns
spec:
  interval: 1m0s
  url: $git_url
  branch: $git_branch
EOF

    # Create default kustomization
    kubectl -n "$ns" apply -f - <<EOF
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: flux-system
  namespace: $ns
spec:
  interval: 10m0s
  path: $git_path
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
EOF

    log "INFO" "Git repository configured."
}

bootstrap_github() {
    local owner="$1"
    local repo="$2"
    local branch="$3"

    if [ -z "$owner" ] || [ -z "$repo" ]; then
        log "ERROR" "--github-owner and --github-repo are required for bootstrap"
        exit 1
    fi

    if [ -z "${GITHUB_TOKEN:-}" ]; then
        log "ERROR" "GITHUB_TOKEN environment variable is required for bootstrap"
        exit 1
    fi

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would bootstrap Flux with GitHub: $owner/$repo"
        return 0
    fi

    log "INFO" "Bootstrapping Flux with GitHub..."

    flux bootstrap github \
        --owner="$owner" \
        --repository="$repo" \
        --branch="$branch" \
        --path="./clusters/production" \
        --personal

    log "INFO" "Flux bootstrapped successfully."
}

verify_installation() {
    local ns="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify Flux installation"
        return 0
    fi

    log "INFO" "Verifying Flux installation..."

    # Check pods
    if ! kubectl -n "$ns" get pods -l app.kubernetes.io/part-of=flux 2>/dev/null; then
        log "WARN" "Could not verify pods, checking namespace..."
    fi

    # Check CRDs
    local crds
    crds=$(kubectl get crds 2>/dev/null | grep -c -E "(kustomization|helmrelease|gitrepository|ocirepository)" || echo 0)
    if [ "$crds" -gt 0 ]; then
        log "INFO" "Flux CRDs installed: $crds"
    fi

    log "INFO" "Flux installed successfully in namespace: $ns"
    kubectl -n "$ns" get pods 2>/dev/null || true
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --git-url)
            GIT_URL="$2"
            shift 2
            ;;
        --git-branch)
            GIT_BRANCH="$2"
            shift 2
            ;;
        --git-path)
            GIT_PATH="$2"
            shift 2
            ;;
        --github-owner)
            GITHUB_OWNER="$2"
            shift 2
            ;;
        --github-repo)
            GITHUB_REPO="$2"
            shift 2
            ;;
        --bootstrap)
            BOOTSTRAP="true"
            shift
            ;;
        --version)
            VERSION="$2"
            shift 2
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

NAMESPACE="${NAMESPACE:-${K8S_NAMESPACE:-flux-system}}"
VERSION="${VERSION:-${FLUX_VERSION:-2.4.0}}"

check_dependencies

log "INFO" "Flux Installation"
log "INFO" "Namespace: $NAMESPACE"
log "INFO" "Version: $VERSION"

install_flux_cli "$VERSION"

if [ "$BOOTSTRAP" = "true" ]; then
    bootstrap_github "$GITHUB_OWNER" "$GITHUB_REPO" "$GIT_BRANCH"
else
    install_flux_components "$NAMESPACE"
    configure_git_repository "$NAMESPACE" "$GIT_URL" "$GIT_BRANCH" "$GIT_PATH"
fi

verify_installation "$NAMESPACE"

log "INFO" "Installation complete."