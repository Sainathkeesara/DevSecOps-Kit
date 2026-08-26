---
last_verified: 2026-08-26
tool_version: n/a
sources: []
---

# Install HashiCorp Vault and run my first command

Downloaded the Vault binary from releases and put it in my PATH. Checked with `vault version` — it printed the build, so we're good.

## Starting the dev server

The fastest way to see Vault work is dev mode:

```bash
vault server -dev
```

This dumps a root token and a dev-mode unseal key to the terminal. I copied the root token immediately — you need it for every other command.

In a second terminal I set the address and logged in:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault login <root-token>
```

## My first command: reading a secret

I tried `vault kv get secret/myapp` before enabling the KV engine and got a "no secret engine at secret/" error. Had to enable it first:

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/myapp username=admin password=changeme
vault kv get secret/myapp
```

That worked. The output shows the secret data under `data.data` — Vault wraps everything in a metadata envelope.

## What tripped me up

- **Forgot `VAULT_ADDR`**: every command fails with "dial tcp 127.0.0.1:443: connect: connection refused" if the env var isn't set. Dev mode listens on 8200, not 443.
- **Confused sealed vs initialized**: dev mode starts unsealed automatically. In a real setup you unseal with key shares — I didn't realize dev mode skips that until I read the logs.
- **KV v1 vs v2**: `vault kv get` works differently between v1 and v2. v2 wraps data in `data.data`; v1 is flat. I wasted time debugging output format before realizing I'd enabled v2.

## What I'll cover next

Now that I can read and write secrets, I want to try policies and AppRole auth — restricting what a specific role can access instead using the root token for everything.
