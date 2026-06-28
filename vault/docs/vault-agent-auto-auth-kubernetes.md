# Vault Agent auto-auth with Kubernetes service accounts

## Purpose

Vault Agent's auto-auth feature lets a pod authenticate to Vault using its Kubernetes service account, eliminating the need to distribute and rotate Vault tokens manually. This is one approach to secret delivery in Kubernetes; the docs also suggest the Vault Secrets Operator for more complex workflows.

The goal here is to wire a Kubernetes auth method in Vault, create a role that maps a service account to a Vault policy, and configure the Vault Agent sidecar to authenticate automatically and render secrets into a file.

## Steps

### 1. Enable and configure the Kubernetes auth method on Vault

First, enable the Kubernetes auth method if it is not already enabled:

```bash
vault auth enable kubernetes
```

Vault needs to validate the JWT tokens that pods present. This requires pointing Vault at the Kubernetes API:

```bash
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

When Vault runs outside the cluster, you need to provide a `token_reviewer_jwt` from a service account that has the `TokenReview` permission.

### 2. Create a role that binds a service account to a Vault policy

The role tells Vault which service accounts can authenticate and which Vault policy they receive:

```bash
vault write auth/kubernetes/role/my-app-role \
  bound_service_account_names=my-app \
  bound_service_account_namespaces=default \
  policies=my-app-policy \
  ttl=1h
```

The `bound_service_account_names` and `bound_service_account_namespaces` restrict which pods can use this role. The `policies` field attaches a Vault ACL policy. I found it easy to forget that the service account must exist in the namespace before the role will match — Vault does not validate this at write time, only at authentication time.

### 3. Define the Vault policy

Create a policy that grants access to the secrets the application needs:

```hcl
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/my-app/*" {
  capabilities = ["list"]
}
```

Write it to Vault:

```bash
vault policy write my-app-policy my-app-policy.hcl
```

The metadata path is needed for listing keys under KV v2. Without it, `vault kv list` calls from the agent will return nothing.

### 4. Configure Vault Agent with auto-auth and a template

Create a Vault Agent config file. This is mounted as a ConfigMap in the pod:

```hcl
pid_file = "/tmp/agent-pid"

auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config {
      role = "my-app-role"
    }
  }

  sink "file" {
    config {
      path = "/home/vault/.vault-token"
    }
  }
}

template {
  destination = "/etc/secrets/db-creds"
  contents = <<EOH
{{ with secret "secret/data/my-app/db" }}
DB_USERNAME={{ .Data.data.username }}
DB_PASSWORD={{ .Data.data.password }}
{{ end }}
EOH
}
```

The agent authenticates via the Kubernetes auth method, writes the resulting token to a sink file, and renders the template when the secret is available. One issue I hit: the template engine does not re-render if the secret changes at the path unless you restart the agent or use `template_config { exit_on_retry_failure = false }` with a wait interval.

### 5. Deploy the sidecar in a pod

Add Vault Agent as a sidecar container in the pod spec:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  serviceAccountName: my-app
  containers:
    - name: my-app
      image: my-app:latest
      volumeMounts:
        - name: secrets
          mountPath: /etc/secrets
          readOnly: true
    - name: vault-agent
      image: hashicorp/vault:latest
      args: ["agent", "-config=/etc/vault-agent/config.hcl"]
      volumeMounts:
        - name: vault-agent-config
          mountPath: /etc/vault-agent
        - name: secrets
          mountPath: /etc/secrets
  volumes:
    - name: vault-agent-config
      configMap:
        name: vault-agent-config
    - name: secrets
      emptyDir: {}
```

The application container reads `/etc/secrets/db-creds` after the agent writes it. Both containers share the `secrets` emptyDir volume.

## Verify

Deploy the pod and check the agent logs:

```bash
kubectl logs my-app vault-agent
```

A successful authentication shows a line like:

```
Successfully authenticated to Vault with the Kubernetes auth method
```

Check that the template was rendered:

```bash
kubectl exec my-app -- cat /etc/secrets/db-creds
```

The file should contain the resolved secret values. If the file is empty or missing, the agent logs usually indicate whether the authentication failed or the secret path was denied by the policy.
