# Quay Container Registry Installation with Clair Vulnerability Scanning

---
SQUIRREL:
  title: "Quay Container Registry Installation with Clair Vulnerability Scanning"
  category: "oci-registry"
  tags: ["quay", "clair", "container-registry", "vulnerability-scanning", "clair-scanner", "security", "red-hat", "clairv4"]
  last_verified: "2026-05-12"
  version: "Quay v3"
---

## Purpose

Deploy and configure Red Hat Quay container registry for storing, managing, and distributing container images with integrated Clair vulnerability scanning. This guide covers Quay installation via Operator (OpenShift) or standalone (all-in-one), repository configuration, authentication (local, LDAP, OIDC), Clair integration for security scanning, and repository mirroring.

## When to use

- Enterprise container registry with role-based access control (RBAC)
- Vulnerability scanning and compliance reporting for container images
- Repository mirroring from upstream registries (Docker Hub, GCR, ECR)
- Geo-distributed registry deployments for multi-region access
- Integration with CI/CD pipelines for image promotion workflows
- Meeting security compliance requirements with image signing (Cosign)
- GitOps workflows with ArgoCD or Flux integration

## Prerequisites

- **Standalone deployment**: Linux server (Ubuntu 20.04+, RHEL 8+, CentOS 8+), 4+ CPU cores, 8+ GB RAM, 100+ GB disk
- **OpenShift deployment**: OpenShift 4.10+ cluster with cluster-admin access
- **Kubernetes deployment**: Kubernetes 1.24+ with at least 3 worker nodes
- Docker or Podman installed locally
- PostgreSQL 13+ (bundled for standalone, external for production)
- Redis 6+ (optional, for Redis caching)
- SSL/TLS certificate or Let's Encrypt for HTTPS
- For Clair: 2+ CPU cores, 4+ GB RAM for scanning worker
- Firewalld/iptables open for ports 80, 443, 5432, 6379

## Steps

### Step 1: Standalone Quay Installation (All-in-One)

#### Install dependencies:

```bash
# Ubuntu/Devuan
sudo apt-get update
sudo apt-get install -y curl gnupg2 lsb-release

# RHEL/CentOS
sudo yum install -y curl gnupg2 redhat-lsb-core

# Add Docker repo if needed
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Or use Podman (recommended)
sudo apt-get install -y podman
```

#### Install Quay via Docker Compose (recommended for single-node):

```bash
# Create Quay directory
sudo mkdir -p /opt/quay/{config,storage}
sudo useradd -r -u 1010 quay-user 2>/dev/null || true
sudo chown -R 1010:1010 /opt/quay

# Download Quay install script
curl -fsSL https:// Quarry.io/install/containers/quay-operator-bundle.tar.gz -o quay-bundle.tar.gz

# Extract and setup
tar -xzf quay-bundle.tar.gz -C /opt/quay/

# Create docker-compose.yaml
cat > /opt/quay/docker-compose.yaml << 'EOF'
version: '3.8'

services:
  quay:
    image: quay.io/quay/quay:v3.11
    ports:
      - "443:8443"
      - "80:8080"
    volumes:
      - ./config:/quay-var/conf
      - ./storage:/datastorage
    environment:
      - QUAY_CONFIGURATION_PATH=/quay-var/conf/config.yaml
      - QUAY_SUPER_USERS=[admin]
      - QUAY_INITIAL_PASSWORD=quay123
      - DATABASE_SECRET_KEY=change-this-secret
      - SECRET_KEY=change-this-secret
      - DISTRIBUTED_SECRET_PHRASE=change-this-phrase
    restart: always
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:13
    environment:
      - POSTGRESQL_PASSWORD=quay
      - POSTGRESQL_USER=quay
      - POSTGRESQL_PASSWORD=quay
      - POSTGRESQL_DATABASE=quay
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    restart: always

  redis:
    image: redis:7
    volumes:
      - ./redis-data:/data
    restart: always
EOF
```

#### Create Quay configuration file:

```bash
cat > /opt/quay/config/config.yaml << 'EOF'
# Quay Configuration
SERVER_HOSTNAME: quay.example.com
SETUP_COMPLETE: true

# Database
DB_URI: postgresql://quay:quay@postgres:5432/quay

# Redis
REDIS_PASSWORD: ""

# Build logs
BUILDLOGS_REDIS:
  host: redis
  port: 6379

# Super users
SUPER_USERS:
  - admin

# Authentication
AUTHENTICATION_TYPE: DatabaseAuthentication

# Registry settings
REGISTRY_TITLE: "My Private Registry"
REGISTRY_TITLE_SHORT: "Quay"
REGISTRY_FAVICON: ""

# Feature flags
FEATURE_SECURITY_SCANNER: true
FEATURE_GITHUB_BUILD_TRIGGER: false
FEATURE_GITLAB_BUILD_TRIGGER: false
FEATURE_BITBUCKET_BUILD_TRIGGER: false
FEATURE_BUILD_SUPPORT: false

# Security scanner (Clair integration)
SECURITY_SCANNER_V4_ENDPOINT: http://clair:6060
SECURITY_SCANNER_V4_PSK: changeme_psk_value

# Storage
STORAGE: LocalStorage
LOCAL_STORAGE: /datastorage

# SSL/TLS
USE_LETSENCRYPT: true
LETSENCRYPT_EMAIL: admin@example.com

# Logging
LOGGING: INFO
DEBUG: false
EOF

# Generate secret keys
openssl rand -hex 32 | tee /opt/quay/config/secret
SECRET_KEY=$(openssl rand -hex 32)
DATABASE_SECRET_KEY=$(openssl rand -hex 32)
cat >> /opt/quay/config/config.yaml << EOF
DATABASE_SECRET_KEY: $DATABASE_SECRET_KEY
SECRET_KEY: $SECRET_KEY
DISTRIBUTED_SECRET_PHRASE: $(openssl rand -hex 32)
EOF
```

#### Start Quay:

```bash
cd /opt/quay
docker-compose up -d

# Check logs
docker-compose logs -f quay

# Verify health
curl -k https://localhost:8443/health/instance
```

### Step 2: Install Clair for Vulnerability Scanning

#### Standalone Clair deployment:

```bash
# Create Clair directory
mkdir -p /opt/clair/{config,data}
chown -R 1000:1000 /opt/clair 2>/dev/null || true

# Create Clair configuration
cat > /opt/clair/config/config.yaml << 'EOF'
http:
  addr: ":6060"
  health: ":6061"
  pprof: ":6062"

introspection:
  addr: ":6063"

log:
  level: debug
  format: json

api:
  addr: "0.0.0.0:6060"

indexer:
  scan_lock_retry: 10
  scan_request_timeout: 200m
  max_concurrent_indexers: 2
  batch_size: 100

matcher:
  database:
    type: pgsql
    options:
      connection_string: "host=postgres port=5432 user=clair dbname=clair sslmode=disable password=clair"
      migrations: "/etc/clair/config/migrations"
  max_concurrent_matchers: 2

notifier:
  database:
    type: pgsql
    options:
      connection_string: "host=postgres port=5432 user=clair dbname=clair sslmode=disable password=clair"
      migrations: "/etc/clair/config/migrations"

  register_webhooks:
    - url: http://quay:8080/security scanner/api/v1/notify

  delivery: 2m
EOF

# Add Clair to docker-compose
cat >> /opt/quay/docker-compose.yaml << 'EOF'

  clair:
    image: quay.io/projectquay/clair:amd64-latest
    volumes:
      - ./clair/config:/etc/clair
      - ./clair/data:/var/lib/clair
    environment:
      - CLAIR_MODE=combo
      - CLAIR_CONF=/etc/clair/config.yaml
      - CLAIR_POLL=15m
    restart: always
    depends_on:
      - postgres
    ports:
      - "6060:6060"
      - "6061:6061"
EOF

docker-compose up -d clair
```

#### Enable Clair in Quay:

```bash
# Update Quay config to enable security scanner
cat >> /opt/quay/config/config.yaml << 'EOF'

# Security Scanner
SECURITY_SCANNER_V4_ENDPOINT: http://clair:6060
SECURITY_SCANNER_V4_PSK: changeme_psk_value
FEATURE_SECURITY_SCANNER: true
EOF

# Restart Quay
docker-compose restart quay

# Verify scanner in Quay UI
# Navigate to: Admin > Repository > Security Scanner
```

### Step 3: Configure Authentication

#### Option A: Database authentication (default)

```bash
# Create user via API
curl -X POST https://quay.example.com/api/v1/user \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","email":"admin@example.com","password":"SecurePass123!"}'
```

#### Option B: LDAP/Active Directory

```bash
cat > /opt/quay/config/ldap-config.yaml << 'EOF'
AUTHENTICATION_TYPE: LDAPAuthentication

LDAP:
  USER_FILTER: "(objectClass=person)"
  USER_NAME_ATTRIBUTE: "uid"
  EMAIL_ATTRIBUTE: "mail"
  GROUP_FILTER: "(objectClass=groupOfNames)"
  GROUP_MEMBERSHIP_ATTRIBUTE: "member"
  
  BASE_GROUPS:
    - "cn=quay-users,ou=groups,dc=example,dc=com"
    - "cn=quay-admins,ou=groups,dc=example,dc=com"
  
  BASE_DN: "dc=example,dc=com"
  URI: "ldap://ldap.example.com:389"
  TLS: false
  ADMIN_GROUP: "cn=quay-admins,ou=groups,dc=example,dc=com"
EOF
```

#### Option C: OIDC (Okta, Keycloak, Azure AD)

```bash
cat > /opt/quay/config/oidc-config.yaml << 'EOF'
AUTHENTICATION_TYPE: OIDCAuthentication

OIDC:
  PROVIDER: "Okta"
  CLIENT_ID: "your-client-id"
  CLIENT_SECRET: "your-client-secret"
  SERVICE_NAME: "quay"
  
  OIDC_SERVER: "https://your-okta.okta.com"
  OIDC_SCopes: "openid profile email"
  
  # Role mapping
  SUPER_USERS_GROUPS: ["quay-admins"]
EOF
```

### Step 4: Configure Repository Mirroring

```bash
# Enable repository mirroring
cat >> /opt/quay/config/config.yaml << 'EOF'

FEATURE_REPO_MIRROR: true

# Mirroring settings
REPO_MIRROR_INTERVAL: 300
REPO_MIRROR_RETENTION_MAX: 5
REPO_MIRROR_RETENTION_MIN: 2

# Mirror credentials
MIRROR_SOURCE_CREDENTIALS:
  - name: "docker-hub"
    url: "https://registry-1.docker.io"
    credentials: base64_encoded_creds
EOF

# Create robot account for mirroring
curl -X POST https://quay.example.com/api/v1/organization/{org}/robots \
  -H "Authorization: Bearer $QUAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"description": "Robot for repo mirroring", "name": "mirror-robot"}'
```

### Step 5: Configure Image Signing (Cosign)

```bash
# Generate Cosign key pair
cosign generate-key-pair

# Store private key in Quay
curl -X PUT https://quay.example.com/api/v1/repository/{org}/{repo}/signatures \
  -H "Authorization: Bearer $QUAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"cosign_pubkey": "base64-encoded-public-key"}'

# Enable mandatory signing
cat >> /opt/quay/config/config.yaml << 'EOF'
FEATURE_MUTABLE_WEBHOOKS_LAUNCH: true
REQUIRE_CONDITIONAL_ACCESS_LEVEL: false

# Signing enforcement
REQUIRES_DOCUMENTATION_SIGNATURE: true
DOCUMENTATION_SIGNATURE_POLICY_TYPE: "org"
EOF
```

### Step 6: Push and Pull Images

```bash
# Tag image
docker tag myapp:latest quay.example.com/myorg/myapp:latest

# Login to Quay
docker login quay.example.com -u admin -p SecurePass123!

# Push image
docker push quay.example.com/myorg/myapp:latest

# Pull image
docker pull quay.example.com/myorg/myapp:latest

# View image details via API
curl -H "Authorization: Bearer $QUAY_TOKEN" \
  https://quay.example.com/api/v1/repository/myorg/myapp

# List repository tags
curl -H "Authorization: Bearer $QUAY_TOKEN" \
  https://quay.example.com/api/v1/repository/myorg/myapp/tag?limit=50
```

### Step 7: OpenShift Operator Installation

```bash
# Create Quay Operator namespace
oc new-project quay-enterprise

# Create custom CatalogSource (if not using OperatorHub)
cat > catalog-source.yaml << 'EOF'
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: quay-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/projectquay/quay-operator-catalog:latest
  displayName: "Red Hat Quay Operator"
EOF

oc apply -f catalog-source.yaml

# Create OperatorGroup
cat > operatorgroup.yaml << 'EOF'
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: quay-operator-group
  namespace: quay-enterprise
spec:
  targetNamespaces:
    - quay-enterprise
EOF

oc apply -f operatorgroup.yaml

# Create QuayRegistry
cat > quayregistry.yaml << 'EOF'
apiVersion: quay.redhat.com/v1
kind: QuayRegistry
metadata:
  name: quayregistry
  namespace: quay-enterprise
spec:
  configFiles:
    - secretName: quay-config
      data: |
        DATABASE_SECRET_KEY: base64-encoded-secret
        SECRET_KEY: base64-encoded-secret
        DISTRIBUTED_SECRET_PHRASE: base64-encoded-phrase

  components:
    - kind: quay
      managed: true
    - kind: postgres
      managed: true
    - kind: redis
      managed: true
    - kind: clair
      managed: true
    - kind: mirroring
      managed: true
EOF

oc apply -f quayregistry.yaml

# Check deployment status
oc get quayregistry -n quay-enterprise
oc get pods -n quay-enterprise
```

### Step 8: Configure Geo-Replication (Enterprise)

```bash
# Create additional registry instances in different regions

# Configure replication in config.yaml
cat >> /opt/quay/config/config.yaml << 'EOF'

# Geo-replication (Quay Enterprise)
FEATURE_GEO_REPLICATING: true

GEO_READ_FALLBACK: true

REPLICATOR_INTERVAL: 5
REPLICATOR_VERIFY_TLS: true

# Blob storage for replication
DISTRIBUTED_STORAGE_CLASS:
  - name: default
    driver: "AmazonS3StorageDriver"
    kwargs:
      bucket: "quay-{username}-blobs"
      region: "us-east-1"
      access_key: "AWS_ACCESS_KEY"
      secret_key: "AWS_SECRET_KEY"
  
  - name: eu-replica
    driver: "AmazonS3StorageDriver"
    kwargs:
      bucket: "quay-eu-blobs"
      region: "eu-west-1"
      access_key: "AWS_ACCESS_KEY"
      secret_key: "AWS_SECRET_KEY"
EOF
```

## Verify

1. Check Quay health:

```bash
curl -k https://quay.example.com/health/instance
# Expected: {"data":{"status":"Green","errors":[]},"details":{"database":true,"redis":true}}
```

2. Check Clair scanner:

```bash
curl http://localhost:6060/health
# Expected: {"status":"ok"}

# Check vulnerability database
curl http://localhost:6060/api/v1/namespace | jq '.total')
```

3. Verify image scanning:

```bash
# Push an image and check scan results
docker pull alpine:latest
docker tag alpine:latest quay.example.com/myorg/test-scan:latest
docker push quay.example.com/myorg/test-scan:latest

# Get scan status via API
curl -H "Authorization: Bearer $QUAY_TOKEN" \
  https://quay.example.com/api/v1/repository/myorg/test-scan/tag/latest/securityScanner

# Check vulnerability report
curl -H "Authorization: Bearer $QUAY_TOKEN" \
  https://quay.example.com/api/v1/repository/myorg/test-scan/manifest/latest/security-report
```

4. Test authentication:

```bash
# Login via Docker
docker login quay.example.com

# Check robot account access
curl -H "Authorization: Bearer $ROBOT_TOKEN" \
  https://quay.example.com/api/v1/repository/myorg/test-scan
```

## Rollback

### Remove Quay deployment (standalone):

```bash
cd /opt/quay
docker-compose down -v  # Removes volumes
rm -rf /opt/quay/{config,storage,postgres-data,redis-data}
```

### Restore from backup:

```bash
# Stop Quay
docker-compose stop

# Restore database
docker-compose exec -T postgres psql -U quay -d quay < backup.sql

# Restore storage
rsync -av backup/storage/ /datastorage/

# Restart Quay
docker-compose up -d
```

### Revert Quay config changes:

```bash
# Restore original config
cp /opt/quay/config/config.yaml.backup /opt/quay/config/config.yaml

# Restart Quay
docker-compose restart quay
```

## Common Errors

### Error: Database connection failed

**Symptom:** `FATAL: password authentication failed for user "quay"`

**Solution:**
- Check PostgreSQL credentials in config.yaml match `DB_URI`
- Verify PostgreSQL is running: `docker-compose ps postgres`
- Check database exists: `docker-compose exec postgres psql -U postgres -l`

### Error: Clair not connecting to Quay

**Symptom:** `SECURITY_SCANNER_V4_PSK mismatch`

**Solution:**
- Ensure PSK in Quay config matches Clair config
- Restart both services: `docker-compose restart quay clair`

### Error: Image push fails with 502 Bad Gateway

**Symptom:** `502 Bad Gateway` on docker push

**Solution:**
- Check Quay is running: `docker-compose ps`
- Check logs: `docker-compose logs quay`
- Verify storage permissions: `ls -la /opt/quay/storage`

### Error: LDAP authentication not working

**Symptom:** `Authentication failed` with LDAP

**Solution:**
- Verify LDAP URI and base DN in config
- Test LDAP connectivity: `ldapsearch -H ldap://ldap.example.com -D "cn=admin,dc=example,dc=com" -W`
- Check network connectivity from Quay container

### Error: Vulnerability scan stuck

**Symptom:** Scan never completes

**Solution:**
- Check Clair logs: `docker-compose logs clair`
- Increase Clair resources: add `--memory=4g` to container
- Verify PostgreSQL for scan results: `docker-compose exec postgres psql -U postgres -d clair -c "SELECT * FROM scans LIMIT 10;"`

## References

- [Quay Documentation](https://docs.projectquay.io)
- [Quay Operator for OpenShift](https://docs.projectquay.io/quay_operator/index.html)
- [Clair Vulnerability Database](https://clair.tech)
- [Clair API Reference](https:// Quay.io/clair/api/v1/openapi.yaml)
- [Quay Configuration](https://docs.projectquay.io/configuration.html)
- [Repository Mirroring](https://docs.projectquay.io/repo_mirroring.html)
- [Cosign Image Signing](https://github.com/sigstore/cosign)
- [Red Hat Quay Security](https://access.redhat.com/documentation/en-us/red_hat_quay)