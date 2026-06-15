# Following the OPA getting-started tutorial — what tripped me up

I followed the official OPA getting-started tutorial at openpolicyagent.org. Here's what worked and what broke.

## Setting up

Downloaded OPA and started the server:

```bash
./opa run --server --set=decision_logs.console=true
```

That starts OPA listening on `:8181`. I created a policy file `policy.rego`:

```rego
package httpapi.authz

default allow = false

allow {
    input.method == "GET"
}

allow {
    input.method == "POST"
    input.path == ["finance", "salary", input.user]
}
```

Then I loaded it via the REST API:

```bash
curl -s -X PUT --data-binary @policy.rego \
  localhost:8181/v1/policies/httpapi
```

It returned `{}` which I think means success — the docs don't say.

## Testing decisions

I sent a test request:

```bash
curl -s -X POST localhost:8181/v1/data/httpapi/authz \
  -d '{"input": {"method": "GET", "user": "bob", "path": ["finance", "salary", "bob"]}}'
```

Result: `{"result":{"allow":true}}` — GET is allowed, that worked.

Then I tried POST with a mismatched user:

```bash
curl -s -X POST localhost:8181/v1/data/httpapi/authz \
  -d '{"input": {"method": "POST", "user": "alice", "path": ["finance", "salary", "bob"]}}'
```

Got `{"result":{"allow":false}}` — blocked because the path's user segment was "bob" not "alice". That's the rule working.

## Got stuck on

1. **The tutorial has a typo in one curl example** — the `--data-binary` flag is misspelled as `--data-binary` in one place but it's actually `--data-binary` which is correct... wait, no. The actual flag is `--data-binary` or `-d` for data. One of the examples uses `--data-binary` when `-d` would have been fine. Small thing but confusing when you're copying commands.

2. **Loading policies via API vs directory** — The tutorial loads a policy via PUT, but `opa run --set=...` can also load a directory with `--set=policies=<path>`. It took me a few tries to understand which approach worked for what.

3. **The REST API path for data queries** — The URL scheme is `/v1/data/<package.path>` but I kept expecting `/v1/data/<package>.<path>` with dots. The tutorial shows it but it didn't click until I got a 404.

4. **Decision logs** — I started the server with `--set=decision_logs.console=true` and still didn't see logs. Turns out you need at least one policy loaded before the server starts logging decisions.

## What I'd try next

I want to run the same policies against actual Kubernetes admission review data and see how Gatekeeper translates them. Also curious about the `opa test` command for unit-testing rego policies.
