# Installing OPA and exploring the REPL

I installed OPA from the official GitHub releases. Downloaded the binary, made it executable, and moved it to `/usr/local/bin`:

```bash
curl -sL https://openpolicyagent.org/downloads/latest/opa_linux_amd64 -o opa
chmod +x opa
sudo mv opa /usr/local/bin/
```

Then I ran `opa run` to start the interactive REPL. This is where I tried my first policy:

```
> pi = 3.14
> pi > 3
true
> x = [1, 2, 3]; y = [4, 5, 6]
> z = array.concat(x, y)
> z
[1, 2, 3, 4, 5, 6]
```

OK so Rego is essentially Datalog with JSON support. I defined some data and queried it.

Next I tried the `opa eval` CLI to evaluate a policy without the REPL:

```bash
opa eval "1 + 2 * 3"
```

That returned `7`. Simple arithmetic works like you'd expect.

## What tripped me up

1. The REPL doesn't use `=` for assignment everywhere. You use `:=` for local vars and `=` for unification. I kept getting syntax errors until I realized that.
2. `opa eval` needs the `--format pretty` flag by default, but I wanted JSON output and had to add `--format json`.
3. The REPL is session-only — close it and everything is gone. I assumed saved policies would persist. They don't. You need `opa run --watch` with a file for that.

## What I'd try next

Write a real Rego policy that checks a Kubernetes Pod manifest and run it through `opa eval` with sample data.
