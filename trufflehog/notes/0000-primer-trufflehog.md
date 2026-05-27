# TruffleHog — quick primer

I just learned about TruffleHog. It's a tool that scans git repos and filesystems for secrets — API keys, passwords, tokens, that sort of thing. Think of it like `grep` but way smarter: it doesn't just look for exact keyword matches, it also flags high-entropy strings that _look_ like secrets even if nobody told it what to look for.

It has detectors for like 700+ secret formats — AWS keys, GitHub tokens, Slack tokens, Stripe keys, you name it. And it's got this thing called "verification" where it actually tries to check if a found secret is still live (without sending it anywhere sketchy — it reaches out to the service's own API).

Key terms I ran into:
- **Detector** — A pattern matcher for a specific secret type (e.g. `AWS Access Key` detector). TruffleHog ships with hundreds.
- **Verification** — The step where TruffleHog takes a candidate secret and tries to validate it against the real service (e.g. hits the AWS STS endpoint to check if the key works).
- **Entropy** — A randomness score. High-entropy strings get flagged even if they don't match a known pattern. Good for catching custom API keys.
- **`trufflehog git`** — Scans a git repo's entire commit history, looking for secrets that were ever committed (even if later deleted).
- **`trufflehog filesystem`** — Scans a local directory or file, no git history needed.

A minimal example to scan a local directory:

```
trufflehog filesystem --path=./my-project/ --no-verification
```

This scans everything under `./my-project/` for secrets without trying to verify them. Good for a first look.

Next I'll actually install it and run it on a small repo to see what it catches.
