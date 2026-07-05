# Linux: Infrastructure-as-Code Automation Workflows for DevOps Pipelines

## Purpose

This guide documents comprehensive Infrastructure-as-Code (IaC) automation workflows for Linux systems in DevOps pipelines. It provides reusable pipeline templates, workflow patterns, and integration strategies that combine Terraform, Ansible, and shell scripting to achieve automated, reproducible infrastructure deployments across development, staging, and production environments.

## When to Use

- Building CI/CD pipelines for infrastructure provisioning
- Creating reusable deployment workflows across environments
- Implementing GitOps-style infrastructure management
- Automating multi-stage environment promotion (dev → staging → prod)
- Establishing infrastructure testing and validation gates
- Implementing infrastructure rollback and disaster recovery procedures
- Standardizing IaC operations across team pipelines

## Prerequisites

- Linux systems running RHEL 7+, Ubuntu 18.04+, or Debian 9+
- Bash 4.0+ with `set -euo pipefail`
- Git repository with CI/CD configuration (GitHub Actions, GitLab CI, Jenkins)
- Terraform 1.0+ for infrastructure provisioning
- Ansible 2.9+ for configuration management
- SSH access to target infrastructure
- Optional: Vault for secrets management
- Required binaries: git, curl, jq, terraform, ansible

## Steps

### 1. Pipeline Architecture Overview

The IaC pipeline follows a staged approach:

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Source    │───▶│   Plan      │───▶│   Validate  │───▶│   Deploy    │
│   Commit    │    │   (.tfplan) │    │   (tests)   │    │   (apply)   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

Each stage includes:
- Source: Git commit triggers pipeline
- Plan: Generate Terraform plan, store as artifact
- Validate: Run infrastructure tests, security scans, policy checks
- Deploy: Apply changes with approval gates for production

### 2. Project Structure Setup

Create a standardized project structure:

```bash
mkdir -p pipeline-project/{terraform/{environments/{dev,staging,prod},modules},ansible/{playbooks,roles,inventory},scripts,pipeline,tests}
cd pipeline-project
```

Directory structure:
```
pipeline-project/
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── modules/
├── ansible/
│   ├── playbooks/
│   ├── roles/
│   └── inventory/
├── scripts/
│   ├── pipeline/
│   └── lib/
├── pipeline/
│   └── workflows/
└── tests/
```

### 3. Terraform Workflow Integration

Use the existing iac-operations.sh library for Terraform operations:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Source the IaC operations library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/iac-operations.sh"

# Pipeline common variables
export TF_WORKSPACE="${TF_WORKSPACE:-dev}"
export TF_STATE_BUCKET="${TF_STATE_BUCKET:-your-terraform-state}"
export TF_DYNAMO_TABLE="${TF_DYNAMO_TABLE:-terraform-locks}"

# Initialize Terraform
tf_init "/path/to/terraform"

# Validate configuration
tf_validate "/path/to/terraform"

# Generate plan
tf_plan "/path/to/terraform" "terraform.tfvars"

# Store plan for manual approval
if [[ "$ENVIRONMENT" == "production" ]]; then
    echo "Production deployment requires manual approval"
    exit 0
fi

# Apply changes
tf_apply "/path/to/terraform"
```

### 4. Ansible Workflow Integration

Configure Ansible for pipeline execution:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Set Ansible configuration
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_RETRY_FILES_ENABLED=false
export ANSIBLE_STDOUT_CALLBACK=yaml

# Use iac-operations.sh for Ansible calls
source /usr/local/lib/iac/iac-operations.sh

# Run playbook with variables
ansible_run site.yml inventory/production.ini "env=production"

# Or use check mode for validation
ansible_check site.yml inventory/production.ini
```

### 5. CI/CD Pipeline Configuration

#### GitHub Actions Workflow

```yaml
name: IaC Pipeline

on:
  push:
    paths:
      - 'terraform/**'
      - 'ansible/**'
      - 'scripts/**'

env:
  TF_VERSION: '1.6.0'
  ANSIBLE_VERSION: '2.9.27'

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: ${{ env.TF_VERSION }}
      
      - name: Terraform Init
        run: |
          terraform init -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}"
      
      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color -out=tfplan
        continue-on-error: true
      
      - name: Store Plan Artifact
        uses: actions/upload-artifact@v4
        with:
          name: tfplan
          path: tfplan
      
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply tfplan

  ansible:
    needs: terraform
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install Ansible
        run: pip install ansible==${{ env.ANSIBLE_VERSION }}
      
      - name: Ansible Lint
        run: ansible-lint ansible/playbooks/
      
      - name: Run Ansible Playbook
        run: |
          ansible-playbook -i ansible/inventory/prod.yml \
            ansible/playbooks/site.yml --check
```

#### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        TERRAFORM_VERSION = '1.6.0'
        ANSIBLE_VERSION = '2.9.27'
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    
    stages {
        stage('Initialize') {
            steps {
                sh 'terraform --version'
                sh 'ansible --version'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('terraform/environments/prod') {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Ansible Validate') {
            steps {
                sh '''
                    ansible-playbook -i ansible/inventory/prod.yml \
                        ansible/playbooks/site.yml --check
                '''
            }
        }
        
        stage('Deploy') {
            when { branch 'main' }
            steps {
                dir('terraform/environments/prod') {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

### 6. Environment Promotion Workflow

Implement environment promotion with gates:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Environment promotion script
PROMOTION_ENV="${1:-dev}"
APPROVAL_REQUIRED="${2:-false}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

# Validate environment
validate_environment() {
    local env="$1"
    case "$env" in
        dev) log_info "Development environment validated" ;;
        staging) log_info "Staging environment validated" ;;
        prod)
            if [[ "$APPROVAL_REQUIRED" == "true" ]]; then
                log_warn "Production deployment requires approval"
                # Check for approval token or manual trigger
                if [[ -z "${APPROVAL_TOKEN:-}" ]]; then
                    echo "Error: No approval token provided"
                    exit 1
                fi
            fi
            ;;
        *) echo "Error: Unknown environment $env"; exit 1 ;;
    esac
}

# Promote infrastructure
promote_infrastructure() {
    local source_env="$1"
    local target_env="$2"
    
    log_info "Promoting from $source_env to $target_env"
    
    # Copy configuration
    cp -r "terraform/environments/$source_env" "terraform/environments/$target_env"
    
    # Update variables for target environment
    # (implementation depends on specific requirements)
    
    # Run Terraform with target environment
    cd "terraform/environments/$target_env"
    terraform init
    terraform plan -out=tfplan
    terraform apply tfplan
}

# Main execution
main() {
    log_info "Starting environment promotion to $PROMOTION_ENV"
    validate_environment "$PROMOTION_ENV"
    promote_infrastructure "dev" "$PROMOTION_ENV"
    log_info "Promotion complete"
}

main
```

### 7. Testing and Validation Gates

Implement infrastructure testing:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Infrastructure testing script
TEST_TYPE="${1:-all}"
VERBOSE="${VERBOSE:-false}"

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    if [[ "$VERBOSE" == "true" ]]; then
        echo "Running: $test_name"
    fi
    
    if eval "$test_command"; then
        echo "PASS: $test_name"
        return 0
    else
        echo "FAIL: $test_name"
        return 1
    fi
}

# Terraform validation tests
test_terraform() {
    run_test "terraform_validate" "terraform validate"
    run_test "terraform_plan" "terraform plan -detailed-exitcode"
    run_test "terraform_fmt" "terraform fmt -check -recursive"
}

# Ansible validation tests
test_ansible() {
    run_test "ansible_syntax" "ansible-playbook --syntax-check playbooks/site.yml"
    run_test "ansible_lint" "ansible-lint playbooks/site.yml"
    run_test "ansible_check" "ansible-playbook -i inventory/prod.yml playbooks/site.yml --check"
}

# Security tests
test_security() {
    run_test "tfsec" "tfsec . --exit-code"
    run_test "checkov" "checkov -d ."
    run_test "ansible_audit" "ansible-playbook -i inventory/prod.yml playbooks/site.yml --check --tags security"
}

# Main test runner
main() {
    local tests_passed=0
    local tests_failed=0
    
    case "$TEST_TYPE" in
        terraform) test_terraform ;;
        ansible) test_ansible ;;
        security) test_security ;;
        all)
            test_terraform || tests_failed=$((tests_failed + 1))
            test_ansible || tests_failed=$((tests_failed + 1))
            test_security || tests_failed=$((tests_failed + 1))
            ;;
    esac
    
    echo "Tests completed: $tests_failed failed"
    exit $tests_failed
}

main
```

### 8. Integration with Existing Scripts

Leverage the existing iac-operations.sh library:

```bash
#!/usr/bin/env bash
set -euo pipefail

source /usr/local/lib/iac/iac-operations.sh

# Example: Full pipeline integration
pipeline_execute() {
    local environment="$1"
    local action="$2"
    
    # Dry-run by default
    export DRY_RUN="${DRY_RUN:-true}"
    
    case "$action" in
        plan)
            tf_init "/terraform/$environment"
            tf_validate "/terraform/$environment"
            tf_plan "/terraform/$environment" "terraform.tfvars"
            ;;
        apply)
            tf_apply "/terraform/$environment"
            ansible_run "site.yml" "inventory/$environment.yml" ""
            ;;
        destroy)
            tf_destroy "/terraform/$environment"
            ;;
    esac
}

# Execute pipeline
pipeline_execute "production" "plan"
```

### 9. Monitoring and Observability

Integrate with monitoring systems:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Pipeline metrics collection
PIPELINE_START=$(date +%s)
METRICS_FILE="${METRICS_FILE:-/tmp/pipeline-metrics.json}"

log_metric() {
    local metric_name="$1"
    local metric_value="$2"
    echo "{\"metric\":\"$metric_name\",\"value\":$metric_value,\"timestamp\":$(date +%s)}" >> "$METRICS_FILE"
}

# Track pipeline stages
PIPELINE_STAGES=("init" "plan" "validate" "apply" "verify")

track_stage() {
    local stage="$1"
    local status="$2"
    log_metric "pipeline_stage_${stage}_${status}" 1
}

# Example usage in pipeline
main() {
    track_stage "init" "started"
    
    # Terraform init
    terraform init
    track_stage "init" "completed"
    
    track_stage "plan" "started"
    terraform plan -out=tfplan
    track_stage "plan" "completed"
    
    track_stage "apply" "started"
    terraform apply tfplan
    track_stage "apply" "completed"
    
    PIPELINE_END=$(date +%s)
    DURATION=$((PIPELINE_END - PIPELINE_START))
    log_metric "pipeline_duration_seconds" "$DURATION"
}

main
```

## Verify

### 1. Pipeline Structure Validation

```bash
# Verify project structure
ls -la terraform/environments/
ls -la ansible/playbooks/
ls -la scripts/pipeline/

# Verify scripts are executable
find scripts/ -type f -name "*.sh" -exec ls -l {} \;
```

### 2. IaC Library Integration

```bash
# Test iac-operations.sh
source /usr/local/lib/iac/iac-operations.sh
type tf_init tf_plan tf_apply
type ansible_run ansible_check

# Verify functions
tf_validate /path/to/terraform
ansible-playbook --syntax-check ansible/playbooks/site.yml
```

### 3. Pipeline Execution Tests

```bash
# Test with dry-run
DRY_RUN=true ./scripts/pipeline/deploy.sh --environment dev

# Verify plan output
terraform show tfplan | head -50

# Test Ansible check mode
ansible-playbook -i ansible/inventory/dev.yml ansible/playbooks/site.yml --check
```

### 4. CI/CD Integration Tests

```bash
# Test GitHub Actions locally (if act is installed)
act -j terraform --dry-run

# Test Jenkinsfile syntax
jenkins-cli declarative-linter < Jenkinsfile

# Verify workflow files
actionlint .github/workflows/*.yml
```

## Rollback

### 1. Terraform Rollback

```bash
# Using state to rollback
terraform state pull > backup.tfstate
terraform state list
terraform state mv <resource> <previous-resource>

# Or use tfauto (if installed)
tfauto rollback -n 3
```

### 2. Ansible Rollback

```bash
# Use Ansible vault for secrets rollback
ansible-vault decrypt inventory/prod.yml --output=inventory-prod-backup.yml

# Restore from version control
git checkout HEAD~1 -- ansible/playbooks/site.yml
ansible-playbook -i inventory/prod.yml playbooks/site.yml
```

### 3. Full Pipeline Rollback

```bash
#!/usr/bin/env bash
# Pipeline rollback script

ROLLBACK_ENV="${1:-production}"
BACKUP_TAG="${2:-latest}"

# Stop current deployment
terraform destroy -target=<resource> --auto-approve

# Restore previous state
git checkout "$BACKUP_TAG" -- terraform/ ansible/

# Redeploy previous version
./scripts/pipeline/deploy.sh --environment "$ROLLBACK_ENV" --version "$BACKUP_TAG"
```

### 4. Automated Rollback Triggers

```bash
# Check for rollback conditions in pipeline
check_rollback_conditions() {
    # High error rate
    if (( $(kubectl get pods -n production | grep -c Error) > 5 )); then
        echo "Triggering rollback: high error rate"
        return 0
    fi
    
    # Health check failures
    if ! curl -sf "https://api.example.com/health" > /dev/null; then
        echo "Triggering rollback: health check failed"
        return 0
    fi
    
    return 1
}

if check_rollback_conditions; then
    ./scripts/pipeline/rollback.sh production
fi
```

## Common Errors

### Error: "terraform init" fails with backend configuration

**Cause:** Backend configuration is incorrect or credentials are missing.

```bash
# Verify backend configuration
cat terraform/backend.tf

# Check AWS credentials
aws sts get-caller-identity

# Initialize with explicit backend
terraform init -backend-config="bucket=your-state-bucket" \
    -backend-config="key=prod/terraform.tfstate" \
    -backend-config="region=us-east-1"
```

### Error: "ansible-playbook" fails with inventory errors

**Cause:** Inventory file is missing or has syntax errors.

```bash
# Validate inventory syntax
ansible-inventory -i inventory/prod.yml --list

# Test connectivity
ansible -i inventory/prod.yml all -m ping

# Verify inventory file exists
ls -la inventory/prod.yml
```

### Error: "terraform plan" shows unexpected changes

**Cause:** State drift or concurrent modifications.

```bash
# Refresh state
terraform refresh

# Check state for drift
terraform plan -out=tfplan | grep "<>"

# Lock state (prevent concurrent modifications)
terraform force-unlock <lock-id>
```

### Error: Pipeline fails on approval gate

**Cause:** Missing approval token or wrong branch.

```bash
# Verify branch protection rules
# Check if approval is configured in CI/CD

# For GitHub Actions: ensure workflow runs on main branch
# For Jenkins: ensure approval step is configured correctly
```

### Error: "terraform apply" fails with resource conflicts

**Cause:** Resource already exists with different configuration.

```bash
# Import existing resource
terraform import aws_instance.existing i-1234567890abcdef0

# Or taint and recreate
terraform taint aws_instance.existing
terraform apply
```

### Error: Ansible playbook fails on first run

**Cause:** Target system not prepared for Ansible.

```facts:
# Install Ansible on targets
ansible all -i inventory/prod.yml -m apt -a "name=python3" --become

# Or use bootstrap script
./scripts/ansible/bootstrap.sh
```

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/index.html)
- [iac-operations.sh Library](../../../scripts/bash/linux_toolkit/lib/iac-operations.sh)
- [Linux Automation Template](../../../templates/linux-automation/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Terraform Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)