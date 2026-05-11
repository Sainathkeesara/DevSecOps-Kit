#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
RESOURCE_GROUP="${RESOURCE_GROUP:-rg-acr}"
ACR_NAME="${ACR_NAME:-}"
LOCATION="${LOCATION:-eastus}"
SKU="${SKU:-Premium}"
REPLICATION_REGIONS="${REPLICATION_REGIONS:-westeurope,southeastasia}"
ADMIN_ENABLED="${ADMIN_ENABLED:-false}"
PUBLIC_NETWORK_ACCESS="${PUBLIC_NETWORK_ACCESS:-enabled}"

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Deploy Azure Container Registry (ACR) with optional geo-replication.

OPTIONS:
    --dry-run                  Preview installation steps without executing
    --resource-group NAME      Resource group name (default: rg-acr)
    --acr-name NAME            ACR name (required)
    --location REGION          Azure region (default: eastus)
    --sku SKU                  SKU: Standard, Premium (default: Premium)
    --replication REGIONS      Comma-separated regions for geo-replication
    --admin-enabled           Enable admin user (default: false)
    --public-access ACCESS     Public network access: enabled, disabled (default: enabled)
    -h, --help                 Show this help message

EXAMPLES:
    $0 --dry-run --acr-name acrdemo --location eastus
    $0 --acr-name myregistry --replication "westeurope,southeastasia"
    ADMIN_ENABLED=true $0 --acr-name production-acr

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
    for bin in az docker; do
        if ! command -v "$bin" >/dev/null 2>&1; then
            missing+=("$bin")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        log "ERROR" "Missing required binaries: ${missing[*]}"
        log "ERROR" "Install Azure CLI: https://docs.microsoft.com/cli/azure/install-azure-cli"
        exit 1
    fi
    
    # Check Azure login
    if ! az account show >/dev/null 2>&1; then
        log "ERROR" "Not logged into Azure. Run 'az login' first."
        exit 1
    fi
    
    log "INFO" "All dependencies available."
}

check_acr_name() {
    if [ -z "$ACR_NAME" ]; then
        log "ERROR" "ACR name is required. Use --acr-name or set ACR_NAME environment variable."
        usage
    fi
    
    # Validate ACR name (alphanumeric, 5-50 chars)
    if ! [[ "$ACR_NAME" =~ ^[a-zA-Z0-9]{5,50}$ ]]; then
        log "ERROR" "ACR name must be 5-50 alphanumeric characters"
        exit 1
    fi
}

create_resource_group() {
    local rg_name="$1"
    local location="$2"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create resource group: $rg_name in $location"
        return 0
    fi
    
    if az group show --name "$rg_name" >/dev/null 2>&1; then
        log "INFO" "Resource group already exists: $rg_name"
    else
        log "INFO" "Creating resource group: $rg_name"
        az group create --name "$rg_name" --location "$location" --output none
    fi
}

create_acr() {
    local rg_name="$1"
    local acr_name="$2"
    local location="$3"
    local sku="$4"
    local admin="$5"
    local public_access="$6"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would create ACR: $acr_name in $location with SKU: $sku"
        log "DRY-RUN" "Would enable admin: $admin, public access: $public_access"
        return 0
    fi
    
    log "INFO" "Creating ACR: $acr_name"
    
    # Check if ACR already exists
    if az acr show --name "$acr_name" --resource-group "$rg_name" >/dev/null 2>&1; then
        log "WARN" "ACR already exists: $acr_name"
        log "INFO" "Updating ACR configuration..."
        az acr update \
            --name "$acr_name" \
            --resource-group "$rg_name" \
            --admin-enabled "$admin" \
            --public-network-access "$public_access" \
            --output none
    else
        az acr create \
            --resource-group "$rg_name" \
            --name "$acr_name" \
            --sku "$sku" \
            --location "$location" \
            --admin-enabled "$admin" \
            --public-network-access "$public_access" \
            --output none
    fi
    
    log "INFO" "ACR created/updated successfully"
}

configure_geo_replication() {
    local rg_name="$1"
    local acr_name="$2"
    local regions="$3"
    
    if [ "$SKU" != "Premium" ]; then
        log "WARN" "Geo-replication requires Premium SKU. Current: $SKU"
        log "WARN" "Skipping geo-replication configuration."
        return 0
    fi
    
    IFS=',' read -ra REGION_ARRAY <<< "$regions"
    
    for region in "${REGION_ARRAY[@]}"; do
        region=$(echo "$region" | tr -d '[:space:]')
        
        if [ "$DRY_RUN" = "true" ]; then
            log "DRY-RUN" "Would add replication to region: $region"
            continue
        fi
        
        log "INFO" "Adding geo-replication to region: $region"
        
        # Check if replication already exists
        if az acr replication show --registry "$acr_name" --name "$region" --resource-group "$rg_name" >/dev/null 2>&1; then
            log "INFO" "Replication already exists in: $region"
        else
            az acr replication create \
                --registry "$acr_name" \
                --resource-group "$rg_name" \
                --location "$region" \
                --output none
            log "INFO" "Replication created in: $region"
        fi
    done
    
    # Wait for replications to be ready
    if [ "$DRY_RUN" = "false" ]; then
        log "INFO" "Waiting for replications to become ready..."
        sleep 5
        
        for region in "${REGION_ARRAY[@]}"; do
            region=$(echo "$region" | tr -d '[:space:]')
            local status
            status=$(az acr replication show \
                --registry "$ACR_NAME" \
                --name "$region" \
                --resource-group "$rg_name" \
                --query "status" -o tsv 2>/dev/null || echo "unknown")
            log "INFO" "Region $region status: $status"
        done
    fi
}

get_credentials() {
    local rg_name="$1"
    local acr_name="$2"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would retrieve ACR credentials"
        return 0
    fi
    
    log "INFO" "Retrieving ACR credentials..."
    
    local username password
    username=$(az acr credential show \
        --name "$acr_name" \
        --resource-group "$rg_name" \
        --query "username" -o tsv)
    
    password=$(az acr credential show \
        --name "$acr_name" \
        --resource-group "$rg_name" \
        --query "passwords[0].value" -o tsv)
    
    echo ""
    echo "=========================================="
    echo "ACR Credentials:"
    echo "=========================================="
    echo "Login Server: ${acr_name}.azurecr.io"
    echo "Username: $username"
    echo "Password: $password"
    echo "=========================================="
    echo ""
    echo "To login:"
    echo "  docker login ${acr_name}.azurecr.io"
    echo ""
}

verify_deployment() {
    local rg_name="$1"
    local acr_name="$2"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would verify ACR deployment"
        return 0
    fi
    
    log "INFO" "Verifying ACR deployment..."
    
    local login_server provisioning_state
    login_server=$(az acr show \
        --name "$acr_name" \
        --resource-group "$rg_name" \
        --query "loginServer" -o tsv)
    
    provisioning_state=$(az acr show \
        --name "$acr_name" \
        --resource-group "$rg_name" \
        --query "provisioningState" -o tsv)
    
    log "INFO" "ACR Login Server: $login_server"
    log "INFO" "Provisioning State: $provisioning_state"
    
    # Check geo-replications
    if [ "$SKU" = "Premium" ]; then
        local replication_count
        replication_count=$(az acr replication list \
            --registry "$acr_name" \
            --resource-group "$rg_name" \
            --query "length(@)" -o tsv)
        log "INFO" "Geo-replications: $replication_count"
    fi
    
    log "INFO" "ACR deployment verified successfully"
}

cleanup() {
    local rg_name="$1"
    local acr_name="$2"
    local delete_rg="${DELETE_RESOURCE_GROUP:-false}"
    
    log "INFO" "Cleaning up ACR deployment..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log "DRY-RUN" "Would delete ACR: $acr_name"
        if [ "$delete_rg" = "true" ]; then
            log "DRY-RUN" "Would delete resource group: $rg_name"
        fi
        return 0
    fi
    
    # Delete ACR
    if az acr show --name "$acr_name" --resource-group "$rg_name" >/dev/null 2>&1; then
        log "INFO" "Deleting ACR: $acr_name"
        az acr delete \
            --name "$acr_name" \
            --resource-group "$rg_name" \
            --yes
        log "INFO" "ACR deleted successfully"
    else
        log "WARN" "ACR not found: $acr_name"
    fi
    
    # Optionally delete resource group
    if [ "$delete_rg" = "true" ]; then
        log "INFO" "Deleting resource group: $rg_name"
        az group delete --name "$rg_name" --yes --no-wait
        log "INFO" "Resource group deleted"
    fi
}

status_check() {
    local rg_name="$1"
    local acr_name="$2"
    
    log "INFO" "Checking ACR status..."
    
    if ! az acr show --name "$acr_name" --resource-group "$rg_name" >/dev/null 2>&1; then
        log "ERROR" "ACR not found: $acr_name"
        return 1
    fi
    
    local status
    status=$(az acr show \
        --name "$acr_name" \
        --resource-group "$rg_name" \
        --query "provisioningState" -o tsv)
    
    log "INFO" "ACR Status: $status"
    
    if [ "$status" = "Succeeded" ]; then
        log "INFO" "ACR is healthy"
        return 0
    else
        log "ERROR" "ACR is not healthy"
        return 1
    fi
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN="true"; shift ;;
            --resource-group) RESOURCE_GROUP="$2"; shift 2 ;;
            --acr-name) ACR_NAME="$2"; shift 2 ;;
            --location) LOCATION="$2"; shift 2 ;;
            --sku) SKU="$2"; shift 2 ;;
            --replication) REPLICATION_REGIONS="$2"; shift 2 ;;
            --admin-enabled) ADMIN_ENABLED="true"; shift ;;
            --public-access) PUBLIC_NETWORK_ACCESS="$2"; shift 2 ;;
            -h|--help) usage ;;
            *) log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done
    
    check_dependencies
    check_acr_name
    
    log "INFO" "Starting ACR deployment..."
    log "INFO" "Resource Group: $RESOURCE_GROUP"
    log "INFO" "ACR Name: $ACR_NAME"
    log "INFO" "Location: $LOCATION"
    log "INFO" "SKU: $SKU"
    log "INFO" "Replication Regions: $REPLICATION_REGIONS"
    log "INFO" "Dry Run: $DRY_RUN"
    
    # Create resource group
    create_resource_group "$RESOURCE_GROUP" "$LOCATION"
    
    # Create ACR
    create_acr "$RESOURCE_GROUP" "$ACR_NAME" "$LOCATION" "$SKU" "$ADMIN_ENABLED" "$PUBLIC_NETWORK_ACCESS"
    
    # Configure geo-replication
    if [ "$SKU" = "Premium" ]; then
        configure_geo_replication "$RESOURCE_GROUP" "$ACR_NAME" "$REPLICATION_REGIONS"
    fi
    
    # Get credentials (if admin enabled)
    if [ "$ADMIN_ENABLED" = "true" ]; then
        get_credentials "$RESOURCE_GROUP" "$ACR_NAME"
    fi
    
    # Verify deployment
    verify_deployment "$RESOURCE_GROUP" "$ACR_NAME"
    
    log "INFO" "ACR deployment completed successfully!"
    log "INFO" "ACR URL: https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.ContainerRegistry%2Fregistries"
}

main "$@"