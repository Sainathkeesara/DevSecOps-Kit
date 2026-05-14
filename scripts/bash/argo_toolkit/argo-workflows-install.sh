#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
NAMESPACE="${NAMESPACE:-argo}"
VERSION="${VERSION:-3.5.8}"
ARTIFACT_REPO="${ARTIFACT_REPO:-}"
ARTIFACT_S3_BUCKET="${ARTIFACT_S3_BUCKET:-}"
WAIT="${WAIT:-true}"

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

Install and configure Argo Workflows on Kubernetes for CI/CD pipeline orchestration.

Argo Workflows provides Kubernetes-native workflow engine for containerized
pipeline execution with support for MLOps, CI/CD, and batch processing.

OPTIONS:
    --dry-run                 Preview installation steps without executing (default: false)
    --namespace NS            Kubernetes namespace (default: argo)
    --version VERSION         Argo Workflows version (default: 3.5.8)
    --artifact-repo URL       Artifact repository URL (e.g., s3://bucket/path)
    --artifact-s3-bucket NAME S3 bucket for workflow artifacts
    --no-wait                 Do not wait for pods to be ready
    -h, --help                Show this help message

EXAMPLES:
    # Basic installation
    $0

    # Custom namespace with S3 artifacts
    $0 --namespace ml-workflows --artifact-s3-bucket my-artifacts

    # Dry-run preview
    $0 --dry-run

ENVIRONMENT VARIABLES:
    NAMESPACE               Kubernetes namespace (overrides --namespace)
    ARGO_VERSION              Argo Workflows version (overrides --version)

EOF
    exit 0
}

create_namespace() {
    local ns="$1"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create namespace: $ns"
        return 0
    fi

    if kubectl get namespace "$ns" 2>/dev/null; then
        log "INFO" "Namespace $ns already exists."
    else
        log "INFO" "Creating namespace: $ns"
        kubectl create namespace "$ns"
    fi
}

install_argo() {
    local ns="$1"
    local version="$2"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would install Argo Workflows $version in namespace $ns"
        return 0
    fi

    log "INFO" "Installing Argo Workflows $version..."

    # Download and apply install manifest
    local url="https://github.com/argoproj/argo-workflows/releases/download/v${version}/install.yaml"

    log "INFO" "Downloading manifest from: $url"
    curl -fsSL "$url" -o /tmp/argo-install.yaml

    log "INFO" "Applying Argo Workflows manifests..."
    kubectl apply -n "$ns" -f /tmp/argo-install.yaml

    log "INFO" "Argo Workflows installation complete."
}

configure_artifact_repo() {
    local ns="$1"
    local bucket="$2"

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would configure S3 artifact repository: $bucket"
        return 0
    fi

    if [ -z "$bucket" ]; then
        return 0
    fi

    log "INFO" "Configuring S3 artifact repository..."

    # Create artifact repository config
    kubectl -n "$ns" apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: artifact-repos
  namespace: $ns
data:
  default: |
    s3:
      bucket: $bucket
      endpoint: s3.amazonaws.com
      region: us-west-2
EOF

    log "INFO" "Artifact repository configured."
}

wait_for_ready() {
    local ns="$1"

    if [ "$WAIT" != "true" ]; then
        return 0
    fi

    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would wait for pods to be ready"
        return 0
    fi

    log "INFO" "Waiting for Argo components to be ready..."

    local max_attempts=60
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        local ready=$(kubectl -n "$ns" get pods -l app.kubernetes.io/part-of=argo-workflows -o jsonpath='{.items[*].status.containerStatuses[*].ready}' 2>/dev/null | tr ' ' '\n' | grep -c true || echo 0)
        local total=$(kubectl -n "$ns" get pods -l app.kubernetes.io/part-of=argo-workflows 2>/dev/null | grep -c Running || echo 0)

        if [ "$ready" -gt 0 ] && [ "$total" -gt 0 ]; then
            log "INFO" "All Argo pods are ready."
            return 0
        fi

        attempt=$((attempt + 1))
        log "INFO" "Waiting... ($attempt/$max_attempts)"
        sleep 5
    done

    log "WARN" "Timeout waiting for pods, continuing anyway..."
}

verify_installation() {
    local ns="$1"

    log "INFO" "Verifying installation..."

    if ! kubectl -n "$ns" get pods -l app.kubernetes.io/name=workflow-controller >/dev/null 2>&1; then
        log "ERROR" "Workflow controller not found."
        return 1
    fi

    if ! kubectl -n "$ns" get pods -l app.kubernetes.io/name=argo-workflows-server >/dev/null 2>&1; then
        log "ERROR" "Argo Workflows server not found."
        return 1
    fi

    log "INFO" "Argo Workflows installed successfully in namespace: $ns"
    kubectl -n "$ns" get pods
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
        --version)
            VERSION="$2"
            shift 2
            ;;
        --artifact-repo)
            ARTIFACT_REPO="$2"
            shift 2
            ;;
        --artifact-s3-bucket)
            ARTIFACT_S3_BUCKET="$2"
            shift 2
            ;;
        --no-wait)
            WAIT="false"
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

NAMESPACE="${NAMESPACE:-${K8S_NAMESPACE:-argo}}"
VERSION="${VERSION:-${ARGO_VERSION:-3.5.8}}"

check_dependencies

log "INFO" "Argo Workflows Installation"
log "INFO" "Namespace: $NAMESPACE"
log "INFO" "Version: $VERSION"

create_namespace "$NAMESPACE"
install_argo "$NAMESPACE" "$VERSION"
configure_artifact_repo "$NAMESPACE" "$ARTIFACT_S3_BUCKET"
wait_for_ready "$NAMESPACE"
verify_installation "$NAMESPACE"

log "INFO" "Installation complete."