# Thanos Installation (thanos_installation)

## Purpose

The thanos_installation guide provides steps to install and configure Thanos for long-term metric retention and high availability in a Prometheus-based monitoring stack.

## When to use

Use this guide when you need to:
- Deploy Thanos components (Sidecar, Store, Receiver, Query, Compactor) for long-term metric storage
- Configure Thanos to work with existing Prometheus servers for remote write and read
- Set up object storage (e.g., S3, GCS, Azure Blob) as the backend for Thanos
- Enable query aggregation across multiple Prometheus instances
- Implement downsampling and compaction to reduce storage costs

## Prerequisites

- Kubernetes cluster (v1.20+) with kubectl configured
- Helm v3.8+ installed
- Object storage bucket (e.g., AWS S3, Google Cloud Storage, Azure Blob Storage) created and accessible
- Prometheus server(s) already deployed and scraping metrics
- Basic understanding of Prometheus remote write and read concepts

## Steps

### 1. Add Thanos Helm Repository

```bash
helm repo add thanos https://thanos.io/charts/
helm repo update
```

### 2. Create Object Storage Secret

Create a Kubernetes secret containing your object storage credentials. Replace the placeholders with your actual credentials.

For AWS S3:
```bash
kubectl create secret generic thanos-objstore-secret \
  --from-literal=type=AWS \
  --from-literal=access_key=YOUR_ACCESS_KEY \
  --from-literal=insecure=true \
  --from-literal=secret_key=YOUR_SECRET_KEY \
  --from-literal=bucket=YOUR_BUCKET_NAME \
  --from-literal=endpoint=YOUR_ENDPOINT \
  --from-literal=region=YOUR_REGION
```

For Google Cloud Storage:
```bash
kubectl create secret generic thanos-objstore-secret \
  --from-file=service_account=YOUR_SERVICE_ACCOUNT_KEY.json \
  --from-literal=type=GCS \
  --from-literal=bucket=YOUR_BUCKET_NAME
```

### 3. Deploy Thanos Components

Create a values file (`thanos-values.yaml`) with your configuration:

```yaml
objectStorage:
  config:
    type: YOUR_STORAGE_TYPE
    config:
      # Storage-specific configuration will be loaded from the secret

sidecar:
  enabled: true
  prometheus:
    url: http://prometheus-server:9090
    # If using basic auth or TLS, configure accordingly

storeGateway:
  enabled: true

query:
  enabled: true
  httpListenAddress: 0.0.0.0:10902
  grpcListenAddress: 0.0.0.0:10901

compactor:
  enabled: true
  retention: 30d # Adjust based on your retention policy
  deleteDelay: 2h # Delay before deleting data from object storage
  deleteEnabled: true

receiver:
  enabled: true
```

Install Thanos using Helm:
```bash
helm install thanos thanos/thanos -n monitoring --create-namespace -f thanos-values.yaml
```

### 4. Configure Prometheus for Remote Write

Update your Prometheus configuration to send metrics to Thanos Sidecar:

```yaml
remote_write:
  - url: http://thanos-sidecar:10901/api/v1/write
    # Optional: add basic auth, TLS, or retry configuration
```

Reload Prometheus to apply the configuration.

### 5. Verify Installation

Check that all Thanos pods are running:
```bash
kubectl get pods -n monitoring -l app.kubernetes.io/name=thanos
```

Verify the Thanos Query endpoint is accessible:
```bash
curl http://<thanoss-query-service>:10902/api/v1/query?query=up
```

You should see metrics from your Prometheus instances.

### 6. Configure Thanos Query in Grafana (Optional)

Add Thanos Query as a data source in Grafana:
- Type: Prometheus
- URL: http://thanoss-query:10902
- Access: Proxy

## Verify

- All Thanos components (sidecar, store, receiver, query, compactor) pods are running without crashes
- Metrics are being received by Thanos Sidecar (check sidecar logs for remote write receptions)
- Thanos Store Gateway can serve metrics (query via Thanos Query API)
- Compactor is running and compacting data in the object storage bucket
- Thanos Query returns aggregated metrics from all connected Prometheus instances

## Rollback

To uninstall Thanos:
```bash
helm uninstall thanos -n monitoring
kubectl delete secret thanos-objstore-secret -n monitoring
# Optionally delete the object storage bucket if no longer needed
```

## Common errors

### 403 Forbidden from Object Storage

- Verify the credentials in the thanos-objstore-secret have sufficient permissions (read/write/list/delete) on the bucket
- For AWS S3, ensure the IAM policy allows s3:PutObject, s3:GetObject, s3:DeleteObject, s3:ListBucket
- Check that the bucket name and endpoint are correct

### No Metrics Appearing in Thanos Query

- Verify Prometheus remote_write is configured correctly and pointing to the Thanos Sidecar service
- Check Thanos Sidecar logs for errors receiving remote write requests
- Ensure the Thanos Sidecar can communicate with the object storage (check network policies and credentials)

### Compactor Failing to Compact

- Verify the compactor has delete permissions on the object storage bucket (if deleteEnabled: true)
- Check object storage lifecycle rules don't conflict with Thanos compaction
- Ensure sufficient disk space on compactor nodes for temporary compaction operations

## References

- Thanos Documentation: https://thanos.io/
- Thanos Helm Chart: https://github.com/thanos/charts/tree/main/charts/thanos
- Prometheus Remote Write: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write
- Object Storage Credentials Examples: https://thanos.io/thanos/storage.md