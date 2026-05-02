# Linux: Shell Script Library for Infrastructure-as-Code Operations

## Purpose

This shell script library provides reusable functions for infrastructure provisioning, configuration management, and deployment automation in Linux environments. It standardizes operations across Terraform, Ansible, and system utilities with built-in safety features like dry-run mode and binary checks.

## When to Use

- Building infrastructure automation pipelines
- Standardizing IaC operations across teams
- Creating reusable deployment scripts
- Automating Terraform and Ansible workflows
- Managing system services in production
- Implementing backup and restore procedures
- Validating configuration files before deployment

## Prerequisites

- Target Linux systems running RHEL/CentOS 7+, Ubuntu 18.04+, or Debian 9+
- Bash 4.0 or later
- Standard Linux utilities: grep, awk, sed, find, tar
- Optional: terraform (for tf_* functions), ansible (for ansible_* functions)
- SSH access for remote operations
- Sudo/root access for system-level operations

## Steps

### 1. Install the Library

```bash
# Download to standard location
sudo mkdir -p /usr/local/lib/iac
sudo cp iac-operations.sh /usr/local/lib/iac/
sudo chmod +x /usr/local/lib/iac/iac-operations.sh

# Source in your scripts
source /usr/local/lib/iac/iac-operations.sh
```

### 2. Source the Library in Your Scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

# Source the library
source /usr/local/lib/iac/iac-operations.sh

# Now use the functions
tf_init
tf_plan
```

### 3. Terraform Operations

```bash
# Initialize Terraform
tf_init /path/to/terraform

# Validate configuration
tf_validate /path/to/terraform

# Plan with variables
tf_plan /path/to/terraform terraform.tfvars

# Apply changes
tf_apply /path/to/terraform

# Destroy infrastructure
tf_destroy /path/to/terraform
```

### 4. Ansible Operations

```bash
# Run playbook
ansible_run site.yml inventory/production.ini "env=production"

# Check mode (dry-run)
ansible_check site.yml inventory/production.ini

# Ad-hoc command
ansible_adhoc all setup "" inventory/production.ini
```

### 5. Service Management

```bash
# Check service status
if service_is_active nginx; then
    echo "nginx is running"
else
    echo "nginx is not running"
fi

# Manage services
service_stop nginx
service_start nginx
service_restart nginx
service_enable nginx
```

### 6. Network Utilities

```bash
# Check if port is open
if port_is_open localhost 80; then
    echo "Port 80 is open"
fi

# Wait for service to be ready
wait_for_port localhost 5432 120 5

# Get primary IP
IP=$(get_primary_ip)
echo "Server IP: $IP"
```

### 7. File Operations

```bash
# Create directory with permissions
ensure_dir /opt/myapp 0755 myapp:myapp

# Backup a file
backup_file /etc/nginx/nginx.conf

# Compare configuration files
file_diff /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
```

### 8. Template Rendering

```bash
# Create a template file (config.j2)
# database_host={{ DB_HOST }}
# database_port={{ DB_PORT }}

# Render with variables
DB_HOST="db.example.com"
DB_PORT="5432"
render_template config.j2 config.conf
```

### 9. Backup and Restore

```bash
# Create backup archive
create_backup /etc/nginx /var/backups nginx-config

# Restore from backup
restore_backup /var/backups/nginx-config.tar.gz /etc
```

### 10. Validation

```bash
# Validate configuration files
validate_yaml playbook.yml
validate_json config.json
```

## Verify

### 1. Library Installation

```bash
# Check library is sourced correctly
source /usr/local/lib/iac/iac-operations.sh
show_version

# Expected output: iac-operations.sh version 1.0.0
```

### 2. Function Availability

```bash
# List available functions
type tf_init tf_plan tf_apply
type ansible_run ansible_adhoc
type ensure_dir backup_file
```

### 3. Dry-Run Mode

```bash
# Test dry-run mode
DRY_RUN=true tf_apply /tmp/terraform

# Should output: [DRY-RUN] terraform -chdir=/tmp/terraform apply -input=false -auto-approve
```

### 4. Binary Checks

```bash
# Test binary check
require_binary terraform || echo "terraform not installed"
```

## Rollback

### 1. Disable Dry-Run Mode

```bash
# For actual changes, ensure DRY_RUN is unset or false
unset DRY_RUN
export DRY_RUN=false
```

### 2. Manual Rollback

If changes were made and need to be reverted:

```bash
# For Terraform changes
tf_destroy /path/to/terraform

# For file changes, restore from backup
restore_backup /var/backups/config-20240101_120000.tar.gz /etc
```

### 3. Error Handling

```bash
# Set cleanup handler for errors
ERROR_CLEANUP="service_stop myapp"
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR
```

## Common Errors

### Error: "Command not found" when sourcing

**Cause:** Library path is incorrect.
```bash
# Verify path
ls -la /usr/local/lib/iac/iac-operations.sh

# Correct path if needed
source /correct/path/to/iac-operations.sh
```

### Error: "DRY_RUN command not found"

**Cause:** DRY_RUN variable not set correctly.
```bash
# Set properly
export DRY_RUN=true  # For dry-run
unset DRY_RUN        # For actual execution
```

### Error: "terraform: command not found"

**Cause:** Terraform not installed.
```bash
# Install terraform
apt install terraform  # Debian/Ubuntu
yum install terraform  # RHEL/CentOS
```

### Error: "ansible-playbook: command not found"

**Cause:** Ansible not installed.
```bash
# Install ansible
apt install ansible  # Debian/Ubuntu
yum install ansible  # RHEL/CentOS
```

### Error: "Permission denied" for service operations

**Cause:** Insufficient privileges.
```bash
# Run with sudo
sudo service_restart nginx

# Or ensure user has sudo access
sudo -l | grep systemctl
```

### Error: "validation failed for field"

**Cause:** Invalid parameter passed to function.
```bash
# Check function signature
show_help

# Example correct usage
tf_plan                      # Correct
tf_plan /path/to/work/dir    # Correct
tf_plan ""                   # Incorrect - empty path
```

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Systemd Documentation](https://www.freedesktop.org/software/systemd/man/)