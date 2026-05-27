# Installing TruffleHog and scanning a local repo

I installed TruffleHog to try finding leaked secrets in a test repo. Here's how it went.

**Install**
I used pip since I already have Python:

```
pip install trufflehog
```

That worked — `trufflehog --version` showed v3.84.2 or something. There's also a Docker image (`docker run trufflesecurity/trufflehog`) and a GitHub Action, but pip was fastest.

**First scan**
I set up a quick test: created a new repo, added a file with a fake AWS key in it, committed it, and ran:

```
trufflehog git --since-commit HEAD file:///tmp/test-repo
```

Wait — that gave me nothing. I realized `--since-commit HEAD` only checks the _current_ commit, but I wanted it to find the secret that was already committed. Dropping `--since-commit` scanned the whole history and found it.

**What tripped me up**

- `trufflehog git` needs a `file://` URL for local repos. I kept trying a plain path at first.
- The output is JSON by default. Add `--json=false` for plaintext or pipe it to `jq` if you want to filter.
- It found the fake AWS key, but gave a warning about verification failing (expected — fake key). Use `--no-verification` to skip that.

**What I'd try next**

Scan a real open-source repo I work on to see if I accidentally committed secrets. Maybe hook it up as a pre-commit hook.
