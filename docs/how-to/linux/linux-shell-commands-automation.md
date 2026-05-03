# Linux: Shell Command Patterns for Automated System Administration

## Purpose

This library provides reusable shell command patterns for automated system administration tasks in Linux environments. It standardizes common operations like service management, file operations, network checks, and system monitoring with built-in safety features including dry-run mode, binary checks, and error handling.

## When to Use

- Building automated administration scripts
- Creating reusable DevOps tooling
- Managing system services programmatically
- Performing network and connectivity checks
- Monitoring system resources
- Executing file operations with safety features
- Implementing idempotent automation

## Prerequisites

- Target Linux systems running RHEL/CentOS 7+, Ubuntu 18.04+, or Debian 9+
- Bash 4.0 or later
- Standard Linux utilities: grep, awk, sed, find, ps, df, free, top
- Root/sudo access for system-level operations

## Steps

### 1. Install the Command Library

```bash
# Download to standard location
sudo mkdir -p /usr/local/lib/sysadmin
sudo cp linux-system-commands-library.sh /usr/local/lib/sysadmin/
sudo chmod +x /usr/local/lib/sysadmin/linux-system-commands-library.sh

# Source in your scripts
source /usr/local/lib/sysadmin/linux-system-commands-library.sh
```

### 2. Service Management

```bash
# Check if a service is running
if service_is_active nginx; then
    echo "nginx is running"
fi

# Start/Stop/Restart services
service_start nginx
service_stop nginx
service_restart nginx

# Enable service on boot
service_enable nginx
service_disable nginx

# Check service status with details
service_status nginx
```

### 3. File Operations

```bash
# Create directory with permissions
ensure_dir /opt/myapp 0755 myapp:myapp

# Backup a file before modification
backup_file /etc/nginx/nginx.conf

# Compare two files
file_diff /etc/nginx/nginx.conf /etc/nginx/nginx.conf.new

# Check if file exists and is writable
if file_is_writable /etc/config; then
    echo "File is writable"
fi

# Get file age in days
AGE=$(file_age_days /var/log/syslog)
```

### 4. Network Operations

```bash
# Check if a port is listening
if port_is_listening 8080; then
    echo "Port 8080 is in use"
fi

# Wait for service to be ready
wait_for_port localhost 5432 120 5

# Test connectivity to host
if check_connectivity google.com 443; then
    echo "Connection successful"
fi

# Get primary IP address
IP=$(get_primary_ip)
echo "Server IP: $IP"

# Check if host is reachable
if is_reachable 192.168.1.1; then
    echo "Host is reachable"
fi
```

### 5. System Monitoring

```bash
# Get CPU usage
CPU=$(get_cpu_usage)
echo "CPU: $CPU%"

# Get memory usage
MEM=$(get_memory_usage)
echo "Memory: $MEM%"

# Get disk usage for a path
DISK=$(get_disk_usage /)
echo "Disk: $DISK%"

# Get load average
LOAD=$(get_load_average)
echo "Load: $LOAD"

# Get uptime in human-readable format
UPTIME=$(get_uptime)
echo "Uptime: $UPTIME"

# Get process count
PROCESSES=$(get_process_count)
echo "Processes: $PROCESSES"
```

### 6. User and Group Operations

```bash
# Check if user exists
if user_exists admin; then
    echo "User exists"
fi

# Check if group exists
if group_exists developers; then
    echo "Group exists"
fi

# Get user info
USER_INFO=$(get_user_info nginx)
echo "$USER_INFO"

# Get user's shell
SHELL=$(user_shell admin)
```

### 7. Package Management

```bash
# Check if package is installed
if package_is_installed nginx; then
    echo "nginx is installed"
fi

# Get package version
VERSION=$(package_version nginx)
echo "nginx version: $VERSION"

# List installed packages matching pattern
installed_packages nginx
```

### 8. Process Management

```bash
# Check if process is running
if process_is_running nginx; then
    echo "nginx is running"
fi

# Get process PID by name
PID=$(process_pid nginx)
echo "nginx PID: $PID"

# Get process memory usage
MEM=$(process_memory nginx)
echo "nginx memory: $MEM"

# Kill process by name
kill_process nginx

# Get process user
PROCESS_USER=$(process_user nginx)
```

### 9. Log Operations

```bash
# Get last N lines from log
tail_log /var/log/syslog 50

# Search pattern in log
grep_log /var/log/nginx/error.log "error"

# Monitor log in real-time
monitor_log /var/log/syslog
```

### 10. Dry-Run Mode

```bash
# Enable dry-run mode
export DRY_RUN=true

# Now all destructive operations show what would happen
service_restart nginx  # Shows: [DRY-RUN] systemctl restart nginx

# Disable dry-run mode
export DRY_RUN=false
```

## Verify

### 1. Library Installation

```bash
# Check library is sourced correctly
source /usr/local/lib/sysadmin/linux-system-commands-library.sh
show_version

# Expected output: linux-system-commands-library.sh version 1.0.0
```

### 2. Function Availability

```bash
# List available functions
type service_start service_stop service_is_active
type ensure_dir backup_file file_diff
type port_is_listening wait_for_port get_primary_ip
type get_cpu_usage get_memory_usage get_disk_usage
```

### 3. Dry-Run Mode

```bash
# Test dry-run mode
DRY_RUN=true service_restart nginx

# Should output: [DRY-RUN] systemctl restart nginx
```

### 4. Binary Checks

```bash
# Test required binary check
require_binary systemctl || echo "systemctl not available"
require_binary ps || echo "ps not available"
```

## Rollback

### 1. Disable Dry-Run Mode

```bash
# For actual changes, ensure DRY_RUN is unset or false
unset DRY_RUN
export DRY_RUN=false
```

### 2. Restore from Backup

```bash
# Restore a file from backup
restore_backup /var/backups/nginx-conf-20240101.tar.gz /etc/nginx/nginx.conf
```

### 3. Service Rollback

```bash
# Restart previous service state
service_restart nginx
# Or manually
systemctl restart nginx
```

## Common Errors

### Error: "Command not found" when sourcing

**Cause:** Library path is incorrect.
```bash
# Verify path
ls -la /usr/local/lib/sysadmin/linux-system-commands-library.sh

# Correct path if needed
source /correct/path/to/linux-system-commands-library.sh
```

### Error: "Permission denied" for service operations

**Cause:** Insufficient privileges.
```bash
# Run with sudo
sudo service_restart nginx

# Or ensure user has sudo access
sudo -l | grep systemctl
```

### Error: "service: command not found"

**Cause:** Systemd not available or service not installed.
```bash
# Check if service command exists
command -v service

# Install sysvinit-utils or use systemctl directly
systemctl status nginx
```

### Error: "port_is_listening: port not in expected format"

**Cause:** Invalid port number passed.
```bash
# Use valid port numbers (1-65535)
port_is_listening 8080   # Correct
port_is_listening 80     # Correct
port_is_listening 0     # Incorrect
```

### Error: "DRY_RUN command not found"

**Cause:** DRY_RUN variable not set correctly.
```bash
# Set properly
export DRY_RUN=true   # For dry-run
unset DRY_RUN        # For actual execution
```

## References

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Systemd Documentation](https://www.freedesktop.org/software/systemd/man/)
- [Linux Man Pages](https://man7.org/linux/man-pages/)