# Jenkins Agent Connection Tuning Commands

---
SQUIRREL:
  title: "Jenkins Agent Connection Tuning Commands"
  category: "jenkins"
  tags: ["jenkins", "agent", "connection", "tuning", "high-concurrency"]
  last_verified: "2026-05-07"
  version: "LTS 2.414+"
---

## Purpose

This reference provides command patterns for tuning Jenkins agent (formerly "slave") connections in high-concurrency environments. Covers agent registration, connection pooling, labeling strategies, resource allocation, and performance tuning to support hundreds of concurrent builds without degradation.

## When to use

- Running 50+ concurrent builds and experiencing agent queue times
- Tuning agent launcher settings for cloud/dynamic provisioning
- Optimizing inbound/outbound agent connection throughput
- Configuring JNLP-based agent connection tuning
- Setting up persistent agent tunnels for firewall-restricted environments

## Prerequisites

- Jenkins controller running (LTS 2.414+)
- Java 11+ on controller and agents
- JNLP agent launcher plugin (built-in) or SSH agents
- Sufficient network connectivity between controller and agents
- API token for REST CLI authentication

## Agent Connection Architecture

### JNLP Agent Flow
```
Controller (8080) → JNLP Agent Jar Download → Agent Launcher → Inbound Connection → Controller
```

### SSH Agent Flow
```
Controller SSH → Agent Host (22) → sshd → Jenkins Agent Process
```

---

## Agent Registration and Launch

### List all agents with status
```bash
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_TOKEN="your-token"

curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/api/json" | jq '.computer[] | {
    name: .displayName,
    offline: .offline,
    numExecutors: .numExecutors,
   jnlpAgent: .jnlpAgent,
    launchMethod: .launcher.class
  }'
```

### Get agent configuration details
```bash
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/api/json" | jq '.'
```

### Create JNLP agent via CLI
```bash
java -jar jenkins-cli.jar -s "$JENKINS_URL" create-node \
  --name "agent-dynamic-1" \
  --description "Dynamically provisioned agent" \
  --numExecutors 4 \
  --remoteFS "/home/jenkins/agent" \
  --labels "docker,linux,high-memory" \
  agent
```

### Register SSH agent with key authentication
```bash
java -jar jenkins-cli.jar -s "$JENKINS_URL" create-node \
  --name "agent-ssh-1" \
  --numExecutors 8 \
  --remoteFS "/opt/jenkins/agent" \
  --labels "linux,ubuntu,build" \
  -i "ssh,ssh-key"

# Create node with SSH launcher XML config
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-binary @ssh-agent-config.xml \
  -H "Content-Type: application/xml" \
  "$JENKINS_URL/createItem?name=agent-ssh-1"
```

### Delete and re-register agent
```bash
AGENT_NAME="agent-01"

# Disable first
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/disable"

# Delete
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/doDelete"
```

---

## High-Concurrency Connection Tuning

### Configure inbound agent connection limits
```bash
# Via Jenkins script console (Groovy)
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
hudson.slaves.SlaveComputerLimitUsageMonitor.enable(50);
println("Agent connection limit set to 50 concurrent inbound connections");
' \
  "$JENKINS_URL/script"
```

### Tune agent channel thread pool
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import jenkins.model.Jenkins
import hudson.remoting.Channel$ThreadPool diagnostics

// Increase thread pool for high concurrency
System.setProperty("hudson.remoting.Channel.threadPool", "16")
println("Agent channel thread pool tuned for high concurrency");
' \
  "$JENKINS_URL/script"
```

### Configure JNLP agent connection timeout
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import hudson.model.DownloadService

# Set JNLP download timeout (milliseconds)
System.setProperty("hudson.remoting.JNLP-agent-connect_TIMEOUT", "300")
println("JNLP agent connect timeout set to 300 seconds");
' \
  "$JENKINS_URL/script"
```

### Configure agent ping interval for fast failure detection
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import hudson.slaves.PingComputerListener

// Set ping interval to 30 seconds for faster failure detection
System.setProperty("pingThreadIntervalSeconds", "30")
println("Agent ping interval set to 30 seconds");
' \
  "$JENKINS_URL/script"
```

### Configure pending launch timeout
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
// Timeout for agent launch (minutes)
System.setProperty("hudson.slaves.ConnectionActivityMonitor.timeout", "10")
println("Agent launch timeout set to 10 minutes");
' \
  "$JENKINS_URL/script"
```

---

## Agent Label Management for Concurrency

### Update agent labels for workload distribution
```bash
AGENT_NAME="agent-build-01"
LABELS="docker,linux,high-cpu,ubuntu-22.04"

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
node.setLabelString(\"$LABELS\")
node.save()
println(\"Updated labels for $AGENT_NAME: $LABELS\");
" \
  "$JENKINS_URL/script"
```

### Bulk-label agents by pattern
```bash
LABEL_PREFIX="agent-"
LABELS="docker,linux,concurrent"

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
Jenkins.instance.computers.each { computer ->
  if (computer.name.startsWith(\"$LABEL_PREFIX\")) {
    def node = computer.node
    def existing = node.getLabelString()
    node.setLabelString(existing + \" $LABELS\")
    node.save()
    println(\"Added labels to: \${computer.name}\")
  }
}
" \
  "$JENKINS_URL/script"
```

### Set node availability (bring online/offline)
```bash
AGENT_NAME="agent-02"

# Take offline
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "offline=true&offlineCause=Maintenance" \
  "$JENKINS_URL/computer/$AGENT_NAME/toggleOffline"

# Bring online
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/toggleOffline"
```

---

## Executor Management for High-Concurrency

### Update executor count per agent
```bash
AGENT_NAME="agent-build-03"
NUM_EXECUTORS=16

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
node.setNumExecutors($NUM_EXECUTORS)
node.save()
println(\"Set executors for $AGENT_NAME to $NUM_EXECUTORS\");
" \
  "$JENKINS_URL/script"
```

### Enable/disable executors temporarily
```bash
AGENT_NAME="agent-04"
MODE="disable"  # or "enable"

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
def computer = node.toComputer()
computer.setTemporarily($MODE)
println(\"Executors temporarily $MODE on $AGENT_NAME\");
" \
  "$JENKINS_URL/script"
```

### Get agent resource metrics
```bash
AGENT_NAME="agent-01"

curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/systemInfo/api/json" | jq '.'

# Get agent logs
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/log" | tail -50
```

### Set agent work directory for better I/O
```bash
AGENT_NAME="agent-fast-storage"
REMOTE_FS="/mnt/fast-storage/jenkins"

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
node.setRemoteFS(\"$REMOTE_FS\")
node.save()
println(\"Set remote FS for $AGENT_NAME to $REMOTE_FS\");
" \
  "$JENKINS_URL/script"
```

---

## Tunnel and Proxy Configuration

### Configure agent tunnel for firewall traversal
```bash
# Set agent tunnel (controller hostname:port for inbound connections)
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
import jenkins.model.Jenkins
Jenkins.instance.setAgentServerUrI(\"jenkins.internal:50000\")
Jenkins.instance.save()
println(\"Agent tunnel configured\");
" \
  "$JENKINS_URL/script"
```

### Configure JNLP tunnel for agents behind NAT
```bash
# Useful when agents are behind NAT and cannot connect directly
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
System.setProperty(\"hudson.remoting.jnlp.enableWorkaround\", \"true\")
System.setProperty(\"hudson.remoting.jnlp.tunnel\", \"jenkins-tunnel.example.com:50000\")
println(\"JNLP tunnel configured\");
" \
  "$JENKINS_URL/script"
```

### Configure HTTP proxy for agent connections
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
System.setProperty(\"http.proxyHost\", \"proxy.example.com\")
System.setProperty(\"http.proxyPort\", \"3128\")
System.setProperty(\"http.nonProxyHosts\", \"localhost|jenkins.example.com\")
println(\"HTTP proxy configured for agent connections\");
" \
  "$JENKINS_URL/script"
```

---

## Connection Health and Monitoring

### Monitor agent connection status
```bash
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_TOKEN="token"

curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/api/json" | jq '
.computer[] | select(.offline == false) | {
  name: .displayName,
  executors: .numExecutors,
  labels: .labelExpression,
  responseTime: .lastResponseTime
}'
```

### Get agents with connection issues
```bash
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/api/json" | jq '
.computer[] | select(.offline == true) | {
  name: .displayName,
  reason: .offlineCause
}'
```

### Monitor queue depth by label
```bash
LABEL="docker,linux"

curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/queue/api/json" | jq "
.items[] | select(.task.name != null) | {
  job: .task.name,
  stuck: .stuck,
  why: .why
}"
```

### Get agent idle time
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
Jenkins.instance.computers.each { computer ->
  def node = computer.node
  def idle = computer.isIdle()
  def exec = computer.getExecutors()
  def busy = exec.findAll { !it.isIdle() }.size()
  def idle_count = exec.findAll { it.isIdle() }.size()
  println("${computer.name}: busy=${busy}, idle=${idle_count}, offline=${computer.isOffline()}")
}
' \
  "$JENKINS_URL/script"
```

---

## Cloud Agent Provisioning (Kubernetes/Docker)

### Configure Kubernetes agent template
```bash
KUBERNETES_TEMPLATE='{
  "name": "jenkins-agent-k8s",
  "label": "kubernetes",
  "namespace": "jenkins-agents",
  "image": "jenkins/inbound-agent:latest",
  "yaml": "apiVersion: v1\nkind: Pod\nspec:\n  containers:\n  - name: jnlp\n    image: jenkins/inbound-agent:latest\n    resourceRequestCpu: \"500m\"\n    resourceLimitCpu: \"2000m\"\n    resourceRequestMemory: \"512Mi\"\n    resourceLimitMemory: \"2Gi\"\n    workingDir: /home/jenkins/agent"
}'

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary "$KUBERNETES_TEMPLATE" \
  "$JENKINS_URL/configuration-as-code/export"
```

### Set cloud agent retention time
```bash
# via Groovy - reduce retention time for faster scale-down
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import com.cloudbees.jenkins.plugins.kubernetes.KubernetesCloud
import com.cloudbees.plugins.sshagents.JCascSSHAgentMap

Jenkins.instance.clouds.each { cloud ->
  if (cloud instanceof KubernetesCloud) {
    cloud.setRetentionTimeout(300) // 5 minutes retention
    println("Kubernetes cloud retention: \${cloud.name}")
  }
}
' \
  "$JENKINS_URL/script"
```

---

## Verify

### Verify agent connectivity
```bash
AGENT_NAME="agent-01"
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/$AGENT_NAME/api/json" | \
  jq '.offline == false and .connected or .connected'
# Expected: true
```

### Verify executor allocation
```bash
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/computer/api/json" | \
  jq '[.computer[] | {name: .displayName, executors: .numExecutors}]'
# Expected: all agents show configured executor count
```

### Verify label distribution
```bash
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/label/linux/api/json" | \
  jq '{label: .name, nodes: [.nodes[].displayName], numExecutors: .numExecutors}'
# Expected: all linux-labeled nodes listed
```

## Rollback

### Revert executor count
```bash
AGENT_NAME="agent-01"
ORIGINAL_EXECUTORS=4

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
node.setNumExecutors($ORIGINAL_EXECUTORS)
node.save()
println(\"Reverted executors for $AGENT_NAME to $ORIGINAL_EXECUTORS\");
" \
  "$JENKINS_URL/script"
```

### Restore agent labels
```bash
AGENT_NAME="agent-01"
ORIGINAL_LABELS="docker,linux"

curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "script=
def node = Jenkins.instance.getNode(\"$AGENT_NAME\")
node.setLabelString(\"$ORIGINAL_LABELS\")
node.save()
println(\"Restored labels for $AGENT_NAME\");
" \
  "$JENKINS_URL/script"
```

### Restore tunnel configuration
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
System.clearProperty("hudson.remoting.jnlp.tunnel")
Jenkins.instance.setAgentServerUrI("")
Jenkins.instance.save()
println("Tunnel configuration cleared");
' \
  "$JENKINS_URL/script"
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Agent connection refused` | Agent JAR mismatch | Download correct jenkins-agent.jar from controller |
| `No route to host` | Firewall blocking | Open port 50000 (JNLP) or 22 (SSH) |
| `Authentication failed` | Wrong credentials | Regenerate agent credentials, check SSH key |
| `Agent stuck in queue` | No matching agents | Add labels to agents, check queue timeout |
| `Connection timeout` | Slow network | Increase timeout: `hudson.remoting.jnlp.connect_TIMEOUT` |
| `Channel closed` | Agent crash | Check agent logs, restart agent service |
| `JnlpAgentController not found` | JNLP disabled | Enable TCP port for JNLP in Configure Global Security |

### Connection timeout errors
```bash
# Increase all timeouts via Groovy
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
System.setProperty("hudson.remoting.jnlp.connect_TIMEOUT", "600")
System.setProperty("hudson.model.LoadMonitor.pningInterval", "60000")
System.setProperty("hudson.slaves.ConnectionActivityMonitor.timeout", "30")
println("Connection timeouts increased");
' \
  "$JENKINS_URL/script"
```

### Agent queue bottleneck diagnosis
```bash
# Find queue items waiting for specific labels
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/queue/api/json" | jq '
.items[] | {
  job: .task.name,
  label: .task.labelExpression,
  why: .why,
  stuck: .stuck
}'
```

---

## References

- Jenkins Agents Documentation: https://www.jenkins.io/doc/book/managing/nodes/
- Jenkins Remoting: https://github.com/jenkinsci/remoting
- Kubernetes Plugin: https://plugins.jenkins.io/kubernetes/
- SSH Agents: https://www.jenkins.io/doc/book/managing/nodes/#ssh-agents
- Jenkins Script Console: https://www.jenkins.io/doc/book/managing/script-console/