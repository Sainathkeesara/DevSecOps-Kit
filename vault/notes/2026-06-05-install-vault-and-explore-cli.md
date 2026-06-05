# Installing Vault and poking around the CLI

I downloaded Vault from hashicorp.com and dropped the binary in my PATH. Ran `vault` to check — got the help output, so it's there.

Starting in dev mode is the fastest way to see it work:

```bash
vault server -dev
```

That prints a root token and an unseal key. Opened another terminal and set:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault login <root-token-from-output>
```

Logged in. Ran `vault status` — saw it's initialized and unsealed. Dev mode does that automatically.

Tried reading the KV store from the primer:

```bash
vault kv get secret/app/db
```

Got a permission error at first — forgot I hadn't enabled the KV engine yet. Did:

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/app/db username=admin password=s3cret
vault kv get secret/app/db
```

That worked. The output shows metadata (version, created_time) plus the actual data.

Things I tripped on:
- Dev mode only listens on loopback — accessible for local learning but not much else
- The root token from the log output changes each restart, which makes sense but caught me
- `vault kv get` needs the full path, not just the mount name

Next I want to try setting up policies and maybe try the web UI.
