#!/usr/bin/env bash
# shellcheck shell=bash
#
# PURPOSE: Tune Jenkins agent connections for high-concurrency workloads
# USAGE: jenkins-agent-connection-tuning.sh [--agent=<name>] [--dry-run] [--output=json] [--verbose]
# REQUIREMENTS: curl, jq, Jenkins REST API access
# SAFETY: Read-heavy. Modifies agent configuration. Supports dry-run.
#
# EXAMPLES:
#   ./jenkins-agent-connection-tuning.sh
#   ./jenkins-agent-connection-tuning.sh --agent=agent-01 --verbose
#   ./jenkins-agent-connection-tuning.sh --output=json
#   ./jenkins-agent-connection-tuning.sh --tune-channels --dry-run

set -euo pipefail
IFS=$'\n\t'

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_USER="${JENKINS_USER:-admin}"
JENKINS_TOKEN="${JENKINS_TOKEN:-}"
AGENT_NAME="${AGENT_NAME:-}"
DRY_RUN=0
OUTPUT="text"
VERBOSE=0
TUNE_CHANNELS=0
TUNE_LABELS=0
TUNE_EXECUTORS=0
TUNE_TUNNEL=0
TUNE_TIMEOUT=0
TUNE_PING=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step() { echo -e "${BLUE}[STEP]${NC} $*" >&2; }
log_verbose() { if [[ "$VERBOSE" == 1 ]]; then echo -e "${CYAN}[DEBUG]${NC} $*" >&2; fi; }

usage() {
    cat <<EOF
PURPOSE: Tune Jenkins agent connections for high-concurrency workloads
USAGE: $0 [--agent=<name>] [--tune-channels] [--tune-labels] [--tune-executors]
         [--tune-tunnel] [--tune-timeout=<sec>] [--tune-ping-interval=<sec>]
         [--dry-run] [--output=json|text] [--verbose] [--help]

OPTIONS:
  --agent=<name>         Target agent name for operations
  --tune-channels       Tune agent channel thread pool
  --tune-labels         Bulk update agent labels for workload distribution
  --tune-executors      Update executor counts for high concurrency
  --tune-tunnel         Configure agent tunnel for firewall traversal
  --tune-timeout=<sec>  Set JNLP agent connection timeout in seconds (default: 300)
  --tune-ping-interval=<sec> Set agent ping interval in seconds (default: 30)
  --dry-run             Show what would be done without making changes
  --output=json         Output results in JSON format
  --output=text         Output results in human-readable text (default)
  --verbose             Enable verbose logging

REQUIREMENTS: curl, jq, JENKINS_URL, JENKINS_USER, JENKINS_TOKEN env vars

EXAMPLES:
  $0 --agent=agent-01 --tune-executors --num-executors=16
  $0 --tune-channels --pool-size=16
  $0 --tune-timeout=600
  $0 --tune-ping-interval=45
  $0 --agent=agent-01 --verbose
  $0 --output=json
EOF
    exit 1
}

check_prerequisites() {
    log_step "Checking prerequisites..."

    if [[ -z "$JENKINS_TOKEN" ]]; then
        log_error "JENKINS_TOKEN not set. Set JENKINS_TOKEN environment variable."
        exit 1
    fi

    for cmd in curl jq; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "Required command '$cmd' not found"
            exit 1
        fi
    done

    log_verbose "Prerequisites check passed"
}

run_groovy() {
    local script="$1"
    local result
    result=$(curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
        --data-urlencode "script=$script" \
        "$JENKINS_URL/script" \
        2>&1) || true
    echo "$result"
}

test_connection() {
    log_step "Testing Jenkins API connection..."
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" \
        -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/api/json" 2>&1) || response="000"

    if [[ "$response" == "200" ]]; then
        log_info "Connected to Jenkins at $JENKINS_URL"
        return 0
    else
        log_error "Failed to connect to Jenkins (HTTP $response)"
        exit 1
    fi
}

list_agents() {
    log_step "Listing all agents..."
    local agents
    agents=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/computer/api/json" 2>&1) || {
        log_error "Failed to fetch agent list"
        return 1
    }

    if [[ "$OUTPUT" == "json" ]]; then
        echo "$agents" | jq 'try .computer[] | {
            name: .displayName,
            offline: .offline,
            numExecutors: .numExecutors,
            labels: [.labels[].name],
            responseTime: .lastResponseTime
        } catch empty'
    else
        echo "$agents" | jq -r 'try .computer[] | "\(.displayName) | offline=\(.offline) | executors=\(.numExecutors) | labels=\([.labels[].name] | join(\",\"))" catch empty'
    fi
}

get_agent_info() {
    local agent="$1"
    log_step "Getting info for agent: $agent"
    local info
    info=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/computer/$agent/api/json" 2>&1) || {
        log_error "Failed to fetch agent info"
        return 1
    }

    if [[ "$OUTPUT" == "json" ]]; then
        echo "$info" | jq '{
            name: .displayName,
            offline: .offline,
            numExecutors: .numExecutors,
            labels: [.labels[].name],
            launchMethod: .launcher.class,
            remoteFS: .remoteFS,
            lastPing: .lastResponseTime
        }'
    else
        echo "$info" | jq -r '"Agent: \(.displayName)  Offline: \(.offline)  Executors: \(.numExecutors)  Labels: \([.labels[].name] | join(\", \"))  Launch: \(.launcher.class)  RemoteFS: \(.remoteFS)  LastPing: \(.lastResponseTime)ms"'
    fi
}

tune_channel_threadpool() {
    local pool_size="${1:-16}"
    log_step "Tuning agent channel thread pool (size=$pool_size)..."

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set channel thread pool to $pool_size"
        return 0
    fi

    local script='
import hudson.remoting.Channel;
System.setProperty("hudson.remoting.Channel.threadPool", "'"$pool_size"'");
println("Agent channel thread pool set to '"$pool_size"'");
'
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Agent channel thread pool tuned to $pool_size"
}

tune_jnlp_timeout() {
    local timeout="${1:-300}"
    log_step "Tuning JNLP agent connect timeout (${timeout}s)..."

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set JNLP connect timeout to ${timeout}s"
        return 0
    fi

    local script='
System.setProperty("hudson.remoting.JNLP-agent-connect_TIMEOUT", "'"$timeout"'");
println("JNLP agent connect timeout set to '"$timeout"' seconds");
'
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "JNLP connect timeout set to ${timeout}s"
}

tune_ping_interval() {
    local interval="${1:-30}"
    log_step "Tuning agent ping interval (${interval}s)..."

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set ping interval to ${interval}s"
        return 0
    fi

    local script='
System.setProperty("pingThreadIntervalSeconds", "'"$interval"'");
println("Agent ping interval set to '"$interval"' seconds");
'
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Agent ping interval tuned to ${interval}s"
}

tune_agent_labels() {
    local agent="$1"
    local labels="$2"
    log_step "Updating labels for agent: $agent → $labels"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set labels for $agent to $labels"
        return 0
    fi

    local script="import jenkins.model.Jenkins
def node = Jenkins.instance.getNode(\"$agent\")
node.setLabelString(\"$labels\")
node.save()
println(\"Updated labels for $agent to $labels\");
"
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Labels updated for $agent: $labels"
}

tune_executor_count() {
    local agent="$1"
    local count="$2"
    log_step "Updating executor count for agent: $agent → $count"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set executors for $agent to $count"
        return 0
    fi

    local script="import jenkins.model.Jenkins
def node = Jenkins.instance.getNode(\"$agent\")
node.setNumExecutors($count)
node.save()
println(\"Set executors for $agent to $count\");
"
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Executor count updated for $agent: $count"
}

bulk_label_agents() {
    local prefix="$1"
    local labels="$2"
    log_step "Bulk updating labels for agents with prefix: $prefix"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would add labels '$labels' to agents starting with '$prefix'"
        return 0
    fi

    local script="Jenkins.instance.computers.each { computer ->
  if (computer.name.startsWith(\"$prefix\")) {
    def node = computer.node
    def existing = node.getLabelString()
    node.setLabelString(existing + \" $labels\")
    node.save()
    println(\"Added labels to: \${computer.name}\")
  }
}
"
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Bulk label update complete"
}

bulk_executor_update() {
    local prefix="$1"
    local count="$2"
    log_step "Bulk updating executor count ($count) for agents with prefix: $prefix"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set executors to $count for agents starting with '$prefix'"
        return 0
    fi

    local script="Jenkins.instance.computers.each { computer ->
  if (computer.name.startsWith(\"$prefix\")) {
    def node = computer.node
    node.setNumExecutors($count)
    node.save()
    println(\"Set executors for \${computer.name} to $count\")
  }
}
"
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Bulk executor update complete"
}

set_agent_tunnel() {
    local tunnel="$1"
    log_step "Configuring agent tunnel: $tunnel"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would set agent tunnel to $tunnel"
        return 0
    fi

    local script="System.setProperty(\"hudson.remoting.jnlp.tunnel\", \"$tunnel\");
println(\"Agent tunnel set to $tunnel\");
"
    local result
    result=$(run_groovy "$script")
    log_verbose "Groovy result: $result"
    log_info "Agent tunnel configured: $tunnel"
}

set_agent_offline() {
    local agent="$1"
    local cause="${2:-Maintenance}"
    log_step "Taking agent offline: $agent"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would take $agent offline"
        return 0
    fi

    curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
        --data-urlencode "offline=true&offlineCause=$cause" \
        "$JENKINS_URL/computer/$agent/toggleOffline" >/dev/null
    log_info "Agent $agent is now offline"
}

set_agent_online() {
    local agent="$1"
    log_step "Bringing agent online: $agent"

    if [[ "$DRY_RUN" == 1 ]]; then
        log_info "[DRY-RUN] Would bring $agent online"
        return 0
    fi

    curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/computer/$agent/toggleOffline" >/dev/null
    log_info "Agent $agent is now online"
}

get_idle_agents() {
    log_step "Getting idle agent summary..."
    local script='Jenkins.instance.computers.each { computer ->
  def exec = computer.getExecutors()
  def busy = exec.findAll { !it.isIdle() }.size()
  def idle = exec.findAll { it.isIdle() }.size()
  println("${computer.name}: busy=${busy}, idle=${idle}, offline=${computer.isOffline()}")
}
'
    local result
    result=$(run_groovy "$script")
    echo "$result"
}

get_queue_depth() {
    log_step "Getting build queue depth..."
    local queue
    queue=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/queue/api/json" 2>&1) || {
        log_error "Failed to fetch queue"
        return 1
    }

    if [[ "$OUTPUT" == "json" ]]; then
        echo "$queue" | jq '{items: [.items[] | {job: .task.name, why: .why, stuck: .stuck}]}'
    else
        local count
        count=$(echo "$queue" | jq '.items | length')
        log_info "Build queue depth: $count items"
        echo "$queue" | jq -r '.items[] | "  \(.task.name) | \(.why)"'
    fi
}

get_agent_logs() {
    local agent="$1"
    local lines="${2:-50}"
    log_step "Fetching last $lines lines of agent logs for: $agent"
    curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
        "$JENKINS_URL/computer/$agent/log" | tail -"$lines"
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h) usage ;;
            --agent=*) AGENT_NAME="${1#*=}" ;;
            --tune-channels) TUNE_CHANNELS=1 ;;
            --tune-labels) TUNE_LABELS=1 ;;
            --tune-executors) TUNE_EXECUTORS=1 ;;
            --tune-tunnel) TUNE_TUNNEL=1 ;;
            --tune-timeout=*) TUNE_TIMEOUT=1; TIMEOUT="${1#*=}" ;;
            --tune-ping-interval=*) TUNE_PING=1; PING_INTERVAL="${1#*=}" ;;
            --dry-run) DRY_RUN=1 ;;
            --output=json|--output=text) OUTPUT="${1#*=}" ;;
            --verbose) VERBOSE=1 ;;
            --pool-size=*) POOL_SIZE="${1#*=}" ;;
            --num-executors=*) NUM_EXECUTORS="${1#*=}" ;;
            --tunnel-host=*) TUNNEL_HOST="${1#*=}" ;;
            --labels=*) AGENT_LABELS="${1#*=}" ;;
            --prefix=*) AGENT_PREFIX="${1#*=}" ;;
            --cause=*) OFFLINE_CAUSE="${1#*=}" ;;
            --list) CMD_LIST=1 ;;
            --info) CMD_INFO=1 ;;
            --idle) CMD_IDLE=1 ;;
            --queue) CMD_QUEUE=1 ;;
            --logs) CMD_LOGS=1 ;;
            --offline) CMD_OFFLINE=1 ;;
            --online) CMD_ONLINE=1 ;;
            --bulk-labels) CMD_BULK_LABELS=1 ;;
            --bulk-executors) CMD_BULK_EXECUTORS=1 ;;
            *) log_error "Unknown option: $1"; usage ;;
        esac
        shift
    done

    check_prerequisites
    test_connection

    if [[ "${CMD_LIST:-0}" == 1 ]]; then
        list_agents
        exit 0
    fi

    if [[ "${CMD_INFO:-0}" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --info"
            exit 1
        fi
        get_agent_info "$AGENT_NAME"
        exit 0
    fi

    if [[ "${CMD_IDLE:-0}" == 1 ]]; then
        get_idle_agents
        exit 0
    fi

    if [[ "${CMD_QUEUE:-0}" == 1 ]]; then
        get_queue_depth
        exit 0
    fi

    if [[ "${CMD_LOGS:-0}" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --logs"
            exit 1
        fi
        get_agent_logs "$AGENT_NAME"
        exit 0
    fi

    if [[ "${CMD_OFFLINE:-0}" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --offline"
            exit 1
        fi
        set_agent_offline "$AGENT_NAME" "${OFFLINE_CAUSE:-Maintenance}"
        exit 0
    fi

    if [[ "${CMD_ONLINE:-0}" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --online"
            exit 1
        fi
        set_agent_online "$AGENT_NAME"
        exit 0
    fi

    if [[ "$TUNE_CHANNELS" == 1 ]]; then
        tune_channel_threadpool "${POOL_SIZE:-16}"
    fi

    if [[ "$TUNE_TIMEOUT" == 1 ]]; then
        tune_jnlp_timeout "${TIMEOUT:-300}"
    fi

    if [[ "$TUNE_PING" == 1 ]]; then
        tune_ping_interval "${PING_INTERVAL:-30}"
    fi

    if [[ "$TUNE_TUNNEL" == 1 ]]; then
        if [[ -z "${TUNNEL_HOST:-}" ]]; then
            log_error "--tunnel-host required for --tune-tunnel"
            exit 1
        fi
        set_agent_tunnel "$TUNNEL_HOST"
    fi

    if [[ "$TUNE_EXECUTORS" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --tune-executors"
            exit 1
        fi
        if [[ -z "${NUM_EXECUTORS:-}" ]]; then
            log_error "--num-executors required for --tune-executors"
            exit 1
        fi
        tune_executor_count "$AGENT_NAME" "$NUM_EXECUTORS"
    fi

    if [[ "$TUNE_LABELS" == 1 ]]; then
        if [[ -z "$AGENT_NAME" ]]; then
            log_error "--agent required for --tune-labels"
            exit 1
        fi
        if [[ -z "${AGENT_LABELS:-}" ]]; then
            log_error "--labels required for --tune-labels"
            exit 1
        fi
        tune_agent_labels "$AGENT_NAME" "$AGENT_LABELS"
    fi

    if [[ "${CMD_BULK_LABELS:-0}" == 1 ]]; then
        if [[ -z "${AGENT_PREFIX:-}" ]]; then
            log_error "--prefix required for --bulk-labels"
            exit 1
        fi
        if [[ -z "${AGENT_LABELS:-}" ]]; then
            log_error "--labels required for --bulk-labels"
            exit 1
        fi
        bulk_label_agents "$AGENT_PREFIX" "$AGENT_LABELS"
    fi

    if [[ "${CMD_BULK_EXECUTORS:-0}" == 1 ]]; then
        if [[ -z "${AGENT_PREFIX:-}" ]]; then
            log_error "--prefix required for --bulk-executors"
            exit 1
        fi
        if [[ -z "${NUM_EXECUTORS:-}" ]]; then
            log_error "--num-executors required for --bulk-executors"
            exit 1
        fi
        bulk_executor_update "$AGENT_PREFIX" "$NUM_EXECUTORS"
    fi

    if [[ "$TUNE_CHANNELS" == 0 && "$TUNE_TUNNEL" == 0 && "$TUNE_EXECUTORS" == 0 && "$TUNE_LABELS" == 0 && "${CMD_BULK_LABELS:-0}" == 0 && "${CMD_BULK_EXECUTORS:-0}" == 0 ]]; then
        log_info "No tuning action specified. Use --tune-channels, --tune-tunnel, --tune-executors, --tune-labels, --bulk-labels, --bulk-executors, or --list/--info/--idle/--queue"
        echo ""
        list_agents
    fi

    log_info "Agent connection tuning complete"
}

main "$@"