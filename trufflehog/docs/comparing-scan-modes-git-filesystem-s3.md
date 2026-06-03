# Comparing TruffleHog scan modes: git history vs filesystem vs S3 buckets

TruffleHog offers three main scan modes for finding secrets in different contexts. This guide walks through each one and when to reach for it.

## Purpose

Each scan mode targets a different data source: git commits, local files, or S3 objects. Choosing the wrong mode wastes time or misses secrets. The goal here is to understand the tradeoffs so you can pick the right one on the first try.

## Scan modes overview

| Mode | Command | Data source | Best for |
|------|---------|-------------|----------|
| Git | `trufflehog git <uri>` | Git commit history (local or remote) | Finding secrets that were committed and maybe deleted |
| Filesystem | `trufflehog filesystem <path>` | Local directory or file | Scanning build artifacts, config files, or non-repo directories |
| S3 | `trufflehog s3 --bucket=<name>` | S3 bucket objects | Discovering leaked credentials in cloud storage |

## Git mode

`trufflehog git` walks the entire commit history — not just the latest state. This is its superpower: even if someone committed a secret and then force-pushed to remove it, the secret is still in the reflog history.

```bash
# Scan a public GitHub repo
trufflehog git https://github.com/trufflesecurity/test_keys

# Scan a local git repo (note the file:// prefix)
trufflehog git file://./my-repo

# Show only verified results
trufflehog git https://github.com/trufflesecurity/test_keys --results=verified

# JSON output for downstream processing
trufflehog git https://github.com/trufflesecurity/test_keys --json | jq '.SourceMetadata.Data.Git'
```

The git mode also works with GitHub, GitLab, and self-hosted instances via their respective subcommands (`trufflehog github`, `trufflehog gitlab`), which add org-level scanning and issue/PR comment inspection.

One thing I ran into: scanning an org without a `--token` hits GitHub API rate limits fast (60 req/hr unauthenticated). Adding a token makes it usable.

## Filesystem mode

`trufflehog filesystem` scans a local directory or file. No git history involved — it reads files as they exist on disk right now.

```bash
# Scan a directory recursively
trufflehog filesystem ./configs/

# Scan a single file
trufflehog filesystem ./configs/credentials.yml

# Exclude large directories that slow things down
trufflehog filesystem ./project/ --exclude-patterns='node_modules/,.git/,.terraform/'
```

Filesystem mode is useful for:
- Scanning CI workspace directories before packaging artifacts
- Checking config directories mounted into containers
- Auditing backup directories that may contain stale secrets

The positional path argument tripped me up at first — I kept reaching for `--path=` but the CLI takes a plain path arg.

## S3 mode

`trufflehog s3` enumerates objects in an S3 bucket and scans their contents. It supports assuming IAM roles and can handle large buckets through concurrency.

```bash
# Scan a single bucket with default credentials
trufflehog s3 --bucket=my-corp-bucket

# Assume a role for cross-account access
trufflehog s3 --bucket=my-corp-bucket --role-arn=arn:aws:iam::123456789012:role/TruffleHogScanRole

# Scan only objects with specific key prefixes
trufflehog s3 --bucket=my-corp-bucket --key-prefix=configs/
```

IAM role assumption is the safer approach for production — avoids embedding long-lived AWS keys in CI configs. The TruffleHog docs have a sample trust policy for the role.

S3 mode is slower than the other two because it downloads each object before scanning. Using `--key-prefix` to narrow the search space helps a lot.

## When to use which

- **Start with git mode** for any repo that has more than one contributor. Secrets in commit history are the most common leak vector.
- **Use filesystem mode** for build artifacts, deployment packages, or any directory that isn't a git repo but might contain interpolated secrets.
- **Use S3 mode** when you suspect secrets ended up in cloud storage — log files, backup dumps, or config bundles uploaded by automation.

You can also chain them in a CI pipeline: scan the repo with git mode on push, scan the workspace with filesystem mode after build, and scan S3 buckets on a schedule.

## Verify

To confirm a scan mode is working correctly:

```bash
# Git — should find the known test keys
trufflehog git https://github.com/trufflesecurity/test_keys --results=verified

# Filesystem — create a test file with a fake key first
echo "AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" > /tmp/test-secrets.txt
trufflehog filesystem /tmp/test-secrets.txt

# S3 — requires a real bucket with some objects
trufflehog s3 --bucket=my-test-bucket --max-object-size=1024
```

The git mode against the TruffleHog test repo should return verified AWS keys. The filesystem scan should flag the fake key (it matches the AWS detector pattern). The S3 scan will depend on your bucket contents.

## Common errors

- **Git mode with a plain path instead of `file://`** — `trufflehog git ./repo` fails. Use `trufflehog git file://./repo`.
- **Filesystem mode with `--path=`** — The flag doesn't exist. Pass the path as a positional argument.
- **S3 mode without proper IAM permissions** — `s3:ListBucket` on the bucket and `s3:GetObject` on objects are required at minimum.
- **Org scan rate limits** — Pass `--token` for GitHub/GitLab scans to avoid hitting unauthenticated rate limits.
