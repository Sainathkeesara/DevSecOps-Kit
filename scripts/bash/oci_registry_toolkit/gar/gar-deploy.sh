#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
PROJECT_ID="${PROJECT_ID:-}"
LOCATION="${LOCATION:-us-central1}"
REPOSITORY_NAME="${REPOSITORY_NAME:-docker-repo}"
REPOSITORY_FORMAT="${REPOSITORY_FORMAT:-docker}"
DESCRIPTION="${DESCRIPTION:-Google Artifact Registry repository}"
ENABLE_VULN_SCANNING="${ENABLE_VULN_SCANNING:-true}"
ADMIN_EMAIL="${ADMIN_EMAIL:-}"
MAX_VERSIONS="${MAX_VERSIONS:-}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Deploy Google Artifact Registry (GAR) for GKE integration.

OPTIONS:
    --dry-run                  Preview installation steps without executing
    --project-id ID           GCP project ID (required)
    --location REGION         GCP region (default: us-central1)
    --repo-name NAME          Repository name (default: docker-repo)
    --format FORMAT           Format: docker, maven, npm, python, apt, yum (default: docker)
    --description TEXT        Repository description
    --enable-vuln-scanning    Enable vulnerability scanning (default: true)
    --admin-email EMAIL       Service account for admin permissions
    --max-versions N          Maximum versions to retain (optional)
    -h, --help                Show this help message

EXAMPLES:
    $0 --dry-run --project-id my-project --repo-name my-repo
    $0 --project-id my-project --location us-east1 --format maven
    PROJECT_ID=my-project $0 --repo-name prod-repo

EOF
    exit 0
}

log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%dT%H:%M:%S%z')] [$level] $*"
}

check_dependencies() {
    log "INFO" "Checking dependencies..."
    local missing=()
    for bin in gcloud docker; do
        if ! command -v "$bin" >/dev/null 2>&1; then
            missing+=("$bin")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        log "ERROR" "Missing required binaries: ${missing[*]}"
        log "ERROR" "Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
        exit 1
    fi
    
    if ! gcloud auth status >/dev/null 2>&1; then
        log "ERROR" "Not authenticated to Google Cloud. Run 'gcloud auth login' first."
        exit 1
    fi
    
    log "INFO" "All dependencies available."
}

check_project_id() {
    if [ -z "$PROJECT_ID" ]; then
        log "ERROR" "Project ID is required. Use --project-id or set PROJECT_ID environment variable."
        exit 1
    fi
    
    if [ "$DRY_RUN" != "true" ]; then
        if ! gcloud projects describe "$PROJECT_ID" >/dev/null 2>&1; then
            log "ERROR" "Project not found or not accessible: $PROJECT_ID"
            exit 1
        fi
    fi
}

enable_apis() {
    local project="$1"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would enable Artifact Registry API in project: $project"
        return 0
    fi
    
    log "INFO" "Enabling Artifact Registry API..."
    
    if gcloud services list --enabled --filter="name:artifactregistry.googleapis.com" --project="$project" 2>/dev/null | grep -q "artifactregistry"; then
        log "INFO" "Artifact Registry API already enabled"
    else
        gcloud services enable artifactregistry.googleapis.com --project="$project"
        log "INFO" "Artifact Registry API enabled"
    fi
}

create_repository() {
    local project="$1"
    local location="$2"
    local name="$3"
    local format="$4"
    local desc="$5"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create repository: $name in $location"
        log "DRY-RUN" "Format: $format, Description: $desc"
        return 0
    fi
    
    log "INFO" "Creating repository: $name"
    
    local create_args=(
        "artifacts" "repositories" "create" "$name"
        "--location=$location"
        "--repository-format=$format"
        "--description=$desc"
        "--project=$project"
    )
    
    if [ "$ENABLE_VULN_SCANNING" = "true" ]; then
        create_args+=("--enable-upstream-policy")
    fi
    
    if gcloud artifacts repositories describe "$name" --location="$location" --project="$project" >/dev/null 2>&1; then
        log "WARN" "Repository already exists: $name"
        log "INFO" "Updating repository configuration..."
        
        gcloud artifacts repositories update "$name" \
            --location="$location" \
            --description="$desc" \
            --project="$project" \
            --quiet
    else
        gcloud "${create_args[@]}"
        log "INFO" "Repository created: $name"
    fi
}

configure_iam() {
    local project="$1"
    local location="$2"
    local name="$3"
    local email="$4"
    
    if [ -z "$email" ]; then
        log "INFO" "No admin email provided, skipping IAM configuration"
        return 0
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would grant artifactregistry.admin to: $email"
        return 0
    fi
    
    log "INFO" "Configuring IAM for: $email"
    
    gcloud artifacts repositories add-iam-policy-binding "$name" \
        --location="$location" \
        --member="serviceAccount:$email" \
        --role="roles/artifactregistry.admin" \
        --project="$project"
    
    log "INFO" "IAM configured successfully"
}

configure_docker_auth() {
    local location="$1"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would configure Docker authentication for: ${location}-docker.pkg.dev"
        return 0
    fi
    
    log "INFO" "Configuring Docker authentication for GAR..."
    
    if command -v docker-credential-gcloud >/dev/null 2>&1; then
        docker-credential-gcloud configure-docker "${location}-docker.pkg.dev"
        log "INFO" "Docker authentication configured"
    else
        gcloud auth configure-docker "${location}-docker.pkg.dev"
        log "INFO" "Docker authentication configured via gcloud"
    fi
}

set_lifecycle_policy() {
    local project="$1"
    local location="$2"
    local name="$3"
    local max_versions="$4"
    
    if [ -z "$max_versions" ] || [ "$max_versions" = "0" ]; then
        log "INFO" "No lifecycle policy configured (max_versions not set)"
        return 0
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would set lifecycle policy: keep last $max_versions versions"
        return 0
    fi
    
    log "INFO" "Setting lifecycle policy to keep last $max_versions versions..."
    
    local tmpfile
    tmpfile=$(mktemp)
    cat > "$tmpfile" << POLICY_EOF
{
  "maximumVersions": $max_versions
}
POLICY_EOF

    gcloud artifacts repositories set-lifecycle-policy "$name" \
        --location="$location" \
        --project="$project" \
        --policy="$tmpfile"
    
    rm -f "$tmpfile"
    log "INFO" "Lifecycle policy configured"
}

get_repository_info() {
    local project="$1"
    local location="$2"
    local name="$3"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would retrieve repository info"
        return 0
    fi
    
    log "INFO" "Retrieving repository information..."
    
    local repo_info
    repo_info=$(gcloud artifacts repositories describe "$name" \
        --location="$location" \
        --project="$project" \
        --format=json 2>/dev/null)
    
    if [ -n "$repo_info" ]; then
        local login_server
        login_server=$(echo "$repo_info" | jq -r '.format + "-pkg.dev"')
        local repo_url="${location}-docker.pkg.dev/${project}/${name}"
        
        echo ""
        echo "=========================================="
        echo "Repository Details:"
        echo "=========================================="
        echo "Name: $name"
        echo "Location: $location"
        echo "Format: $(echo "$repo_info" | jq -r '.format')"
        echo "URL: $repo_url"
        echo "Create Time: $(echo "$repo_info" | jq -r '.createTime')"
        echo "Update Time: $(echo "$repo_info" | jq -r '.updateTime')"
        echo "=========================================="
        echo ""
        echo "Docker push command:"
        echo "  docker push $repo_url/image:tag"
        echo ""
        echo "Docker pull command:"
        echo "  docker pull $repo_url/image:tag"
        echo ""
    fi
}

verify_deployment() {
    local project="$1"
    local location="$2"
    local name="$3"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify GAR deployment"
        return 0
    fi
    
    log "INFO" "Verifying GAR deployment..."
    
    local provisioning_state
    provisioning_state=$(gcloud artifacts repositories describe "$name" \
        --location="$location" \
        --project="$project" \
        --format="value(format)" 2>/dev/null)
    
    if [ -n "$provisioning_state" ]; then
        log "INFO" "Repository verified: $name (format: $provisioning_state)"
        return 0
    else
        log "ERROR" "Failed to verify repository"
        return 1
    fi
}

cleanup() {
    local project="$1"
    local location="$2"
    local name="$3"
    local delete_repo="${DELETE_REPOSITORY:-false}"
    
    if [ "$delete_repo" != "true" ]; then
        log "INFO" "Cleanup skipped (DELETE_REPOSITORY not set)"
        return 0
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would delete repository: $name"
        return 0
    fi
    
    log "INFO" "Cleaning up repository..."
    gcloud artifacts repositories delete "$name" \
        --location="$location" \
        --project="$project" \
        --quiet
    log "INFO" "Repository deleted"
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --project-id) PROJECT_ID="$2"; shift 2 ;;
            --location) LOCATION="$2"; shift 2 ;;
            --repo-name) REPOSITORY_NAME="$2"; shift 2 ;;
            --format) REPOSITORY_FORMAT="$2"; shift 2 ;;
            --description) DESCRIPTION="$2"; shift 2 ;;
            --enable-vuln-scanning) ENABLE_VULN_SCANNING="true"; shift ;;
            --admin-email) ADMIN_EMAIL="$2"; shift 2 ;;
            --max-versions) MAX_VERSIONS="$2"; shift 2 ;;
            -h|--help) usage ;;
            *) log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done
    
    check_dependencies
    check_project_id
    
    log "INFO" "Starting GAR deployment..."
    log "INFO" "Project: $PROJECT_ID"
    log "INFO" "Location: $LOCATION"
    log "INFO" "Repository: $REPOSITORY_NAME"
    log "INFO" "Format: $REPOSITORY_FORMAT"
    log "INFO" "Dry Run: $DRY_RUN"
    
    enable_apis "$PROJECT_ID"
    create_repository "$PROJECT_ID" "$LOCATION" "$REPOSITORY_NAME" "$REPOSITORY_FORMAT" "$DESCRIPTION"
    configure_iam "$PROJECT_ID" "$LOCATION" "$REPOSITORY_NAME" "$ADMIN_EMAIL"
    
    if [ "$REPOSITORY_FORMAT" = "docker" ]; then
        configure_docker_auth "$LOCATION"
    fi
    
    set_lifecycle_policy "$PROJECT_ID" "$LOCATION" "$REPOSITORY_NAME" "$MAX_VERSIONS"
    verify_deployment "$PROJECT_ID" "$LOCATION" "$REPOSITORY_NAME"
    get_repository_info "$PROJECT_ID" "$LOCATION" "$REPOSITORY_NAME"
    
    log "INFO" "GAR deployment completed successfully!"
}

main "$@"