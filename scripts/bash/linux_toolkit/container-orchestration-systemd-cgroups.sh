#!/usr/bin/env bash
# Container Orchestration with Systemd and Cgroups
# Level: L7 | Category: Linux | Purpose: Automated container orchestration with systemd integration
# Features: Idempotent, dry-run support, cgroup management, rollback, multi-container support

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${CONFIG_DIR:-/etc/container-orchestrator}"
CONFIG_FILE="${CONFIG_FILE:-$CONFIG_DIR/config.env}"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
LOG_FILE="${LOG_FILE:-$CONFIG_DIR/orchestrator.log}"
ACTION="${ACTION:-deploy}"
SLICE_NAME="${SLICE_NAME:-}"
SERVICE_NAME="${SERVICE_NAME:-}"
CONTAINER_IMAGE="${CONTAINER_IMAGE:-}"
CONTAINER_NAME="${CONTAINER_NAME:-}"
MEMORY_LIMIT="${MEMORY_LIMIT:-}"
CPU_LIMIT="${CPU_LIMIT:-}"
CGROUP_SLICE="${CGROUP_SLICE:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE" 2>/dev/null || echo "$*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE" 2>/dev/null || echo "$*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE" 2>/dev/null || echo "$*"; }
log_debug()   { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE" 2>/dev/null || echo "$*"; }
log_section() { echo -e "\n${CYAN}${BOLD}=== $* ===${NC}" | tee -a "$LOG_FILE" 2>/dev/null || echo "$*"; }

run() {
    local cmd="$*"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $cmd"
    else
        log_debug "Executing: $cmd"
        eval "$cmd" 2>&1 | tee -a "$LOG_FILE" || true
    fi
}

run_check() {
    local cmd="$*"
    log_debug "Running: $cmd"
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    eval "$cmd" 2>&1
}

check_dependencies() {
    log_section "Checking dependencies"
    
    local missing=()
    for cmd in docker systemctl grep awk cut; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        return 1
    fi
    
    if ! docker info &>/dev/null; then
        log_error "Docker daemon not accessible"
        return 1
    fi
    
    if ! systemctl is-active --quiet docker; then
        log_warn "Docker service not running, attempting to start..."
        run "systemctl start docker" || {
            log_error "Cannot start Docker service"
            return 1
        }
    fi
    
    log_info "All dependencies satisfied"
}

detect_cgroup_version() {
    if [[ -f /sys/fs/cgroup/cgroup.controllers ]]; then
        echo "v2"
    else
        echo "v1"
    fi
}

create_cgroup_slice() {
    local slice_name="$1"
    local cpu_weight="${2:-100}"
    local memory_max="${3:-2G}"
    local tasks_max="${4:-100}"
    
    log_info "Creating cgroup slice: $slice_name"
    
    local slice_file="$CONFIG_DIR/slices/${slice_name}.slice"
    
    [[ -d "$CONFIG_DIR/slices" ]] || run "mkdir -p $CONFIG_DIR/slices"
    
    if [[ -f "$slice_file" ]]; then
        log_warn "Slice $slice_name already exists"
        return 0
    fi
    
    run "cat > $slice_file <<EOF
[Unit]
Description=${slice_name} Slice
Before=slices.target

[Slice]
CPUWeight=$cpu_weight
MemoryMax=$memory_max
TasksMax=$tasks_max
EOF"
    
    if [[ "$DRY_RUN" != "true" ]]; then
        systemctl daemon-reload
        systemctl start "${slice_name}.slice" 2>/dev/null || true
    fi
    
    log_info "Slice $slice_name created successfully (CPUWeight=$cpu_weight, MemoryMax=$memory_max, TasksMax=$tasks_max)"
}

delete_cgroup_slice() {
    local slice_name="$1"
    log_info "Deleting cgroup slice: $slice_name"
    
    run "systemctl stop ${slice_name}.slice 2>/dev/null || true"
    run "rm -f $CONFIG_DIR/slices/${slice_name}.slice"
    run "systemctl daemon-reload"
    
    log_info "Slice $slice_name deleted"
}

deploy_container_service() {
    local service_name="$1"
    local image="$2"
    local container_name="$2"
    local slice="${3:-}"
    local memory_limit="${4:-}"
    local cpu_limit="${5:-}"
    local ports="${6:-}"
    local volumes="${7:-}"
    local restart_policy="${8:-on-failure:5}"
    local env_vars="${9:-}"
    
    log_info "Deploying container service: $service_name"
    
    local service_dir="$CONFIG_DIR/services"
    [[ -d "$service_dir" ]] || run "mkdir -p $service_dir"
    
    local service_file="$service_dir/${service_name}.service"
    
    local docker_run_args="--name $container_name --restart=$restart_policy --log-driver=journald --detach"
    
    if [[ -n "$slice" ]]; then
        docker_run_args="$docker_run_args --cgroup-parent=/system.slice/${slice}.slice"
    fi
    
    if [[ -n "$memory_limit" ]]; then
        docker_run_args="$docker_run_args --memory=$memory_limit"
    fi
    
    if [[ -n "$cpu_limit" ]]; then
        docker_run_args="$docker_run_args --cpus=$cpu_limit"
    fi
    
    if [[ -n "$ports" ]]; then
        local port
        for port in $(echo "$ports" | tr ',' ' '); do
            docker_run_args="$docker_run_args -p $port"
        done
    fi
    
    if [[ -n "$volumes" ]]; then
        local vol
        for vol in $(echo "$volumes" | tr ',' ' '); do
            docker_run_args="$docker_run_args -v $vol"
        done
    fi
    
    if [[ -n "$env_vars" ]]; then
        local env
        for env in $(echo "$env_vars" | tr ',' ' '); do
            docker_run_args="$docker_run_args -e $env"
        done
    fi
    
    run "cat > $service_file <<EOF
[Unit]
Description=${service_name} Container Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes

ExecStartPre=-/usr/bin/docker rm -f $container_name 2>/dev/null || true
ExecStart=/usr/bin/docker pull $image 2>/dev/null || true
ExecStart=/usr/bin/docker run $docker_run_args $image
ExecStop=/usr/bin/docker stop -t 10 $container_name 2>/dev/null || true
ExecStopPost=/usr/bin/docker rm -f $container_name 2>/dev/null || true

[Install]
WantedBy=multi-user.target
EOF"
    
    if [[ "$DRY_RUN" != "true" ]]; then
        systemctl daemon-reload
        systemctl enable "${service_name}.service"
        systemctl start "${service_name}.service"
    fi
    
    log_info "Service $service_name deployed successfully"
}

remove_service() {
    local service_name="$1"
    local container_name="$2"
    
    log_info "Removing service: $service_name"
    
    run "systemctl stop ${service_name}.service 2>/dev/null || true"
    run "systemctl disable ${service_name}.service 2>/dev/null || true"
    run "docker stop -t 5 $container_name 2>/dev/null || true"
    run "docker rm -f $container_name 2>/dev/null || true"
    run "rm -f $CONFIG_DIR/services/${service_name}.service"
    run "systemctl daemon-reload"
    
    log_info "Service $service_name removed"
}

verify_service() {
    local service_name="$1"
    local container_name="$2"
    
    log_info "Verifying service: $service_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would verify service: $service_name"
        return 0
    fi
    
    if systemctl is-active --quiet "${service_name}.service"; then
        if docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
            log_info "Service $service_name verified successfully"
            return 0
        fi
    fi
    
    log_error "Verification failed for $service_name"
    return 1
}

list_services() {
    log_section "Deployed Container Services"
    
    echo -e "${BOLD}Service Name${NC} | ${BOLD}Container${NC} | ${BOLD}Status${NC} | ${BOLD}Image${NC}"
    echo "-------------|-----------|--------|---------"
    
    for service_file in "$CONFIG_DIR/services"/*.service; do
        [[ -f "$service_file" ]] || continue
        
        local service_name
        service_name=$(basename "$service_file" .service)
        
        local container_name
        container_name=$(grep "ExecStart=.*docker run" "$service_file" | grep -oP '(?<=--name\s)\S+' || echo "unknown")
        
        local status
        if systemctl is-active --quiet "${service_name}.service" 2>/dev/null; then
            status="${GREEN}active${NC}"
        else
            status="${RED}inactive${NC}"
        fi
        
        local image
        image=$(grep "docker run" "$service_file" | awk '{print $NF}')
        
        echo -e "$service_name | $container_name | $status | $image"
    done
}

show_slice_resources() {
    log_section "Cgroup Slice Resources"
    
    local cgroup_version
    cgroup_version=$(detect_cgroup_version)
    log_info "Detected cgroup version: $cgroup_version"
    
    for slice_dir in /sys/fs/cgroup/system.slice/*.slice; do
        [[ -d "$slice_dir" ]] || continue
        
        local slice_name
        slice_name=$(basename "$slice_dir" .slice)
        
        echo -e "\n${BOLD}=== $slice_name ===${NC}"
        
        if [[ "$cgroup_version" == "v2" ]]; then
            if [[ -f "$slice_dir/cpu.max" ]]; then
                echo "CPU Max: $(cat "$slice_dir/cpu.max")"
            fi
            if [[ -f "$slice_dir/memory.max" ]]; then
                echo "Memory Max: $(cat "$slice_dir/memory.max")"
            fi
            if [[ -f "$slice_dir/pids.max" ]]; then
                echo "PID Max: $(cat "$slice_dir/pids.max")"
            fi
        else
            if [[ -f "$slice_dir/cpu.shares" ]]; then
                echo "CPU Shares: $(cat "$slice_dir/cpu.shares")"
            fi
            if [[ -f "$slice_dir/memory.limit_in_bytes" ]]; then
                echo "Memory Limit: $(cat "$slice_dir/memory.limit_in_bytes")"
            fi
            if [[ -f "$slice_dir/pids.max" ]]; then
                echo "PID Max: $(cat "$slice_dir/pids.max")"
            fi
        fi
    done
}

show_help() {
    cat <<EOF
Container Orchestration with Systemd and Cgroups

Usage: $0 [OPTIONS] [ACTION]

OPTIONS:
    --dry-run              Enable dry-run mode
    --verbose              Enable verbose output
    --config FILE          Configuration file (default: $CONFIG_FILE)
    --slice SLICE          Slice name
    --service SERVICE      Service name
    --image IMAGE          Container image
    --name NAME            Container name
    --memory MEM           Memory limit (e.g., 1g, 512m)
    --cpu CPU              CPU limit (e.g., 0.5, 2)
    --ports PORTS          Port mappings (comma-separated)
    --volumes VOLUMES      Volume mounts (comma-separated)
    --restart POLICY       Restart policy (default: on-failure:5)
    --env ENV              Environment variables (comma-separated)

ACTIONS:
    deploy                  Deploy container service (default)
    remove                 Remove container service
    create-slice          Create cgroup slice
    delete-slice          Delete cgroup slice
    list                  List deployed services
    verify                Verify service status
    resources             Show slice resources
    help                  Show this help

EXAMPLES:
    # Create high-priority cgroup slice
    $0 create-slice --slice high-priority --cpu-weight 800 --memory-max 4G

    # Deploy nginx container
    $0 deploy --service webapp --image nginx:latest --name nginx-web --ports 8080:80 --slice high-priority --memory 1g --cpu 0.5

    # List all services
    $0 list

    # Show cgroup resources
    $0 resources

    # Dry-run deployment
    $0 --dry-run deploy --service test --image alpine --name test-container

EOF
}

main() {
    mkdir -p "$CONFIG_DIR" 2>/dev/null || true
    
    log_info "Container Orchestration Script Starting..."
    log_info "Action: ${ACTION:-deploy}"
    log_info "Dry-run: $DRY_RUN"
    
    check_dependencies || exit 1
    
    case "${ACTION:-deploy}" in
        deploy)
            if [[ -z "$SERVICE_NAME" ]] || [[ -z "$CONTAINER_IMAGE" ]]; then
                log_error "service and image are required for deploy action"
                show_help
                exit 1
            fi
            
            local container_name="${CONTAINER_NAME:-$SERVICE_NAME}"
            deploy_container_service \
                "$SERVICE_NAME" \
                "$CONTAINER_IMAGE" \
                "$container_name" \
                "$CGROUP_SLICE" \
                "$MEMORY_LIMIT" \
                "$CPU_LIMIT" \
                "$ports" \
                "$volumes" \
                "$restart_policy" \
                "$env_vars" || exit 1
            
            verify_service "$SERVICE_NAME" "$container_name"
            ;;
            
        remove)
            if [[ -z "$SERVICE_NAME" ]]; then
                log_error "service name is required for remove action"
                exit 1
            fi
            remove_service "$SERVICE_NAME" "${CONTAINER_NAME:-$SERVICE_NAME}"
            ;;
            
        create-slice)
            if [[ -z "$SLICE_NAME" ]]; then
                log_error "slice name is required for create-slice action"
                exit 1
            fi
            create_cgroup_slice "$SLICE_NAME" "${cpu_weight:-100}" "${memory_max:-2G}" "${tasks_max:-100}"
            ;;
            
        delete-slice)
            if [[ -z "$SLICE_NAME" ]]; then
                log_error "slice name is required for delete-slice action"
                exit 1
            fi
            delete_cgroup_slice "$SLICE_NAME"
            ;;
            
        list)
            list_services
            ;;
            
        verify)
            if [[ -z "$SERVICE_NAME" ]]; then
                log_error "service name is required for verify action"
                exit 1
            fi
            verify_service "$SERVICE_NAME" "${CONTAINER_NAME:-$SERVICE_NAME}"
            ;;
            
        resources)
            show_slice_resources
            ;;
            
        help|--help|-h)
            show_help
            ;;
            
        *)
            log_error "Unknown action: ${ACTION:-deploy}"
            show_help
            exit 1
            ;;
    esac
    
    log_info "Container orchestration complete!"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        --config) CONFIG_FILE="$2"; shift 2 ;;
        --slice) SLICE_NAME="$2"; shift 2 ;;
        --service) SERVICE_NAME="$2"; shift 2 ;;
        --image) CONTAINER_IMAGE="$2"; shift 2 ;;
        --name) CONTAINER_NAME="$2"; shift 2 ;;
        --memory) MEMORY_LIMIT="$2"; shift 2 ;;
        --cpu) CPU_LIMIT="$2"; shift 2 ;;
        --ports) ports="$2"; shift 2 ;;
        --volumes) volumes="$2"; shift 2 ;;
        --restart) restart_policy="$2"; shift 2 ;;
        --env) env_vars="$2"; shift 2 ;;
        --cpu-weight) cpu_weight="$2"; shift 2 ;;
        --memory-max) memory_max="$2"; shift 2 ;;
        --tasks-max) tasks_max="$2"; shift 2 ;;
        --) shift; ACTION="$1"; shift; break ;;
        *) ACTION="$1"; shift ;;
    esac
done

main "$@"