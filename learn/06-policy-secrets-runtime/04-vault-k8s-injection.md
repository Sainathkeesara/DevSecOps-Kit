---
last_verified: 2026-11-16
tool_version: "v2.2.2"
sources:
  - https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2
  - https://developer.hashicorp.com/vault/docs/commands/kv/put
  - https://developer.hashicorp.com/vault/docs/auth/kubernetes
  - https://developer.hashicorp.com/vault/tutorials/kubernetes-introduction/agent-kubernetes
  - https://developer.hashicorp.com/vault/docs/agent-and-proxy/autoauth/methods/kubernetes
  - https://github.com/hashicorp/vault/releases
---

# Deliver the app's secrets from Vault

In the previous lesson you deployed the sample app on kind and watched Argo CD converge the cluster. The app still reads its database password from a Kubernetes Secret or a config file — the very pattern the secrets-access-management primer warns about. This lesson moves that password into HashiCorp Vault and delivers it to the app at runtime through Vault Agent, so nothing secret lives in Git or in a Kubernetes Secret object.

## What you'll learn

- Enable KV v2 in Vault and store the database password at a versioned path
- Enable Kubernetes auth, bind a service account to a Vault role and policy, and inject the secret with Vault Agent
- Confirm the secret reaches the app at runtime and is absent from Git and from Kubernetes Secret objects

## Before you start

- [HashiCorp Vault — quick primer](../../vault/notes/0000-primer-vault.md) — Vault's KV engines, policies, and the `/data/` vs `/metadata/` path split for KV v2.
- [Secrets & Access Management — concepts](../../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md) — least-privilege access and service accounts, the model this lesson binds to Vault roles.
- [Deploy and debug the sample app on kind](../05-kubernetes-gitops/02-k8s-deploy-sample-app.md) — kubectl, Deployments, and a running kind cluster where Vault can reach the Kubernetes API.
- Vault binary installed: `vault version` prints `v2.2.2`.
- Vault running and reachable from the kind cluster (port-forward Vault or the kind API if Vault runs on your laptop).

## Walkthrough

### 1. Enable KV v2 and store the database password

KV v2 keeps every version of a secret (up to 10 by default) and stores data under `secret/data/<path>`, while policies and ACLs address the full `/data/` path. Enable it at the `secret` mount:

```bash
vault secrets enable -version=2 -path=secret kv
```

You should see: `Success! Enabled the kv secrets engine at: secret/`

Write the database password:

```bash
vault kv put -mount=secret app/db password="db-s3cr3t-123" username="app"
```

You should see: a `Key / Value` table with `version: 1` written to `secret/data/app/db`.

Create a read-only policy for the app. KV v2 requires the `/data/` prefix for data reads and `/metadata/` for listing:

```hcl
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}

path "secret/metadata/app/*" {
  capabilities = ["list"]
}
```

```bash
vault policy write app-policy app-policy.hcl
```

This mirrors the `/data/` path rule in `vault/configs/2026-06-26-dev-test-policies.hcl`. A common mistake is writing `secret/app/db` (KV v1 style) and wondering why reads return nothing — KV v2 lives at `secret/data/<path>`.

### 2. Enable Kubernetes auth and bind the app's service account

Enable the Kubernetes auth method:

```bash
vault auth enable kubernetes
```

Point Vault at the Kubernetes API so it can verify pod service-account JWTs:

```bash
vault write auth/kubernetes/config \
  kubernetes_host="https://127.0.0.1:6443" \
  kubernetes_ca_cert=@/path/to/ca.crt \
  token_reviewer_jwt="$(cat /path/to/reviewer-token)"
```

Replace `127.0.0.1:6443` with your kind control-plane endpoint. When Vault runs outside the cluster, the `token_reviewer_jwt` must come from a service account that has `TokenReview` access (granted through a ClusterRoleBinding) — the platform team runs this step once.

Create a role that admits only the sample app's service account in `default` and hands it the `app-policy`:

```bash
vault write auth/kubernetes/role/app-role \
  bound_service_account_names=sample-app \
  bound_service_account_namespaces=default \
  policies=app-policy \
  ttl=1h
```

The role's `audience` must match the `aud` of the service-account JWT, or authentication returns 403.

### 3. Deliver the secret with Vault Agent

Vault Agent authenticates as the app's service account, receives a short-lived token, and renders the secret into a file the app container reads. Configure the agent (mounted as a ConfigMap):

```hcl
pid_file = "/tmp/agent-pid"

auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config {
      role = "app-role"
    }
  }

  sink "file" {
    config {
      path = "/home/vault/.vault-token"
    }
  }
}

template {
  destination = "/etc/secrets/db-password"
  contents = <<EOH
{{ with secret "secret/data/app/db" }}
DB_PASSWORD={{ .Data.data.password }}
{{ end }}
EOH
}
```

The `{{ .Data.data.password }}` is the KV v2 shape — data nests under `.Data.data`. The agent re-renders the template when the secret changes, so rotated passwords reach the app without a restart.

Deploy the sample app with the Vault Agent sidecar. Both containers share an `emptyDir` volume, so the app reads `/etc/secrets/db-password` after the agent writes it:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sample-app-vault
spec:
  serviceAccountName: sample-app
  containers:
    - name: app
      image: sample-app:latest
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

The complete sidecar pattern (ConfigMap, service account, ClusterRoleBinding for TokenReview) is in `vault/docs/vault-agent-auto-auth-kubernetes.md` — link there rather than repeat it.

### 4. Confirm the secret arrives at runtime — and nowhere else

```bash
kubectl apply -f sample-app-vault.yaml
kubectl logs sample-app-vault vault-agent
```

You should see: `Successfully authenticated to Vault with the Kubernetes auth method`

```bash
kubectl exec sample-app-vault -- cat /etc/secrets/db-password
```

You should see: `DB_PASSWORD=db-s3cr3t-123` — rendered from Vault at runtime.

Now confirm nothing leaked:

```bash
git log --all -p -S "db-s3cr3t-123" --oneline
```

You should see: no commits — the password was never committed.

```bash
kubectl get secrets -n default | grep sample-app
```

You should see: nothing — no Kubernetes Secret holds the password.

## Exercise

Working alone:

1. Enable KV v2 at a second mount (for example `-path=ops kv`) and write a cache key there, e.g. `vault kv put -mount=ops app/cache key="cache-s3cr3t"`.
2. Create a read-only policy for `secret/data/ops/app/*` and a Kubernetes auth role bound to the `sample-app` service account with that policy. Reuse the `/data/` + `/metadata/` path split from Step 1.
3. Point Vault Agent at the new path so it renders `cache-s3cr3t` into `/etc/secrets/cache-key` alongside `db-password`, then redeploy the app.
4. Confirm the app reads the cache key at runtime, that the value is absent from `git log`, and that no `sample-app` Kubernetes Secret exists.

Do not paste the solution into the lesson file.

## Check your work

```bash
kubectl exec sample-app-vault -- cat /etc/secrets/cache-key
```

You should see: `cache-s3cr3t`.

```bash
git log --all -p -S "cache-s3cr3t" --oneline; kubectl get secrets -n default | grep cache
```

You should see: no commits and no matching Kubernetes Secret.

## Next

[Admit only signed images](../../00_index/learning-path.md)
