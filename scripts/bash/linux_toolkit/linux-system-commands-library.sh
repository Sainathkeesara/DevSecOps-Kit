#!/usr/bin/env bash
# Linux System Command Patterns for Automated System Administration
# Level: L7 | Category: Linux | Purpose: Shell command patterns for automated system administration
# Features: Idempotent, dry-run support, multi-distribution, binary checks

set -euo pipefail

# Library configuration
LIB_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()   { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()  { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug()  { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

run() {
    local cmd="$*"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $cmd"
    else
        log_debug "Executing: $cmd"
        eval "$cmd"
    fi
}

show_version() {
    echo "linux-system-commands-library.sh version $LIB_VERSION"
}

require_binary() {
    local bin="$1"
    if ! command -v "$bin" &>/dev/null; then
        log_error "Required binary not found: $bin"
        return 1
    fi
    return 0
}

service_is_active() {
    local service="$1"
    require_binary systemctl || return 1
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

service_start() {
    local service="$1"
    require_binary systemctl || return 1
    log_info "Starting service: $service"
    run "systemctl start $service"
}

service_stop() {
    local service="$1"
    require_binary systemctl || return 1
    log_info "Stopping service: $service"
    run "systemctl stop $service"
}

service_restart() {
    local service="$1"
    require_binary systemctl || return 1
    log_info "Restarting service: $service"
    run "systemctl restart $service"
}

service_enable() {
    local service="$1"
    require_binary systemctl || return 1
    log_info "Enabling service: $service"
    run "systemctl enable $service"
}

service_disable() {
    local service="$1"
    require_binary systemctl || return 1
    log_info "Disabling service: $service"
    run "systemctl disable $service"
}

service_status() {
    local service="$1"
    require_binary systemctl || return 1
    run "systemctl status $service" || true
}

ensure_dir() {
    local path="$1"
    local perms="${2:-0755}"
    local owner="${3:-root:root}"
    
    if [[ -d "$path" ]]; then
        log_debug "Directory exists: $path"
    else
        log_info "Creating directory: $path"
        run "mkdir -p $path"
    fi
    run "chmod $perms $path"
    if [[ "$owner" != ":" ]]; then
        run "chown $owner $path"
    fi
}

backup_file() {
    local file="$1"
    local backup_dir="${2:-/var/backups}"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    
    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi
    
    local filename
    filename=$(basename "$file")
    local backup_path="$backup_dir/${filename}.${timestamp}.bak"
    
    log_info "Backing up $file to $backup_path"
    run "cp -p $file $backup_path"
    run "chmod 600 $backup_path"
}

file_diff() {
    local file1="$1"
    local file2="$2"
    
    if [[ ! -f "$file1" ]]; then
        log_error "File not found: $file1"
        return 1
    fi
    if [[ ! -f "$file2" ]]; then
        log_error "File not found: $file2"
        return 1
    fi
    
    if diff -q "$file1" "$file2" &>/dev/null; then
        log_info "Files are identical"
        return 0
    else
        log_info "Files differ:"
        run "diff -u $file1 $file2"
        return 1
    fi
}

file_is_writable() {
    local path="$1"
    if [[ -w "$path" ]]; then
        return 0
    else
        return 1
    fi
}

file_age_days() {
    local file="$1"
    if [[ ! -e "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi
    local age
    age=$(find "$file" -maxdepth 0 -printf '%@' 2>/dev/null | cut -d. -f1)
    local now
    now=$(date +%s)
    local days=$(( (now - age) / 86400 ))
    echo "$days"
}

port_is_listening() {
    local port="$1"
    if require_binary ss; then
        if ss -tuln 2>/dev/null | grep -q ":$port "; then
            return 0
        fi
    elif require_binary netstat; then
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            return 0
        fi
    fi
    return 1
}

wait_for_port() {
    local host="$1"
    local port="$2"
    local timeout="${3:-60}"
    local interval="${4:-2}"
    
    log_info "Waiting for $host:$port (timeout: ${timeout}s)"
    
    local elapsed=0
    while [[ $elapsed -lt $timeout ]]; do
        if timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            log_info "Port $port is ready"
            return 0
        fi
        sleep "$interval"
        elapsed=$((elapsed + interval))
    done
    
    log_error "Timeout waiting for $host:$port"
    return 1
}

check_connectivity() {
    local host="$1"
    local port="${2:-443}"
    
    if timeout 5 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

get_primary_ip() {
    local ip
    if command -v ip &>/dev/null; then
        ip=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K[\d.]+' | head -1)
    elif command -v hostname &>/dev/null; then
        ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    fi
    echo "${ip:-127.0.0.1}"
}

is_reachable() {
    local host="$1"
    if ping -c 1 -W 2 "$host" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

get_cpu_usage() {
    local usage
    usage=$(top -bn1 2>/dev/null | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "${usage:-0}"
}

get_memory_usage() {
    local total used available percent
    if [[ -f /proc/meminfo ]]; then
        total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        if [[ -z "$available" ]]; then
            available=$(grep MemFree /proc/meminfo | awk '{print $2}')
        fi
        used=$((total - available))
        percent=$((used * 100 / total))
        echo "$percent"
    elif require_binary free; then
        free | grep Mem | awk '{print ($3/$2) * 100.0}'
    else
        echo "0"
    fi
}

get_disk_usage() {
    local path="${1:-.}"
    df -P "$path" 2>/dev/null | awk 'NR==1 {print $5}' | sed 's/%//'
}

get_load_average() {
    if [[ -f /proc/loadavg ]]; then
        awk '{print $1, $2, $3}' /proc/loadavg
    elif command -v uptime; then
        uptime | awk -F'load average:' '{print $2}'
    else
        echo "0.00 0.00 0.00"
    fi
}

get_uptime() {
    if [[ -f /proc/uptime ]]; then
        local uptime_sec
        uptime_sec=$(awk '{print int($1)}' /proc/uptime)
        local days hours minutes
        days=$((uptime_sec / 86400))
        hours=$(( (uptime_sec % 86400) / 3600 ))
        minutes=$(( (uptime_sec % 3600) / 60 ))
        echo "${days}d ${hours}h ${minutes}m"
    elif command -v uptime; then
        uptime | awk -F'up' '{print $2}' | awk -F',' '{print $1}'
    else
        echo "unknown"
    fi
}

get_process_count() {
    if [[ -d /proc ]]; then
        ls /proc/ | grep -cE '^[0-9]+$'
    elif require_binary ps; then
        ps -eo pid  | wc -l
    else
        echo "0"
    fi
}

user_exists() {
    local user="$1"
    if id "$user" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

group_exists() {
    local group="$1"
    if getent group "$group" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

get_user_info() {
    local user="$1"
    if id "$user" &>/dev/null; then
        id "$user"
    else
        log_error "User not found: $user"
        return 1
    fi
}

user_shell() {
    local user="$1"
    if getent passwd "$user" &>/dev/null; then
        getent passwd "$user" | cut -d: -f7
    else
        echo "/sbin/nologin"
    fi
}

package_is_installed() {
    local package="$1"
    if command -v dpkg &>/dev/null; then
        dpkg -l "$package" 2>/dev/null | grep -q "^ii"
    elif command -v rpm &>/dev/null; then
        rpm -q "$package" &>/dev/null
    elif command -v pacman &>/dev/null; then
        pacman -Q "$package" &>/dev/null
    else
        return 1
    fi
}

package_version() {
    local package="$1"
    if command -v dpkg &>/dev/null; then
        dpkg -l "$package" 2>/dev/null | awk '/^ii/{print $3}'
    elif command -v rpm &>/dev/null; then
        rpm -q --qf '%{VERSION}-%{RELEASE}' "$package" 2>/dev/null
    elif command -v pacman &>/dev/null; then
        pacman -Q "$package" 2>/dev/null | awk '{print $2}'
    else
        echo "unknown"
    fi
}

installed_packages() {
    local pattern="${1:-}"
    if command -v dpkg &>/dev/null; then
        dpkg -l 2>/dev/null | grep "^ii" | awk '{print $2}' | grep "$pattern"
    elif command -v rpm &>/dev/null; then
        rpm -qa 2>/dev/null | grep "$pattern"
    elif command -v pacman &>/dev/null; then
        pacman -Qq 2>/dev/null | grep "$pattern"
    fi
}

process_is_running() {
    local name="$1"
    if pgrep -x "$name" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

process_pid() {
    local name="$1"
    pgrep -x "$name" 2>/dev/null | head -1
}

process_memory() {
    local name="$1"
    if command -v ps &>/dev/null; then
        ps -eo pid,rss= --no-headers 2>/dev/null | grep -E "^$(pgrep -x "$name" 2>/dev/null | head -1)" | awk '{print $2}'
    else
        echo "0"
    fi
}

kill_process() {
    local name="$1"
    log_info "Killing process: $name"
    run "pkill -x $name"
}

process_user() {
    local name="$1"
    if command -v ps &>/dev/null; then
        ps -eo user= --no-headers 2>/dev/null | grep -E "^$(pgrep -x "$name" 2>/dev/null | head -1)" | head -1
    else
        echo "root"
    fi
}

tail_log() {
    local logfile="$1"
    local lines="${2:-50}"
    
    if [[ ! -f "$logfile" ]]; then
        log_error "Log file not found: $logfile"
        return 1
    fi
    run "tail -n $lines $logfile"
}

grep_log() {
    local logfile="$1"
    local pattern="$2"
    
    if [[ ! -f "$logfile" ]]; then
        log_error "Log file not found: $logfile"
        return 1
    fi
    run "grep -E '$pattern' $logfile"
}

monitor_log() {
    local logfile="$1"
    
    if [[ ! -f "$logfile" ]]; then
        log_error "Log file not found: $logfile"
        return 1
    fi
    run "tail -f $logfile"
}

show_help() {
    cat << HELP
Linux System Commands Library v$LIB_VERSION

Usage: source /usr/local/lib/sysadmin/linux-system-commands-library.sh

Service Management:
    service_is_active <service>   Check if service is running
    service_start <service>      Start a service
    service_stop <service>       Stop a service
    service_restart <service>   Restart a service
    service_enable <service>    Enable service on boot
    service_disable <service>   Disable service on boot
    service_status <service>    Show service status

File Operations:
    ensure_dir <path> [perms] [owner]  Create directory with permissions
    backup_file <file> [dir]       Backup a file
    file_diff <file1> <file2>     Compare two files
    file_is_writable <path>       Check if path is writable
    file_age_days <file>          Get file age in days

Network Operations:
    port_is_listening <port>      Check if port is listening
    wait_for_port <host> <port> [timeout] [interval]  Wait for port
    check_connectivity <host> [port]  Test connectivity
    get_primary_ip              Get primary IP address
    is_reachable <host>         Check if host is reachable

System Monitoring:
    get_cpu_usage               Get CPU usage percentage
    get_memory_usage            Get memory usage percentage
    get_disk_usage [path]      Get disk usage percentage
    get_load_average           Get system load average
    get_uptime                Get system uptime
    get_process_count          Get number of processes

User Operations:
    user_exists <user>          Check if user exists
    group_exists <group>        Check if group exists
    get_user_info <user>        Get user information
    user_shell <user>          Get user's default shell

Package Operations:
    package_is_installed <pkg>  Check if package is installed
    package_version <pkg>       Get package version
    installed_packages [pattern]  List installed packages

Process Operations:
    process_is_running <name>   Check if process is running
    process_pid <name>         Get process PID
    process_memory <name>      Get process memory usage
    kill_process <name>       Kill process by name
    process_user <name>       Get process owner

Log Operations:
    tail_log <file> [lines]    Get last N lines from log
    grep_log <file> <pattern>  Search pattern in log
    monitor_log <file>        Monitor log in real-time

Configuration:
    DRY_RUN=true                Enable dry-run mode
    VERBOSE=true               Enable verbose output

Examples:
    source /usr/local/lib/sysadmin/linux-system-commands-library.sh
    service_start nginx
    get_cpu_usage
    DRY_RUN=true service_restart nginx

HELP
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    log_info "Linux System Commands Library loaded (v$LIB_VERSION)"
fi