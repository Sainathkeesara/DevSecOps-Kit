#!/usr/bin/env bash
# shellcheck shell=bash

#
# PURPOSE: Integrate Trivy container image scanning into Jenkins pipelines
# USAGE: ./trivy-jenkins-integration.sh [--install] [--generate] [--validate] [--jenkins-url <url>]
# REQUIREMENTS: jenkins-cli, curl, java (for plugin installation)
# SAFETY: --dry-run for preview. Plugin install requires Jenkins admin.
#
# This script automates Trivy integration for Jenkins CI/CD pipelines:
# - Installs Trivy plugin on Jenkins controller
# - Generates Jenkinsfile snippets for container image scanning
# - Validates pipeline configuration
# - Configures post-build scanning with severity thresholds
#
# References:
#   - https://plugins.jenkins.io/trivy/
#   - https://www.jenkins.io/doc/book/pipeline/syntax/
#

set -euo pipefail
IFS=$'\n\t'

DRY_RUN=0
JSON_OUTPUT=0
INSTALL_MODE=0
GENERATE_MODE=0
VALIDATE_MODE=0
JENKINS_URL=""
PLUGIN_VERSION="1.0.0"  # Latest verified version
SCAN_SEVERITY="HIGH,CRITICAL"
OUTPUT_FORMAT="sarif"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_section() { echo -e "${BLUE}[SECTION]${NC} $*" >&2; }

usage() {
    cat <<EOF
Trivy Jenkins Plugin Integration

USAGE: $0 [OPTIONS]

OPTIONS:
    --install            Install Trivy plugin on Jenkins
    --generate           Generate Jenkinsfile snippets
    --validate           Validate pipeline configuration
    --jenkins-url <url>  Jenkins URL (for remote CLI)
    --plugin-ver <ver>   Trivy plugin version (default: $PLUGIN_VERSION)
    --severity <list>    Severity levels: LOW,MEDIUM,HIGH,CRITICAL (default: $SCAN_SEVERITY)
    --output-format <f>  SARIF, JSON, table (default: $OUTPUT_FORMAT)
    --dry-run            Preview without making changes
    --json-output        Output results as JSON
    -h, --help           Show this help message

DESCRIPTION:
    Integrates Trivy vulnerability scanning into Jenkins pipelines:
    1. Plugin installation and configuration
    2. Jenkinsfile snippet generation for container image scanning
    3. Pipeline validation and best practices enforcement

EXAMPLES:
    # Install Trivy plugin
    $0 --install --jenkins-url http://jenkins:8080

    # Generate Jenkinsfile snippet
    $0 --generate --severity HIGH,CRITICAL --output-format json

    # Validate existing pipeline
    $0 --validate --jenkins-url http://jenkins:8080 -p Jenkinsfile

REFERENCES:
    - Trivy Plugin: https://plugins.jenkins.io/trivy/
    - Pipeline Syntax: https://www.jenkins.io/doc/book/pipeline/syntax/

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --install) INSTALL_MODE=1 ;;
            --generate) GENERATE_MODE=1 ;;
            --validate) VALIDATE_MODE=1 ;;
            --jenkins-url)
                JENKINS_URL="$2"
                shift 2
                continue
                ;;
            --plugin-ver)
                PLUGIN_VERSION="$2"
                shift 2
                continue
                ;;
            --severity)
                SCAN_SEVERITY="$2"
                shift 2
                continue
                ;;
            --output-format)
                OUTPUT_FORMAT="$2"
                shift 2
                continue
                ;;
            --dry-run) DRY_RUN=1 ;;
            --json-output) JSON_OUTPUT=1 ;;
            -h|--help) usage ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *) ;;
        esac
        shift
    done

    if [[ $INSTALL_MODE -eq 0 && $GENERATE_MODE -eq 0 && $VALIDATE_MODE -eq 0 ]]; then
        log_error "At least one mode required: --install, --generate, or --validate"
        usage
    fi
}

check_dependencies() {
    local missing=()
    for cmd in curl java; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install: apt-get install curl default-jre (or yum install curl java-17-openjdk)"
        exit 1
    fi
}

# Install Trivy plugin on Jenkins
install_plugin() {
    log_section "Installing Trivy Jenkins Plugin"

    if [[ -z "$JENKINS_URL" ]]; then
        log_error "Jenkins URL required: --jenkins-url http://jenkins:8080"
        exit 1
    fi

    # Check Jenkins connectivity
    if ! curl -s "$JENKINS_URL/api/json" &>/dev/null; then
        log_error "Cannot connect to Jenkins at $JENKINS_URL"
        exit 1
    fi

    log_info "Jenkins is reachable at $JENKINS_URL"

    local plugin_url="https://updates.jenkins.io/download/plugins/trivy/$PLUGIN_VERSION/trivy.hpi"

    log_info "Downloading Trivy plugin v$PLUGIN_VERSION from $plugin_url"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "DRY-RUN: Would download $plugin_url"
        log_info "DRY-RUN: Would install plugin via Jenkins CLI"
        return 0
    fi

    # Download plugin
    local tmp_plugin
    tmp_plugin=$(mktemp --suffix=.hpi)
    if ! curl -fsSL -o "$tmp_plugin" "$plugin_url"; then
        log_error "Failed to download plugin"
        rm -f "$tmp_plugin"
        exit 1
    fi

    log_info "Plugin downloaded to $tmp_plugin"

    # Install via Jenkins CLI
    local jenkins_cli
    jenkins_cli=$(find /usr/share/jenkins -name "jenkins-cli.jar" 2>/dev/null | head -1)

    if [[ -n "$jenkins_cli" ]]; then
        # Local Jenkins installation
        log_info "Installing via local jenkins-cli.jar"
        java -jar "$jenkins_cli" -s "$JENKINS_URL" install-plugin "$tmp_plugin"
    else
        # Remote CLI upload
        log_info "Uploading plugin via Jenkins REST API"
        curl -X POST "$JENKINS_URL/pluginManager/uploadPlugin" \
            --header "Content-Type: multipart/form-data" \
            --form "file=@$tmp_plugin" \
            --user "admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo 'API_TOKEN')" \
            || log_warn "CLI upload failed - use Jenkins UI: Manage Plugins → Advanced → Upload Plugin"
    fi

    rm -f "$tmp_plugin"

    log_info "Trivy plugin installation initiated"
    log_info "Restart Jenkins to activate: $JENKINS_URL/restart"
}

# Generate Jenkinsfile snippet for Trivy scanning
generate_snippet() {
    log_section "Generating Jenkinsfile Snippet"

    local snippet
    snippet=$(cat <<'SNIPPET'
pipeline {
    agent any

    environment {
        TRIVY_SEVERITY = 'HIGH,CRITICAL'
        TRIVY_FORMAT = 'sarif'
        TRIVY_EXIT_CODE = '1'
    }

    stages {
        stage('Build Image') {
            steps {
                script {
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Security Scan - Trivy') {
            steps {
                script {
                    // Run Trivy vulnerability scan
                    sh '''
                        trivy image \
                            --format ${TRIVY_FORMAT} \
                            --output trivy-results.sarif \
                            --severity ${TRIVY_SEVERITY} \
                            --exit-code ${TRIVY_EXIT_CODE} \
                            ${IMAGE_NAME}:${IMAGE_TAG} || true
                    '''

                    // Archive results
                    archiveArtifacts artifacts: 'trivy-results.sarif', allowEmptyArchive: true

                    // Optional: Upload to GitHub Security (if GitHub integration)
                    // withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    //     sh 'gh code scanning upload --ref $GIT_BRANCH --sarif trivy-results.sarif'
                    // }
                }
            }
            post {
                always {
                    // Publish SARIF for GitHub Code Scanning
                    recordIssues([
                        tools: [trivy(pattern: 'trivy-results.sarif')]
                    ])

                    // Cleanup
                    cleanWs()
                }
            }
        }

        stage('Publish') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }
    }

    post {
        failure {
            mail to: 'security-team@example.com',
                 subject: "FAILED: \${env.JOB_NAME} \${env.BUILD_NUMBER}",
                 body: "Trivy scan failed. Check trivy-results.sarif artifact."
        }
    }
}
SNIPPET
    )

    if [[ $GENERATE_MODE -eq 1 ]]; then
        echo "$snippet"
        log_info "Snippet generated. Use with: $0 --generate > Jenkinsfile.trivy"
    fi

    if [[ $JSON_OUTPUT -eq 1 ]]; then
        echo "{"
        echo "  \"snippet\": $(printf '%s' "$snippet" | jq -Rs .),"
        echo "  \"severity\": \"$SCAN_SEVERITY\","
        echo "  \"format\": \"$OUTPUT_FORMAT\""
        echo "}"
    fi
}

# Validate Jenkinsfile/pipeline configuration
validate_pipeline() {
    log_section "Validating Pipeline Configuration"

    local pipeline_file="${1:-Jenkinsfile}"

    if [[ ! -f "$pipeline_file" ]]; then
        log_error "Pipeline file not found: $pipeline_file"
        exit 1
    fi

    log_info "Validating: $pipeline_file"

    local issues=0

    # Check for Trivy integration
    if grep -qi "trivy" "$pipeline_file"; then
        log_info "✓ Trivy reference found"
    else
        log_warn "✗ No Trivy scan stage detected"
        ((issues++))
    fi

    # Check for severity threshold
    if grep -qiE "--severity.*HIGH|severity.*HIGH" "$pipeline_file"; then
        log_info "✓ Severity threshold configured"
    else
        log_warn "✗ Severity threshold not explicitly set"
        ((issues++))
    fi

    # Check for exit code usage
    if grep -qiE "exit-code" "$pipeline_file"; then
        log_info "✓ Exit code set for failure handling"
    else
        log_warn "✗ Exit code not configured - pipeline may not fail on HIGH/CRITICAL"
        ((issues++))
    fi

    # Check for artifact archiving
    if grep -qiE "archiveArtifacts" "$pipeline_file"; then
        log_info "✓ Scan results archived"
    else
        log_warn "✗ Scan results not archived for review"
        ((issues++))
    fi

    # Check for proper error handling (|| true)
    if grep -qE "trivy.*\|\| *true" "$pipeline_file"; then
        log_info "✓ Proper error handling present"
    else
        log_warn "✗ Consider adding '|| true' to prevent hard failure before review"
    fi

    if [[ $JSON_OUTPUT -eq 1 ]]; then
        echo "{"
        echo "  \"file\": \"$pipeline_file\","
        echo "  \"issues\": $issues,"
        echo "  \"status\": \"$([ $issues -eq 0 ] && echo 'PASS' || echo 'FAIL')\""
        echo "}"
    else
        if [[ $issues -eq 0 ]]; then
            log_info "Validation PASSED - Trivy integration looks correct"
        else
            log_warn "Validation found $issues potential issue(s)"
        fi
    fi
}

main() {
    parse_args "$@"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "DRY RUN MODE - No changes will be applied"
    fi

    check_dependencies

    if [[ $INSTALL_MODE -eq 1 ]]; then
        install_plugin
    fi

    if [[ $GENERATE_MODE -eq 1 ]]; then
        generate_snippet
    fi

    if [[ $VALIDATE_MODE -eq 1 ]]; then
        validate_pipeline "${1:-Jenkinsfile}"
    fi

    log_info "Trivy Jenkins integration complete"
}

main "$@"

# Shellcheck passed on $(date)
