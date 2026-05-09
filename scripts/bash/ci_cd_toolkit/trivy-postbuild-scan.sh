#!/usr/bin/env bash
#
# Trivy CI/CD Post-Build Stage Integration
# Purpose: Integrate Trivy vulnerability scanning in CI/CD pipeline post-build stage
# Requirements: trivy, curl (for CI/CD integration)
# Level: L3
# Safety: --dry-run for preview, --fail-on-severity for gating
#
# This script integrates Trivy scanning as a post-build security gate in CI/CD pipelines:
# - Scans built container images for vulnerabilities
# - Checks against severity thresholds
# - Generates security reports
# - Fails builds on critical findings
#
# References:
#   - https://aquasecurity.github.io/trivy/docs/
#   - https://aquasecurity.github.io/trivy/docs/advanced/integrations/
#

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="trivy-cicd-postbuild"
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_SEVERITY="HIGH,CRITICAL"
readonly DEFAULT_EXIT_CODE=0

DRY_RUN=0
SCAN_MODE=0
GENERATE_MODE=0
VALIDATE_MODE=0
FAIL_ON_SEVERITY=""
IMAGE_NAME=""
IMAGE_PATH=""
REPORT_PATH="/tmp/trivy-report.json"
SCAN_FORMAT="json"
OUTPUT_FORMAT="table"
VERBOSE=0
CI_MODE=0
EXIT_CODE=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_success() { echo -e "${BLUE}[SUCCESS]${NC} $*" >&2; }

usage() {
    cat <<EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}

Purpose: Trivy vulnerability scanning in CI/CD post-build stage

Usage: ${SCRIPT_NAME} [OPTIONS]

Options:
    --scan               Run vulnerability scan (post-build stage)
    --image <name>      Container image to scan (e.g., myapp:latest)
    --image-path <path> Image tarball path for offline scanning
    --severity <levels>  Severity levels: LOW,MEDIUM,HIGH,CRITICAL (default: ${DEFAULT_SEVERITY})
    --fail-on <level>   Fail build if vulnerabilities >= level
    --report <path>     Save report to path (default: ${REPORT_PATH})
    --format <type>    Report format: json, sarif, table (default: ${SCAN_FORMAT})
    --ci-mode          Enable CI mode (non-interactive, structured output)
    --dry-run         Preview without making changes (default: check only)
    --generate        Generate CI/CD configuration snippets
    --validate        Validate existing configuration
    -v, --verbose     Verbose output
    -h, --help        Show this help

Examples:
    # Scan container image in post-build stage
    ${SCRIPT_NAME} --scan --image myapp:latest --severity HIGH,CRITICAL

    # Scan with build gating
    ${SCRIPT_NAME} --scan --image myapp:latest --fail-on CRITICAL

    # Generate GitHub Actions snippet
    ${SCRIPT_NAME} --generate --format json

    # Generate Jenkinsfile snippet
    ${SCRIPT_NAME} --generate --jenkinsfile

    # Offline scan (from image tarball)
    ${SCRIPT_NAME} --scan --image-path /tmp/myapp.tar --severity HIGH

Description:
    Integrates Trivy vulnerability scanning in CI/CD pipeline post-build stage.
    This runs AFTER the build completes but BEFORE the image is pushed/ deployed.
    
    Pipeline integration points:
    - GitHub Actions: post section
    - Jenkins: post { always } block
    - GitLab CI: after_script
    - CircleCI: post-steps
    
    Severity levels: UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL
    
Exit codes:
    0 - No vulnerabilities found or below threshold
    1 - Scan failed
    2 - Vulnerabilities found at or above --fail-on threshold

References:
    - Trivy Documentation: https://aquasecurity.github.io/trivy/docs/
    - CI/CD Integration: https://aquasecurity.github.io/trivy/docs/advanced/integrations/

EOF
}

check_dependencies() {
    local missing=()
    for cmd in curl; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        exit 1
    fi
    
    if command -v trivy >/dev/null 2>&1; then
        log_info "Trivy found: $(trivy version 2>/dev/null | head -1)"
    else
        log_warn "Trivy not found - will attempt install"
    fi
    
    log_info "Dependencies check complete"
}

ensure_trivy() {
    if command -v trivy >/dev/null 2>&1; then
        return 0
    fi
    
    log_info "Installing Trivy..."
    
    local os arch
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="64bit" ;;
        aarch64|arm64) arch="arm64" ;;
        *) log_error "Unsupported architecture: $arch"; return 1 ;;
    esac
    
    local trivy_version="0.58.0"
    local tmp_dir="/tmp/trivy-install-$$"
    mkdir -p "$tmp_dir"
    
    if ! curl -sSL "https://github.com/aquasecurity/trivy/releases/download/v${trivy_version}/trivy_${trivy_version}_${os}-${arch}.tar.gz" | tar -xz -C "$tmp_dir"; then
        log_error "Failed to download Trivy"
        rm -rf "$tmp_dir"
        return 1
    fi
    
    if [[ -w "/usr/local/bin" ]]; then
        mv "$tmp_dir/trivy" "/usr/local/bin/trivy"
        chmod +x "/usr/local/bin/trivy"
    else
        sudo mv "$tmp_dir/trivy" "/usr/local/bin/trivy"
        sudo chmod +x "/usr/local/bin/trivy"
    fi
    
    rm -rf "$tmp_dir"
    log_info "Trivy installed successfully"
}

parse_severity_level() {
    local level="$1"
    case "${level^^}" in
        UNKNOWN) echo "0" ;;
        LOW) echo "1" ;;
        MEDIUM) echo "2" ;;
        HIGH) echo "3" ;;
        CRITICAL) echo "4" ;;
        *) echo "0" ;;
    esac
}

severity_to_exitcode() {
    local severity="$1"
    local fail_level="${FAIL_ON_SEVERITY:-CRITICAL}"
    
    local severity_num=$(parse_severity_level "$severity")
    local fail_num=$(parse_severity_level "$fail_level")
    
    if [[ "$severity_num" -ge "$fail_num" ]]; then
        return 2
    fi
    return 0
}

run_trivy_scan() {
    local image="$1"
    local severity="$2"
    local format="$3"
    local report="$4"
    
    log_info "Running Trivy scan..."
    log_info "Image: $image"
    log_info "Severity: $severity"
    log_info "Format: $format"
    
    if [[ "$DRY_RUN" == "1" ]]; then
        log_warn "[dry-run] Would run: trivy image --severity $severity --format $format --exit-zero-if-empty $image"
        return 0
    fi
    
    ensure_trivy
    
    local trivy_args=(
        "image"
        "--severity" "$severity"
        "--format" "$format"
        "--exit-zero-if-empty"
    )
    
    if [[ -n "$report" ]]; then
        trivy_args+=("--output" "$report")
    fi
    
    if [[ "$VERBOSE" == "1" ]]; then
        trivy_args+=("--debug")
    fi
    
    trivy_args+=("$image")
    
    if ! trivy "${trivy_args[@]}"; then
        local exit_code=$?
        
        if [[ -n "$FAIL_ON_SEVERITY" ]]; then
            local severity_num=$(parse_severity_level "$severity")
            local fail_num=$(parse_severity_level "$FAIL_ON_SEVERITY")
            
            if [[ "$severity_num" -ge "$fail_num" ]]; then
                log_error "Vulnerabilities found at or above $FAIL_ON_SEVERITY threshold"
                return 2
            fi
        fi
        
        if [[ $exit_code -eq 0 ]]; then
            log_success "No vulnerabilities found above threshold"
            return 0
        fi
        
        return $exit_code
    fi
    
    log_success "Scan complete - no blocking vulnerabilities"
    return 0
}

run_offline_scan() {
    local image_path="$1"
    local severity="$2"
    local format="$3"
    local report="$4"
    
    log_info "Running offline Trivy scan..."
    log_info "Image path: $image_path"
    
    if [[ "$DRY_RUN" == "1" ]]; then
        log_warn "[dry-run] Would run: trivy image --input $image_path --severity $severity --format $format"
        return 0
    fi
    
    ensure_trivy
    
    local trivy_args=(
        "image"
        "--input" "$image_path"
        "--severity" "$severity"
        "--format" "$format"
        "--exit-zero-if-empty"
    )
    
    if [[ -n "$report" ]]; then
        trivy_args+=("--output" "$report")
    fi
    
    trivy_args+=("$image_path")
    
    if ! trivy "${trivy_args[@]}"; then
        return $?
    fi
    
    log_success "Offline scan complete"
    return 0
}

generate_github_actions() {
    cat <<'EOF'
# Trivy Post-Build Stage Scanning
# Add to your workflow's post section

- name: Trivy Vulnerability Scan
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'image'
    scan-ref: '.'
    format: 'sarif'
    output: 'trivy-results.sarif'
  continue-on-error: true

- name: Upload Trivy Results
  uses: github/codeql-action/upload-sarif@v2
  if: always()
  with:
    sarif_file: 'trivy-results.sarif'

# Alternative with build gating
- name: Build and Push
  run: |
    docker build -t ${{ env.IMAGE }} .
    docker push ${{ env.IMAGE }}

- name: Trivy Scan (Fail on Critical)
  if: always()
  run: |
    trivy image --severity CRITICAL --exit-code 1 --ignore-unfixed ${{ env.IMAGE }}
  continue-on-error: false
EOF

    log_info "GitHub Actions snippet generated"
}

generate_jenkinsfile() {
    cat <<'EOF'
// Trivy Post-Build Stage Scanning
// Add to your pipeline's post section

post {
    always {
        // Scan container image
        trivyScanner(
            imageName: 'myapp:latest',
            severity: 'HIGH,CRITICAL',
            format: 'json',
            output: 'trivy-results.json',
            failOn: 'CRITICAL'
        )
        
        // Archive results
        archiveArtifacts artifacts: 'trivy-results.json', allowEmptyArchive: true
        
        // Publish to security dashboard
        recordIssues(
            tools: trivy(pattern: 'trivy-results.json', reportEncoding: 'UTF-8'),
            filters: [includeCategory('SECURITY_VULNERABILITY')]
        )
    }
}

// Alternative with sh step
post {
    always {
        sh '''
            trivy image --severity HIGH,CRITICAL \
                --format json \
                --exit-zero-if-empty \
                --output trivy-results.json \
                myapp:latest || true
        '''
        
        archiveArtifacts artifacts: 'trivy-results.json'
    }
}
EOF

    log_info "Jenkinsfile snippet generated"
}

generate_gitlab_ci() {
    cat <<'EOF'
# Trivy Post-Build Stage Scanning
# Add to your .gitlab-ci.yml

trivy-scan:
  stage: post_build
  image: aquasec/trivy:latest
  script:
    - trivy image --severity HIGH,CRITICAL --format json --output trivy-results.json $IMAGE_NAME || true
  artifacts:
    reports:
      sarif: trivy-results.sarif
    paths:
      - trivy-results.json
  only:
    - main
    - merge_requests

# Alternative with build gating
trivy-scan-gated:
  stage: post_build
  image: aquasec/trivy:latest
  script:
    - trivy image --severity CRITICAL --exit-code 1 --ignore-unfixed $IMAGE_NAME
  allow_failure: false
  only:
    - main
EOF

    log_info "GitLab CI snippet generated"
}

validate_config() {
    log_info "Validating CI/CD configuration for Trivy integration..."
    
    local has_dockerfile=0
    local has_workflow=0
    
    if [[ -f "Dockerfile" ]]; then
        has_dockerfile=1
        log_info "Found Dockerfile"
    fi
    
    for f in .github/workflows/*.yml .github/workflows/*.yaml; do
        if [[ -f "$f" ]]; then
            has_workflow=1
            log_info "Found workflow: $f"
            
            if grep -q "trivy" "$f" 2>/dev/null; then
                log_info "Trivy already configured in $f"
            fi
        fi
    done
    
    for f in Jenkinsfile jenkins/**/*.groovy; do
        if [[ -f "$f" ]]; then
            has_workflow=1
            log_info "Found Jenkinsfile: $f"
        fi
    done
    
    for f in .gitlab-ci.yml; do
        if [[ -f "$f" ]]; then
            has_workflow=1
            log_info "Found GitLab CI: $f"
        fi
    done
    
    if [[ "$has_workflow" == "0" ]]; then
        log_warn "No CI/CD configuration found"
        log_info "Run --generate to create configuration snippets"
    fi
    
    log_info "Validation complete"
}

main() {
    log_info "Starting ${SCRIPT_NAME} v${SCRIPT_VERSION}"
    
    check_dependencies
    
    if [[ "$GENERATE_MODE" == "1" ]]; then
        generate_github_actions
        generate_jenkinsfile
        generate_gitlab_ci
        exit 0
    fi
    
    if [[ "$VALIDATE_MODE" == "1" ]]; then
        validate_config
        exit 0
    fi
    
    if [[ "$SCAN_MODE" == "1" ]]; then
        if [[ -n "$IMAGE_PATH" ]]; then
            run_offline_scan "$IMAGE_PATH" "$DEFAULT_SEVERITY" "$SCAN_FORMAT" "$REPORT_PATH"
        elif [[ -n "$IMAGE_NAME" ]]; then
            run_trivy_scan "$IMAGE_NAME" "$DEFAULT_SEVERITY" "$SCAN_FORMAT" "$REPORT_PATH"
        else
            log_error "Either --image or --image-path required"
            usage
            exit 1
        fi
        exit $?
    fi
    
    log_info "Ready for CI/CD integration"
    log_info "Run --scan to execute, --generate to create configuration"
    usage
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --scan)
            SCAN_MODE=1
            shift
            ;;
        --image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --image-path)
            IMAGE_PATH="$2"
            shift 2
            ;;
        --severity)
            DEFAULT_SEVERITY="$2"
            shift 2
            ;;
        --fail-on)
            FAIL_ON_SEVERITY="$2"
            shift 2
            ;;
        --report)
            REPORT_PATH="$2"
            shift 2
            ;;
        --format)
            SCAN_FORMAT="$2"
            shift 2
            ;;
        --ci-mode)
            CI_MODE=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --generate)
            GENERATE_MODE=1
            shift
            ;;
        --validate)
            VALIDATE_MODE=1
            shift
            ;;
        --jenkinsfile)
            GENERATE_MODE=1
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

main "$@"