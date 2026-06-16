# Following the Vault getting-started tutorial — what tripped me up

I went through the official HashiCorp Vault getting-started tutorial on developer.hashicorp.com. I'd already installed Vault and poked around the CLI a bit, so I skipped the install step and jumped straight into the guided tutorial.

## Steps that worked

Started the dev server as before:

```bash
vault server -dev
```

In another terminal, set the address and logged in with the root token from the dev output:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault login <root-token>
```

The tutorial then walked through enabling the KV secrets engine — I'd already done this, so that was smooth:

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/hello foo=world
vault kv get secret/hello
```

The tutorial moved into policies next. I created a policy file `app-policy.hcl`:

```hcl
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}
```

Wrote it:

```bash
vault policy write app app-policy.hcl
```

Created a token scoped to that policy:

```bash
vault token create -policy=app
```

Using that token, I could read `secret/data/app/db` but not `secret/data/admin/db` — the policy did what it said.

## Got stuck on

- The tutorial uses `secret/` mount path in policy examples, but dev mode also ships with a built-in `cubbyhole/` and `identity/` engine that aren't mentioned. I spent a few minutes wondering if my policy was wrong when `vault kv get cubbyhole/test` still worked — no, it's just that cubbyhole has its own implicit existence and isn't governed by the same path rules.
- Token flags were confusing: `-policy` (singular, repeatable) vs `- policies` (plural, comma-separated). I used `-policy=app` and it worked, but the help output mentions both forms inconsistently.
- Revoking the root token by accident: the tutorial suggested experimenting with token revocation. I ran `vault token revoke <root-token>` and immediately lost all access. Had to restart the dev server to get a new root token. That's fine for a dev session, but it drove home how careful you'd need to be in a real setup.
- The `vault kv get` output format changed when I added `-format=json` — the JSON structure wraps data differently than the table view. Took a second to parse the nested `data.data` vs `data.metadata` fields.

## What I'd try next

Set up a transit engine to encrypt data without exposing the key, then try wrapping a token for secure delivery. Also want to figure out how policies compose when a token has multiple policies attached.