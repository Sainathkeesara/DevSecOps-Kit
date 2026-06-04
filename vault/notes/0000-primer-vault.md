# HashiCorp Vault — quick primer

> First-day notes. I'm writing this as I learn the tool.

## What is it?

HashiCorp Vault manages secrets — API keys, DB passwords, certs. It's like a password manager but for infrastructure.

## What does it do?

Stores secrets, controls who reads them, logs every access. You use a CLI, API, or web UI. An app asks Vault for a DB password instead of reading a config file.

## Why does it exist?

Teams used to put secrets in config files or env vars — one leak and everything's exposed. Vault centralizes secrets with policies, audit logs, and rotation. Ops teams use it daily to stop spreading secrets around.

## Key terminology

- **Secret** — any sensitive value. Example: a DB password stored at `secret/data/app/db`.
- **Path** — Vault organizes secrets like files. Example: `secret/data/app/*`.
- **Policy** — access rules for paths. Example: `path "secret/data/app/*" { capabilities = ["read"] }`.
- **Token** — main auth method. Example: `vault login s.abc123...`.
- **Seal/Unseal** — Vault starts sealed; you unseal with key shares. Example: 5 shares, need 3 to unseal.
- **Engine** — backend type: kv-v2 (key-value), pki (certs), transit (encryption).

## A tiny example

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/app/db username=admin password=s3cret
vault kv get secret/app/db
```

Three commands: enable KV storage, write a secret, read it back.

## What I'll cover next

Install Vault in dev mode, then wire a Python app to read a secret. After that, policies and dynamic secrets.
