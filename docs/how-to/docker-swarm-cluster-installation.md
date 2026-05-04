# Docker Swarm Cluster Installation and High-Availability Configuration

## Purpose

This guide provides comprehensive instructions for setting up a production-ready Docker Swarm cluster with high-availability configurations. It covers initial cluster setup, manager node redundancy, worker node integration, overlay networking, service deployment strategies, and monitoring for a resilient container orchestration platform.

## When to use

- Deploying containerized applications requiring high availability
- Setting up a multi-node Docker cluster for production workloads
- Implementing zero-downtime deployments with rolling updates
- Establishing secure overlay networking between containers
- Building disaster recovery capabilities with multiple manager nodes
- Migrating from standalone Docker hosts to orchestrated container management

## Prerequisites

- Minimum 3 Linux servers for production HA (1 manager, 2 workers recommended)
- Ubuntu 22.04 LTS or CentOS 8/9 on all nodes
- SSH access with root or sudo privileges
- Ports 2377 (cluster management), 7946 (communication), 4789 (overlay) open
- 2+ vCPUs, 4GB RAM per node minimum
- Unique hostnames for each node
- Static IP addresses for all nodes
- Docker Engine 20.10+ or Docker Desktop 20.10+

## Steps

### 1. Initial Server Configuration

#### 1.1 Configure Hosts File

Update `/etc/hosts` on all nodes:

```bash
# On each node, add entries for all swarm nodes
cat >> /etc/hosts <<EOF
192.168.1.10    swarm-manager-1
192.168.1.11    swarm-manager-2
192.168.1.12    swarm-manager-3
192.168.1.20    swarm-worker-1
192.168.1.21    swarm-worker-2
EOF
```

#### 1.2 Install Docker on All Nodes

**On each node**, install Docker Engine:

```bash
# Ubuntu/Debian
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

```bash
# CentOS/RHEL
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
```

#### 1.3 Configure Docker Daemon for Swarm

**On each node**, create Docker daemon configuration:

```bash
cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "exec-opts": ["native.cgroupdriver=systemd"],
  "iptables": false,
  "ip-masq": true,
  "userland-proxy": true,
  "swarm-default-advertise-addr": "eth0"
}
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
```

### 2. Initialize Docker Swarm

#### 2.1 Initialize First Manager Node

**On the first manager node (swarm-manager-1)**:

```bash
# Initialize swarm with specific advertise address
docker swarm init --advertise-addr 192.168.1.10

# Note the join token output - you'll need it for other nodes
# Example output:
# Swarm initialized: current node (<node-id>) is now a manager.
#
# To add a worker to this swarm, run the following command:
#
#   docker swarm join --token SWMTKN-1-xxxxx 192.168.1.10:2377
#
# To add a manager to this swarm, run the following command:
#
#   docker swarm join --token SWMTKN-1-xxxxx 192.168.1.10:2377
```

#### 2.2 Get Join Tokens

**On the first manager node**, retrieve tokens:

```bash
# Get worker join token
docker swarm join-token worker -q
# Output: SWMTKN-1-xxxxx-worker-token

# Get manager join token
docker swarm join-token manager -q
# Output: SWMTKN-1-xxxxx-manager-token
```

### 3. Add Worker Nodes

**On each worker node (swarm-worker-1, swarm-worker-2)**:

```bash
# Join as worker node using the token from step 2.2
docker swarm join --token <worker-token> 192.168.1.10:2377

# Verify successful join
docker node ls
```

### 4. Add Additional Manager Nodes for HA

**On existing manager nodes**, add more managers:

```bash
# On current manager, promote another node to manager
docker node promote swarm-manager-2

# OR: On new manager node, join using manager token
docker swarm join --token <manager-token> 192.168.1.10:2377
```

**Best Practice**: Use odd number of manager nodes (3, 5, 7) for quorum.

### 5. Configure Network Overlay

#### 5.1 Create Overlay Network

**On any manager node**:

```bash
# Create overlay network with encryption
docker network create \
  --driver overlay \
  --subnet 10.0.10.0/24 \
  --attachable \
  --opt encrypted \
  swarm-overlay-net

# Verify network creation
docker network ls
```

#### 5.2 Configure Ingress Network (Optional)

```bash
# Remove default ingress network (if needed for custom configuration)
docker network rm ingress

# Create custom ingress network with specific subnet
docker network create \
  --driver overlay \
  --ingress \
  --subnet 10.11.0.0/16 \
  --opt encrypted \
  --opt com.docker.network.driver.mtu=1450 \
  custom-ingress
```

### 6. Deploy Services with High Availability

#### 6.1 Deploy a Replicated Service

```bash
# Deploy nginx with 3 replicas across nodes
docker service create \
  --name web-frontend \
  --replicas 3 \
  --network swarm-overlay-net \
  --publish published=8080,target=80,mode=host \
  --update-order start-first \
  --update-parallelism 1 \
  --update-delay 10s \
  --restart-condition any \
  --restart-max-attempts 3 \
  --limit-cpu 0.5 \
  --limit-memory 512M \
  --reserve-cpu 0.25 \
  --reserve-memory 256M \
  nginx:alpine
```

#### 6.2 Deploy with Placement Constraints

```bash
# Deploy service to specific node types
docker service create \
  --name database \
  --replicas 1 \
  --network swarm-overlay-net \
  --constraint 'node.role==manager' \
  --env POSTGRES_PASSWORD=secretpassword \
  --mount type=volume,source=pgdata,target=/var/lib/postgresql/data \
  --limit-cpu 2 \
  --limit-memory 4G \
  postgres:15
```

#### 6.3 Deploy Global Service (One per Node)

```bash
# Deploy monitoring agent on every node
docker service create \
  --name node-exporter \
  --mode global \
  --network host \
  --mount type=bind,source=/proc,destination=/host/proc,readonly \
  --mount type=bind,source=/sys,destination=/host/sys,readonly \
  --mount type=bind,source=/,destination=/rootfs,readonly \
  prom/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.rootfs=/rootfs \
  --path.sysfs=/host/sys
```

### 7. Configure Rolling Updates

```bash
# Update existing service with zero-downtime deployment
docker service update \
  --image nginx:1.25-alpine \
  --update-parallelism 2 \
  --update-delay 5s \
  --update-failure-action rollback \
  --update-monitor 10s \
  --update-max-failure-ratio 0.2 \
  web-frontend

# Monitor update progress
docker service ps web-frontend --no-trunc
```

### 8. Configure Secrets Management

#### 8.1 Create Docker Secrets

```bash
# Create a secret from file
echo "my-database-password" | docker secret create db_password -

# Create secret from literal value
docker secret create api_key <(echo "secret-api-key-12345")

# List secrets
docker secret ls
```

#### 8.2 Deploy Service with Secrets

```bash
docker service create \
  --name web-app \
  --network swarm-overlay-net \
  --secret source=db_password,target=db_password \
  --secret source=api_key,target=api_key,mode=0440 \
  --env POSTGRES_PASSWORD_FILE=/run/secrets/db_password \
  my-web-app:latest
```

### 9. Configure Logging and Monitoring

#### 9.1 Deploy Logging Driver Configuration

```bash
# Configure Docker daemon for JSON logging (daemon.json)
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}

# For centralized logging with Loki/Promtail
docker service create \
  --name promtail \
  --mode global \
  --network host \
  --mount type=bind,source=/var/log,target=/var/log \
  --mount type=bind,source=/etc/promtail,target=/etc/promtail \
  grafana/promtail:latest \
  -config.file=/etc/promtail/promtail-config.yml
```

#### 9.2 Deploy Monitoring Stack

```bash
# Deploy Prometheus for monitoring
docker stack deploy -c monitoring.yml monitoring

# monitoring.yml example:
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    networks:
      - monitoring-net

networks:
  monitoring-net:
    driver: overlay
    attachable: true
```

### 10. Security Hardening

#### 10.1 Configure TLS for Docker Swarm

```bash
# Generate self-signed certificates (production: use CA-signed)
openssl genrsa -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=$(hostname)" -sha256 -new -key server-key.pem -out server.csr
echo "subjectAltName = IP:192.168.1.10,IP:192.168.1.11,IP:192.168.1.12" > extfile.cnf
echo "extendedKeyUsage = serverAuth" >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# Configure Docker daemon for TLS
{
  "tls": true,
  "tlscacert": "/etc/docker/ca.pem",
  "tlscert": "/etc/docker/server-cert.pem",
  "tlskey": "/etc/docker/server-key.pem",
  "tlsverify": true
}
```

#### 10.2 Network Security Policies

```bash
# Create network with no ingress access
docker network create \
  --internal \
  --driver overlay \
  --subnet 10.0.20.0/24 \
  internal-only-network

# Implement firewall rules on each node
iptables -A INPUT -p tcp --dport 2377 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 2377 -j DROP
iptables -A INPUT -p tcp --dport 7946 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 7946 -j DROP
iptables -A INPUT -p tcp --dport 4789 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 4789 -j DROP
```

### 11. Backup and Recovery

#### 11.1 Backup Swarm Configuration

```bash
#!/bin/bash
# swarm-backup.sh - Backup Docker Swarm configuration

BACKUP_DIR="/backup/swarm"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p ${BACKUP_DIR}/${DATE}

# Backup swarm certificates
cp -r /var/lib/docker/swarm/ ${BACKUP_DIR}/${DATE}/swarm/

# Backup Docker daemon configuration
cp /etc/docker/daemon.json ${BACKUP_DIR}/${DATE}/

# Backup network configurations
docker network ls --format '{{.Name}}' | while read network; do
  docker network inspect ${network} > ${BACKUP_DIR}/${DATE}/network-${network}.json
done

# Backup service definitions
docker service ls --format '{{.Name}}' | while read service; do
  docker service inspect ${service} > ${BACKUP_DIR}/${DATE}/service-${service}.json
done

# Compress backup
tar -czf ${BACKUP_DIR}/swarm-backup-${DATE}.tar.gz -C ${BACKUP_DIR} ${DATE}
rm -rf ${BACKUP_DIR}/${DATE}

echo "Backup created: ${BACKUP_DIR}/swarm-backup-${DATE}.tar.gz"
```

#### 11.2 Restore Swarm Configuration

```bash
#!/bin/bash
# swarm-restore.sh - Restore Docker Swarm from backup

BACKUP_FILE="/backup/swarm/swarm-backup-20240101-120000.tar.gz"

# Stop Docker
teamctl leave --force
systemctl stop docker

# Extract backup
tar -xzf ${BACKUP_FILE} -C /tmp/
cp -r /tmp/swarm/* /var/lib/docker/swarm/
cp /tmp/daemon.json /etc/docker/

# Restart Docker
systemctl start docker

# Rejoin swarm
docker swarm join --token <token> <manager-ip>:2377
```

### 12. Monitoring and Health Checks

#### 12.1 Node Health Monitoring

```bash
# Monitor node status
docker node ls

# Check node availability
for node in swarm-manager-1 swarm-manager-2 swarm-manager-3 swarm-worker-1 swarm-worker-2; do
  echo "Checking ${node}..."
  if ping -c 1 ${node} &>/dev/null; then
    echo "  ✓ Ping successful"
  else
    echo "  ✗ Ping failed"
  fi
done

# Check Docker daemon status on each node
for node in swarm-manager-1 swarm-manager-2 swarm-manager-3; do
  echo "Checking Docker on ${node}..."
  ssh ${node} 'systemctl is-active docker'
done
```

#### 12.2 Service Health Monitoring

```bash
# Monitor service status
docker service ls

# Check service tasks
docker service ps <service-name> --no-trunc

# Monitor resource usage
docker stats --no-stream

# Check logs for errors
docker service logs <service-name> --since 1h | grep -i error
```

### 13. High Availability Testing

#### 13.1 Test Manager Failure

```bash
# Simulate manager failure
ssh swarm-manager-1 'sudo systemctl stop docker'

# Verify swarm still operational
docker node ls
# Check that remaining managers maintain quorum

# Restart failed manager
ssh swarm-manager-1 'sudo systemctl start docker'

# Verify node returns to swarm
docker node ls
```

#### 13.2 Test Worker Failure

```bash
# Simulate worker failure
ssh swarm-worker-1 'sudo systemctl stop docker'

# Verify services rescheduled
docker service ps <service-name>

# Restart failed worker
ssh swarm-worker-1 'sudo systemctl start docker'

# Verify node rejoins swarm
docker node ls
```

### 14. Maintenance Operations

#### 14.1 Drain Node for Maintenance

```bash
# Set node to drain mode (reschedule tasks)
docker node update --availability drain swarm-worker-1

# Perform maintenance
# ...

# Return node to active mode
docker node update --availability active swarm-worker-1
```

#### 14.2 Update Docker on Swarm Nodes

```bash
# Drain node
docker node update --availability drain swarm-worker-1

# Update Docker
ssh swarm-worker-1 'sudo apt-get update && sudo apt-get install docker-ce'

# Return node to service
docker node update --availability active swarm-worker-1

# Repeat for all nodes
```

## Verify

### Verification Commands

```bash
# 1. Verify cluster status
docker node ls
# Expected: All nodes showing Ready status
# Expected: Manager nodes showing Leader status

# 2. Verify network overlay
docker network ls --filter driver=overlay
# Expected: swarm-overlay-net listed

# 3. Verify services running
docker service ls
# Expected: All services with REPLICAS matching desired count

# 4. Verify service distribution
docker service ps <service-name>
# Expected: Tasks distributed across nodes

# 5. Test service connectivity
curl http://localhost:8080
# Expected: Service response

# 6. Verify overlay network connectivity
docker run --rm --network swarm-overlay-net busybox ping -c 2 <service-name>
# Expected: Successful ping responses
```

### Health Check Metrics

```bash
# Monitor cluster health with custom script
#!/bin/bash
# swarm-health-check.sh

HEALTHY=0
TOTAL=0

# Check manager nodes
MANAGER_COUNT=$(docker node ls --filter role=manager --format '{{.Hostname}}' | wc -l)
for manager in $(docker node ls --filter role=manager --format '{{.Hostname}}'); do
  TOTAL=$((TOTAL + 1))
  if docker node inspect ${manager} --format '{{.Status.State}}' | grep -q "ready"; then
    HEALTHY=$((HEALTHY + 1))
  fi
done

# Check worker nodes
WORKER_COUNT=$(docker node ls --filter role=worker --format '{{.Hostname}}' | wc -l)
for worker in $(docker node ls --filter role=worker --format '{{.Hostname}}'); do
  TOTAL=$((TOTAL + 1))
  if docker node inspect ${worker} --format '{{.Status.State}}' | grep -q "ready"; then
    HEALTHY=$((HEALTHY + 1))
  fi
done

# Check service health
SERVICE_COUNT=$(docker service ls --format '{{.Name}}' | wc -l)
HEALTHY_SERVICES=0

for service in $(docker service ls --format '{{.Name}}'); do
  DESIRED=$(docker service inspect ${service} --format '{{.Spec.Mode.Replicated.Replicas}}')
  RUNNING=$(docker service ps ${service} --filter 'desired-state=running' --format '{{.Name}}' | wc -l)
  if [ "${RUNNING}" -eq "${DESIRED}" ]; then
    HEALTHY_SERVICES=$((HEALTHY_SERVICES + 1))
  fi
done

# Display health report
echo "=== Docker Swarm Health Report ==="
echo "Nodes: ${HEALTHY}/${TOTAL} healthy"
echo "Services: ${HEALTHY_SERVICES}/${SERVICE_COUNT} healthy"

if [ "${HEALTHY}" -eq "${TOTAL}" ] && [ "${HEALTHY_SERVICES}" -eq "${SERVICE_COUNT}" ]; then
  echo "Status: ✅ HEALTHY"
  exit 0
else
  echo "Status: ⚠️  DEGRADED"
  exit 1
fi
```

## Rollback

### Rolling Back Service Updates

```bash
# Rollback to previous service version
docker service rollback <service-name>

# Monitor rollback progress
docker service ps <service-name> --no-trunc

# Force rollback to specific version
docker service update \
  --image <previous-image-version> \
  <service-name>
```

### Rolling Back Docker Version

```bash
# On Ubuntu/Debian
apt-get install docker-ce=<previous-version> docker-ce-cli=<previous-version>

# On CentOS/RHEL
yum downgrade docker-ce-<previous-version> docker-ce-cli-<previous-version>

systemctl restart docker
```

### Emergency Swarm Recovery

```bash
# If swarm is in inconsistent state

# 1. Force leave all nodes
for node in swarm-manager-1 swarm-manager-2 swarm-manager-3 swarm-worker-1 swarm-worker-2; do
  ssh ${node} 'docker swarm leave --force'
done

# 2. Clean up swarm data (on all nodes)
systemctl stop docker
rm -rf /var/lib/docker/swarm
systemctl start docker

# 3. Reinitialize swarm on first manager
docker swarm init --advertise-addr 192.168.1.10

# 4. Rejoin all nodes (using new tokens)
docker swarm join --token <worker-token> 192.168.1.10:2377  # Workers
docker swarm join --token <manager-token> 192.168.1.10:2377  # Managers

# 5. Redeploy services
docker stack deploy -c docker-compose.yml <stack-name>
```

## Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `timeout was exceeded` | Network connectivity issues between nodes | Check firewall rules, ensure ports 2377, 7946, 4789 are open |
| `could not choose an IP address` | Multiple network interfaces | Specify advertise address with `--advertise-addr` flag |
| `node is not a swarm manager` | Attempting manager operation on worker node | Use manager node for swarm commands or promote worker |
| `rpc error: code = Unavailable` | Docker daemon not running | Start Docker daemon: `systemctl start docker` |
| `network <name> not found` | Network not created or wrong scope | Create network or specify correct scope (local/overlay) |
| `no compatible node available` | Node constraints not met | Check resource availability, node labels, and constraints |
| `secret not found` | Secret not accessible to service | Ensure secret is created before service deployment |
| `image pull failed` | Registry authentication or network issues | Check registry credentials, network connectivity |

### Troubleshooting Network Issues

```bash
# Check overlay network connectivity
docker network inspect swarm-overlay-net

# Test DNS resolution between containers
docker run --rm --network swarm-overlay-net busybox nslookup <service-name>

# Check iptables rules
iptables -L -n -v

# Check Docker daemon logs
journalctl -u docker.service -f

# Check for port conflicts
netstat -tlnp | grep -E '2377|7946|4789'
```

### Troubleshooting Service Issues

```bash
# Check service logs
docker service logs <service-name> --since 1h

# Inspect service configuration
docker service inspect <service-name>

# Check task failures
docker service ps <service-name> --filter 'desired-state=shutdown'

# Debug container in service
docker exec -it <container-id> /bin/bash

# Check resource constraints
docker stats <container-id>
```

### Troubleshooting Node Issues

```bash
# Check node status
docker node inspect <node-name>

# Check Docker daemon status
systemctl status docker

# Check disk space
df -h

# Check memory usage
free -h

# Check network connectivity
ping <other-node-ip>
telnet <other-node-ip> 2377
```

## References

- [Docker Swarm Documentation](https://docs.docker.com/engine/swarm/)
- [Docker Networking Guide](https://docs.docker.com/network/)
- [Docker Secrets Management](https://docs.docker.com/engine/swarm/secrets/)
- [High Availability Docker Swarm](https://docs.docker.com/engine/swarm/admin_guide/#manage-the-swarm)
- [Swarm Mode Routing Mesh](https://docs.docker.com/engine/swarm/ingress/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Docker Service Commands](https://docs.docker.com/engine/reference/commandline/service/)
- [Docker Swarm Tutorial](https://docs.docker.com/engine/swarm/swarm-tutorial/)

## Notes

- Always test swarm configurations in a non-production environment first
- Maintain an odd number of manager nodes (3, 5, 7) for proper quorum
- Regular backups of swarm certificates and configurations are critical
- Monitor disk space on manager nodes as raft logs grow over time
- Use rolling updates for zero-downtime deployments
- Implement proper monitoring and alerting for the swarm cluster
- Consider using Docker UCP (Universal Control Plane) for enterprise features
- Keep Docker versions consistent across all swarm nodes
- Document all custom configurations and procedures