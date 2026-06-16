# Configuring Vault's dev server — what I learned

I had already started Vault in dev mode (`vault server -dev`) a few times for the primer and the getting-started tutorial, but I never actually looked at what flags the dev server accepts or how to customize it for different learning scenarios. Here is what I found when I spent an afternoon poking at it.

## Steps

### 1. Fixed root token for repeatable sessions

By default `vault server -dev` prints a random root token each time. Setting it explicitly means I can reuse scripts without copy-pasting:

```bash
vault server -dev -dev-root-token-id=root
```

Now the root token is always `root`. That is not something you would do outside a dev environment, but it saves time when you are rewriting the same `vault login` command over and over.

### 2. Changing the listen address

Dev mode binds to `127.0.0.1:8200` by default. If I want other machines on my network to reach it (for example, to test a remote client), I can change the address:

```bash
vault server -dev -dev-listen-address=0.0.0.0:8200
```

Without this, any remote client connection fails with a connection refused error. I spent a few minutes wondering why a container on the same Docker network could not reach the dev server before I realised dev mode is loopback-only by design.

### 3. Enabling engines at startup

Dev mode enables the KV v2 engine at `secret/` automatically, but I wanted to test with multiple engines without running extra `vault secrets enable` commands every time. There is no built-in flag for that in dev mode — the docs suggest writing a startup script or using the API after the server starts. I wrote a small init script for my second session:

```bash
vault server -dev -dev-root-token-id=root &
sleep 1
export VAULT_ADDR=http://127.0.0.1:8200
vault login root
vault secrets enable -path=transit transit
vault secrets enable -path=pki pki
```

That gave me KV, transit, and PKI engines without manual steps. The ordering matters — the server needs to be ready before you call the API.

### 4. Storage is in-memory only

Dev mode stores everything in memory. That means a restart wipes all secrets, policies, and engine mounts. This is great for throwaway experiments but caught me when I expected a second run to still have yesterday's data. There is no way to change the storage backend in dev mode — you have to switch to a proper configuration file for that.

## Got stuck on

- **Token env var**: I kept typing `VAULT_TOKEN` instead of `VAULT_ADDR` and wondering why the CLI could not connect. The tutorial mentions the env vars but the dev mode output shows the root token so prominently that I kept thinking I needed to paste it somewhere before the login command, not set the address first.
- **Port already in use**: If I forgot to kill the previous dev server, the next `vault server -dev` would fail with a bind error. `lsof -i :8200` became my friend.
- **No TLS in dev mode**: Dev mode uses HTTP, not HTTPS. That is fine for a local VM but I tried pointing a test application at it from another machine and the HTTP-only assumption broke. The API still works but you need to trust the network.

## What I'd try next

Now that I understand the dev server constraints, I want to try running Vault with a proper config file using the file storage backend so secrets survive a restart. After that I want to experiment with the transit engine for encrypting application data without exposing the key.
