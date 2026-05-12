#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
QUAY_VERSION="${QUAY_VERSION:-v3.11}"
QUAY_HOSTNAME="${QUAY_HOSTNAME:-}"
DB_PASSWORD="${DB_PASSWORD:-quay123}"
REDIS_PASSWORD="${REDIS_PASSWORD:-}"
SECURITY_SCANNER_PSK="${SECURITY_SCANNER_PSK:-changeme}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-Quay123Secure!}"
ENABLE_CLAIR="${ENABLE_CLAIR:-true}"
ENABLE_LETSENCRYPT="${ENABLE_LETSENCRYPT:-true}"
QUAY_EMAIL="${QUAY_EMAIL:-admin@example.com}"
STORAGE_PATH="${STORAGE_PATH:-/opt/quay/storage}"
CONFIG_PATH="${CONFIG_PATH:-/opt/quay/config}"
AUTH_TYPE="${AUTH_TYPE:-database}"
LDAP_URI="${LDAP_URI:-}"
LDAP_BASE_DN="${LDAP_BASE_DN:-}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Deploy Quay container registry with Clair vulnerability scanning.

OPTIONS:
    --dry-run                  Preview installation steps without executing
    --hostname HOST            Quay hostname (required)
    --version VERSION         Quay version (default: v3.11)
    --admin-user USER         Admin username (default: admin)
    --admin-password PASS     Admin password
    --db-password PASS        PostgreSQL password
    --redis-password PASS     Redis password
    --security-psk KEY        Security scanner pre-shared key
    --enable-clair            Enable Clair vulnerability scanning (default: true)
    --enable-letsencrypt      Enable Let's Encrypt (default: true)
    --storage-path PATH       Storage path (default: /opt/quay/storage)
    --config-path PATH        Config path (default: /opt/quay/config)
    --auth-type TYPE          Auth type: database, ldap, oidc (default: database)
    --ldap-uri URI            LDAP server URI (e.g., ldap://ldap.example.com:389)
    --ldap-base-dn DN         LDAP base DN (e.g., dc=example,dc=com)
    --email EMAIL             Admin email (default: admin@example.com)
    -h, --help                Show this help message

EXAMPLES:
    $0 --dry-run --hostname quay.example.com
    $0 --hostname quay.example.com --enable-clair --enable-letsencrypt
    $0 --hostname quay.example.com --auth-type ldap --ldap-uri ldap://ldap:389

EOF
    exit 0
}

log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%dT%H:%M:%S%z')] [$level] $*"
}

check_dependencies() {
    log "INFO" "Checking dependencies..."
    local missing=()
    for bin in docker curl openssl; do
        if ! command -v "$bin" >/dev/null 2>&1; then
            missing+=("$bin")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        log "ERROR" "Missing required binaries: ${missing[*]}"
        exit 1
    fi
    
    if ! docker info >/dev/null 2>&1; then
        log "ERROR" "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    log "INFO" "All dependencies available."
}

check_hostname() {
    if [ -z "$QUAY_HOSTNAME" ]; then
        log "ERROR" "Quay hostname is required. Use --hostname or set QUAY_HOSTNAME."
        exit 1
    fi
}

generate_secrets() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would generate secret keys"
        return 0
    fi
    
    mkdir -p "$CONFIG_PATH"
    
    if [ ! -f "$CONFIG_PATH/secret.key" ]; then
        openssl rand -hex 32 > "$CONFIG_PATH/secret.key"
        log "INFO" "Generated secret key"
    fi
    
    if [ ! -f "$CONFIG_PATH/db-secret.key" ]; then
        openssl rand -hex 32 > "$CONFIG_PATH/db-secret.key"
        log "INFO" "Generated database secret key"
    fi
}

create_config_yaml() {
    local hostname="$1"
    local auth_type="$2"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create config.yaml for $hostname"
        return 0
    fi
    
    log "INFO" "Creating Quay configuration..."
    
    local secret_key
    secret_key=$(cat "$CONFIG_PATH/secret.key")
    local db_secret
    db_secret=$(cat "$CONFIG_PATH/db-secret.key")
    
    cat > "$CONFIG_PATH/config.yaml" << CONFIG_EOF
SERVER_HOSTNAME: $hostname
SETUP_COMPLETE: true
DATABASE_SECRET_KEY: $db_secret
SECRET_KEY: $secret_key
DISTRIBUTED_SECRET_PHRASE: $secret_key

DB_URI: postgresql://quay:quay@postgres:5432/quay

BUILDLOGS_REDIS:
  host: redis
  port: 6379
  password: "${REDIS_PASSWORD:-}"

DATABASE:
  TYPE: postgres
  CONNECTION_STRING: postgresql://quay:quay@postgres:5432/quay
  SSL_MODE: disable

REDIS:
  host: redis
  port: 6379
  password: "${REDIS_PASSWORD:-}"

SUPER_USERS:
  - $ADMIN_USER

AUTHENTICATION_TYPE: ${auth_type}Authentication

REGISTRY_TITLE: "Quay Container Registry"
REGISTRY_TITLE_SHORT: "Quay"

FEATURE_SECURITY_SCANNER: $ENABLE_CLAIR
FEATURE_REPO_MIRROR: false
FEATURE_BUILD_SUPPORT: false
FEATURE_GITHUB_BUILD_TRIGGER: false
FEATURE_GITLAB_BUILD_TRIGGER: false
FEATURE_BITBUCKET_BUILD_TRIGGER: false

STORAGE: LocalStorage
LOCAL_STORAGE: $STORAGE_PATH

LOGGING: INFO
DEBUG: false

# Security scanner
CONFIGURATION_APP:
  - app: quay
    enabled: true

# Let's Encrypt
USE_LETSENCRYPT: $ENABLE_LETSENCRYPT
LETSENCRYPT_EMAIL: $QUAY_EMAIL
CONFIGURATION_APP:
  - app: letsencrypt
    enabled: $ENABLE_LETSENCRYPT
CONFIG_EOF

    if [ "$ENABLE_CLAIR" = "true" ]; then
        cat >> "$CONFIG_PATH/config.yaml" << CLAIR_EOF

# Clair Integration
SECURITY_SCANNER_V4_ENDPOINT: http://clair:6060
SECURITY_SCANNER_V4_PSK: $SECURITY_SCANNER_PSK
CLAIR_EOF
    fi

    if [ "$auth_type" = "ldap" ] && [ -n "$LDAP_URI" ]; then
        cat >> "$CONFIG_PATH/config.yaml" << LDAP_EOF

# LDAP Configuration
AUTHENTICATION_TYPE: LDAPAuthentication

LDAP:
  URI: $LDAP_URI
  BASE_DN: $LDAP_BASE_DN
  USER_FILTER: "(objectClass=person)"
  USER_NAME_ATTRIBUTE: "uid"
  EMAIL_ATTRIBUTE: "mail"
  GROUP_FILTER: "(objectClass=groupOfNames)"
  GROUP_MEMBERSHIP_ATTRIBUTE: "member"
  ADMIN_GROUP: ""
LDAP_EOF
    fi
    
    log "INFO" "Configuration created: $CONFIG_PATH/config.yaml"
}

create_docker_compose() {
    local hostname="$1"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create docker-compose.yaml"
        return 0
    fi
    
    log "INFO" "Creating Docker Compose configuration..."
    
    cat > "$CONFIG_PATH/docker-compose.yaml" << COMPOSE_EOF
version: '3.8'

services:
  postgres:
    image: postgres:13
    environment:
      - POSTGRES_USER=quay
      - POSTGRES_PASSWORD=quay
      - POSTGRES_DB=quay
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U quay"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    restart: always
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  quay:
    image: quay.io/quay/quay:$QUAY_VERSION
    ports:
      - "443:8443"
      - "80:8080"
    volumes:
      - $CONFIG_PATH:/quay-var/conf
      - $STORAGE_PATH:/datastorage
    environment:
      - QUAY_CONFIGURATION_PATH=/quay-var/conf/config.yaml
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health/instance"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
COMPOSE_EOF

    if [ "$ENABLE_CLAIR" = "true" ]; then
        cat >> "$CONFIG_PATH/docker-compose.yaml" << CLAIR_COMPOSE

  clair:
    image: quay.io/projectquay/clair:amd64-latest
    volumes:
      - ./clair/config:/etc/clair
      - ./clair/data:/var/lib/clair
    environment:
      - CLAIR_CONF=/etc/clair/config.yaml
      - CLAIR_MODE=combo
      - CLAIR_POLL=15m
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
    ports:
      - "6060:6060"
      - "6061:6061"
CLAIR_COMPOSE
    fi

    cat >> "$CONFIG_PATH/docker-compose.yaml" << VOLUMES_EOF

volumes:
  postgres-data:
  redis-data:
  quay-storage:
VOLUMES_EOF

    log "INFO" "Docker Compose created: $CONFIG_PATH/docker-compose.yaml"
}

create_clair_config() {
    if [ "$ENABLE_CLAIR" != "true" ] || [ "$DRY_RUN" = "true" ]; then
        return 0
    fi
    
    log "INFO" "Creating Clair configuration..."
    
    mkdir -p "$CONFIG_PATH/clair/config" "$CONFIG_PATH/clair/data"
    
    local db_secret
    db_secret=$(cat "$CONFIG_PATH/db-secret.key")
    
    cat > "$CONFIG_PATH/clair/config/config.yaml" << CLAIR_EOF
http:
  addr: ":6060"
  health: ":6061"

log:
  level: debug
  format: json

indexer:
  scan_lock_retry: 10
  scan_request_timeout: 200m
  max_concurrent_indexers: 2
  batch_size: 100

matcher:
  database:
    type: pgsql
    options:
      connection_string: host=postgres port=5432 user=quay dbname=quay sslmode=disable password=quay
      migrations: /etc/clair/config/migrations

notifier:
  database:
    type: pgsql
    options:
      connection_string: host=postgres port=5432 user=quay dbname=quay sslmode=disable password=quay
      migrations: /etc/clair/config/migrations
CLAIR_EOF

    log "INFO" "Clair configuration created"
}

create_superuser() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create superuser $ADMIN_USER"
        return 0
    fi
    
    log "INFO" "Creating superuser..."
    
    sleep 5
    
    local config_bucket
    config_bucket=$(curl -sk -X POST "https://$QUAY_HOSTNAME/api/v1/superuser/users" \
        -H "Content-Type: application/json" \
        -d "{\"username\":\"$ADMIN_USER\",\"email\":\"$QUAY_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}" 2>/dev/null || echo "")
    
    if [ -n "$config_bucket" ]; then
        log "INFO" "Superuser created: $ADMIN_USER"
    else
        log "WARN" "Superuser may already exist or API not ready yet"
    fi
}

start_services() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would start Quay services"
        return 0
    fi
    
    log "INFO" "Starting Quay services..."
    
    mkdir -p "$STORAGE_PATH"
    chown -R 1010:1010 "$STORAGE_PATH" 2>/dev/null || true
    
    cd "$CONFIG_PATH"
    docker-compose up -d
    
    log "INFO" "Waiting for services to be healthy..."
    sleep 30
    
    local retries=10
    while [ $retries -gt 0 ]; do
        if curl -sk --max-time 5 "https://localhost:8443/health/instance" | grep -q "status"; then
            log "INFO" "Quay is healthy"
            return 0
        fi
        log "INFO" "Waiting for Quay... ($retries retries left)"
        sleep 10
        retries=$((retries - 1))
    done
    
    log "WARN" "Quay may not be fully healthy yet, check logs with: docker-compose logs -f"
}

get_credentials() {
    if [ "$DRY_RUN" = "true" ]; then
        return 0
    fi
    
    echo ""
    echo "=========================================="
    echo "Quay Deployment Details:"
    echo "=========================================="
    echo "URL: https://$QUAY_HOSTNAME"
    echo "Admin User: $ADMIN_USER"
    echo "Admin Password: $ADMIN_PASSWORD"
    echo "Storage Path: $STORAGE_PATH"
    echo "Config Path: $CONFIG_PATH"
    echo "Clair Scanner: $ENABLE_CLAIR"
    echo "=========================================="
    echo ""
    echo "Docker login:"
    echo "  docker login $QUAY_HOSTNAME -u $ADMIN_USER -p $ADMIN_PASSWORD"
    echo ""
}

verify_deployment() {
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify deployment"
        return 0
    fi
    
    log "INFO" "Verifying deployment..."
    
    local health_response
    health_response=$(curl -sk --max-time 10 "https://$QUAY_HOSTNAME/health/instance" 2>/dev/null || echo "")
    
    if echo "$health_response" | grep -q "status"; then
        log "INFO" "Quay health check: PASSED"
        return 0
    else
        log "WARN" "Quay health check may not be available yet (expected during startup)"
        log "INFO" "Check logs with: cd $CONFIG_PATH && docker-compose logs -f quay"
        return 0
    fi
}

cleanup() {
    if [ "$CLEANUP" != "true" ] || [ "$DRY_RUN" = "true" ]; then
        return 0
    fi
    
    log "INFO" "Cleaning up deployment..."
    cd "$CONFIG_PATH"
    docker-compose down -v
    rm -rf "$STORAGE_PATH" "$CONFIG_PATH"
    log "INFO" "Cleanup complete"
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --hostname) QUAY_HOSTNAME="$2"; shift 2 ;;
            --version) QUAY_VERSION="$2"; shift 2 ;;
            --admin-user) ADMIN_USER="$2"; shift 2 ;;
            --admin-password) ADMIN_PASSWORD="$2"; shift 2 ;;
            --db-password) DB_PASSWORD="$2"; shift 2 ;;
            --redis-password) REDIS_PASSWORD="$2"; shift 2 ;;
            --security-psk) SECURITY_SCANNER_PSK="$2"; shift 2 ;;
            --enable-clair) ENABLE_CLAIR="true"; shift ;;
            --disable-clair) ENABLE_CLAIR="false"; shift ;;
            --enable-letsencrypt) ENABLE_LETSENCRYPT="true"; shift ;;
            --disable-letsencrypt) ENABLE_LETSENCRYPT="false"; shift ;;
            --storage-path) STORAGE_PATH="$2"; shift 2 ;;
            --config-path) CONFIG_PATH="$2"; shift 2 ;;
            --auth-type) AUTH_TYPE="$2"; shift 2 ;;
            --ldap-uri) LDAP_URI="$2"; shift 2 ;;
            --ldap-base-dn) LDAP_BASE_DN="$2"; shift 2 ;;
            --email) QUAY_EMAIL="$2"; shift 2 ;;
            -h|--help) usage ;;
            *) log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done
    
    check_dependencies
    check_hostname
    
    if [ "$AUTH_TYPE" = "ldap" ] && [ -z "$LDAP_URI" ]; then
        log "ERROR" "LDAP URI required when auth-type is ldap"
        exit 1
    fi
    
    log "INFO" "Starting Quay deployment..."
    log "INFO" "Hostname: $QUAY_HOSTNAME"
    log "INFO" "Version: $QUAY_VERSION"
    log "INFO" "Auth Type: $AUTH_TYPE"
    log "INFO" "Clair: $ENABLE_CLAIR"
    log "INFO" "Let's Encrypt: $ENABLE_LETSENCRYPT"
    
    generate_secrets
    create_config_yaml "$QUAY_HOSTNAME" "$AUTH_TYPE"
    create_docker_compose "$QUAY_HOSTNAME"
    
    if [ "$ENABLE_CLAIR" = "true" ]; then
        create_clair_config
    fi
    
    start_services
    create_superuser
    verify_deployment
    get_credentials
    
    log "INFO" "Quay deployment completed successfully!"
    log "INFO" "Access Quay at: https://$QUAY_HOSTNAME"
}

main "$@"