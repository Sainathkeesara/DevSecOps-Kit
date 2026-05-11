# Azure Container Registry (ACR) Installation and Geo-Replication

## Purpose

Deploy and configure Azure Container Registry (ACR) with geo-replication for multi-region container image distribution. This guide covers ACR creation via Azure CLI, geo-replication configuration, authentication setup, network access controls, and image management operations.

## When to use

- Hosting private container images for Azure Kubernetes Service (AKS), Azure App Service, or Azure Container Instances
- Requiring multi-region image replication for disaster recovery and low-latency deployments
- Implementing CI/CD pipelines that push images to a centralized registry
- Meeting compliance requirements for container image storage in specific Azure regions
- Setting up geo-replicated registries for global application deployments

## Prerequisites

- Azure subscription with contributor or owner access
- Azure CLI installed (version 2.50.0 or later): `az --version`
- Resource group created in Azure
- For geo-replication: Azure subscription must support container registries in target regions
- Optional: Terraform for infrastructure-as-code deployments

## Steps

### Step 1: Install Azure CLI and authenticate

If Azure CLI is not installed:

```bash
# Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# macOS
brew install azure-cli

# Verify installation
az --version
```

Authenticate to Azure:

```bash
az login
# Or using a service principal for automation
az login --service-principal -u <app-id> -p <password> --tenant <tenant-id>
```

### Step 2: Create Azure Container Registry

```bash
# Define variables
RESOURCE_GROUP="rg-container-registry"
LOCATION="eastus"
ACR_NAME="acrdemo001"
SKU="Premium"  # Standard, Premium (required for geo-replication)

# Create resource group if it doesn't exist
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Create ACR with geo-replication capability (Premium SKU)
az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$ACR_NAME" \
  --sku "$SKU" \
  --location "$LOCATION" \
  --admin-enabled true \
  --output table

# Verify ACR creation
az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP" --query "loginServer"
```

The `--admin-enabled` flag creates an admin user with username and auto-generated password. For production, use service principals instead.

### Step 3: Configure geo-replication

Premium SKU supports geo-replication. Replicate to additional Azure regions:

```bash
# Add geo-replication to West Europe
az acr replication create \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "westeurope"

# Add geo-replication to Southeast Asia
az acr replication create \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "southeastasia"

# Add geo-replication to West US 2
az acr replication create \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "westus2"

# List all replications
az acr replication list \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --output table

# Check replication status
az acr replication show \
  --registry "$ACR_NAME" \
  --name "westeurope" \
  --resource-group "$RESOURCE_GROUP" \
  --query "status"
```

The ACR automatically replicates images to all regions. You can also enable zone redundancy for high availability in regions that support it:

```bash
# Enable zone redundancy (requires Premium SKU in supported regions)
az acr update \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --zone-redundant true
```

### Step 4: Configure authentication

#### Option A: Service Principal (Recommended for production)

```bash
# Create a service principal with pull/push permissions
ACR_SP=$(az ad sp create-for-rbac \
  --name "acr-service-principal" \
  --role acrpush \
  --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.ContainerRegistry/registries/$ACR_NAME" \
  --query "appId" -o tsv)

ACR_PASSWORD=$(az ad sp credential reset \
  --id "$ACR_SP" \
  --query "passwords[0].value" -o tsv)

echo "Service Principal App ID: $ACR_SP"
echo "Service Principal Password: $ACR_PASSWORD"

# Login using service principal
docker login "$ACR_NAME.azurecr.io" -u "$ACR_SP" -p "$ACR_PASSWORD"
```

#### Option B: Admin user (Development/Testing only)

```bash
# Get admin credentials
ACR_USERNAME=$(az acr credential show \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "username" -o tsv)

ACR_PASSWORD=$(az acr credential show \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "passwords[0].value" -o tsv)

echo "Username: $ACR_USERNAME"
echo "Password: $ACR_PASSWORD"

# Login
docker login "$ACR_NAME.azurecr.io" -u "$ACR_USERNAME" -p "$ACR_PASSWORD"
```

### Step 5: Configure network access

By default, ACR is accessible from all networks. Restrict access:

```bash
# Enable admin user first (required for some operations)
az acr update \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --admin-enabled true

# Allow access from specific IP ranges (CIDR notation)
az acr network-rule add \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --ip-address "203.0.113.0/24"

# Or allow access from specific virtual network/subnet
az network vnet subnet show \
  --resource-group "rg-vnet" \
  --vnet-name "vnet-aks" \
  --name "subnet-aks" \
  --query "id"

# Add VNet rule
# First create the vnet if needed
az network vnet create \
  --name "vnet-acr" \
  --resource-group "$RESOURCE_GROUP" \
  --address-prefix 10.0.0.0/16

az network vnet subnet create \
  --name "subnet-acr" \
  --resource-group "$RESOURCE_GROUP" \
  --vnet-name "vnet-acr" \
  --address-prefix 10.0.1.0/24

# Register ACR with VNet
az acr network-rule add \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --subnet-id "/subscriptions/xxx/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/vnet-acr/subnets/subnet-acr"

# Disable public access (requires private endpoint setup)
az acr update \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --public-network-access disabled
```

### Step 6: Push and pull images

```bash
# Pull a base image
docker pull nginx:1.25

# Tag for ACR
docker tag nginx:1.25 "$ACR_NAME.azurecr.io/library/nginx:1.25"

# Push to ACR (automatically replicated to all regions)
docker push "$ACR_NAME.azurecr.io/library/nginx:1.25"

# Pull from ACR (will pull from closest region)
docker pull "$ACR_NAME.azurecr.io/library/nginx:1.25"

# List repositories
az acr repository list \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --output table

# List tags for a repository
az acr repository show-tags \
  --name "$ACR_NAME" \
  --repository "library/nginx" \
  --output table

# Verify geo-replication is working - check which region responded
docker pull "$ACR_NAME.azurecr.io/library/nginx:1.25"
# The image will be served from the nearest Azure region
```

### Step 7: Configure webhook for CI/CD

```bash
# Create webhook for image push events
az acr webhook create \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --name "webhook-cicd" \
  --uri "https://your-cicd-webhook.example.com/webhook" \
  --actions "push" \
  --scope "library/*"

# List webhooks
az acr webhook list \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --output table

# Test webhook
az acr webhook ping \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --name "webhook-cicd"

# View webhook events
az acr webhook list-events \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --name "webhook-cicd" \
  --output table
```

### Step 8: Enable Azure Defender for container registry (optional security)

```bash
# Enable Azure Defender for ACR
az security pricing create \
  --name "ContainerRegistry" \
  --pricing-tier "standard"

# Or via Defender for Cloud in the Azure portal
```

### Step 9: Configure retention policy

```bash
# Set retention policy for untagged manifests (30 days)
az acr config retention update \
  --registry "$ACR_NAME" \
  --enabled true \
  --days 30

# Show current retention settings
az acr config retention show \
  --registry "$ACR_NAME"
```

## Verify

1. Check ACR status:

```bash
az acr show \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "{Status:provisioningState, SKU:skuName, LoginServer:loginServer}"
```

2. Verify geo-replications are healthy:

```bash
az acr replication list \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[].{Region:name, Status:status}"
```

3. Test image push and pull:

```bash
# Push a test image
docker tag alpine:latest "$ACR_NAME.azurecr.io/test/alpine:latest"
docker push "$ACR_NAME.azurecr.io/test/alpine:latest"

# Pull from different regions (should auto-route)
docker pull "$ACR_NAME.azurecr.io/test/alpine:latest"

# Check which region served the request
az acr repository show \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --repository "test/alpine" \
  --query "manifests[0].digest"
```

4. Test webhook:

```bash
# Trigger a push and check webhook status
az acr webhook list-events \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --name "webhook-cicd"
```

## Rollback

### Remove geo-replication:

```bash
# Remove replication from a region
az acr replication delete \
  --registry "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --name "westeurope"
```

### Delete ACR:

```bash
# Delete the registry (including all replications)
az acr delete \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP"

# Confirm deletion
az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP"
# Should return: ResourceNotFound
```

### Restore from backup:

ACR does not support native backup/restore. For disaster recovery:
- Push images to a secondary ACR in a different region
- Use Azure Backup for ACR (in preview) or third-party backup solutions
- Set up replication to a secondary registry

## Common errors

### Error: The subscription is not registered for Microsoft.ContainerRegistry

**Symptom:** `The subscription 'xxx' is not registered for Microsoft.ContainerRegistry`

**Solution:** Register the resource provider:

```bash
az provider register --namespace Microsoft.ContainerRegistry
```

### Error: SkuNotAllowed when creating Premium ACR

**Symptom:** `The sku 'Premium' is not allowed for this subscription`

**Solution:** Your subscription doesn't support Premium tier. Use Standard SKU or contact Azure support to enable Premium.

### Error: Geo-replication region not available

**Symptom:** `The location 'xxx' is not available for replication`

**Solution:** ACR geo-replication is not available in all regions. Check Azure documentation for supported regions or choose a different region.

### Error: Image pull fails with "region not available"

**Symptom:** `Failed to pull image: region not available in geo-replicated registry`

**Solution:** The image was pushed to a region that's no longer available or replication is still in progress. Push the image again to force replication.

### Error: Authentication failed

**Symptom:** `Error response from daemon: unauthorized: authentication required`

**Solution:** 
- Check credentials are correct: `az acr credential show`
- Verify service principal has correct role (acrpush or acrpull)
- Token may have expired; re-login: `docker login`

## References

- [Azure Container Registry documentation](https://docs.microsoft.com/azure/container-registry/)
- [ACR geo-replication](https://docs.microsoft.com/azure/container-registry/container-registry-geo-replication)
- [ACR authentication](https://docs.microsoft.com/azure/container-registry/container-registry-authentication)
- [ACR network access](https://docs.microsoft.com/azure/container-registry/container-registry-access-prerequisites)
- [Azure CLI ACR commands](https://docs.microsoft.com/cli/azure/acr)