# Vault getting-started tutorial — my trip-ups

I followed the official HashiCorp Vault getting-started tutorial after already installing Vault once and poking around the CLI. I skipped the install section because I had a working `vault` binary, then tried to treat the tutorial like a clean first run. That caused a few small confusions, but it also helped me see what Vault is trying to teach.

## Steps that worked

I started the dev server:

```bash
vault server -dev
```

Then I opened a second terminal and pointed the CLI at it:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault login <root-token>
```

The first part of the tutorial is KV storage. I enabled the KV v2 engine, wrote a value, and read it back:

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/hello foo=world
vault kv get secret/hello
```

That part felt straightforward. The table output is readable, and `-format=json` makes the same data easier for scripts to parse.

The policy section was the first part that clicked for me. I created `app-policy.hcl` with a narrow read/list rule:

```hcl
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}
```

Then I wrote the policy and created a token from it:

```bash
vault policy write app app-policy.hcl
vault token create -policy=app
```

Using that new token, I could read under `secret/data/app/` but not under `secret/data/admin/`. That made policies feel less abstract: they are path rules attached to a token.

## Got stuck on

- Dev mode already has a few built-in engines, like `cubbyhole/` and `identity/`. The tutorial mostly talks about the `secret/` mount, so I briefly thought my policy was broken when a built-in path still worked. It was not broken; I was just comparing my policy to paths outside that policy's scope.
- Vault token flags are easy to mix up. `-policy=app` worked for me, and the help text also mentions `-policies` as a comma-separated form. I wrote down both forms so I do not have to guess next time.
- I tried revoking the dev root token like the tutorial suggests. That immediately locked me out of the running dev server, and I had to restart it to get a fresh root token. It is fine for a throwaway dev session, but it made the token model feel much more real.
- JSON output added another layer. `vault kv get secret/hello` is easy to read, but `vault kv get -format=json secret/hello` wraps the actual secret under `data.data` and keeps version metadata under `data.metadata`. I need to remember that when writing scripts.

## What I'd try next

Next I want to try the transit engine so Vault can encrypt and decrypt values without handing the application the raw key. I also want to test what happens when one token has multiple policies attached, especially where an allow and deny overlap.
