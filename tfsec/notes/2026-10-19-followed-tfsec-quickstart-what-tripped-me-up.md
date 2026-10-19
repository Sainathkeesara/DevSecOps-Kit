---
last_verified: 2026-10-19
tool_version: 1.28.1
sources: []
---

# Followed the tfsec quickstart — what tripped me up

I followed the official tfsec quickstart today. Here's what happened.

## Install

The docs say `brew install tfsec` on macOS or download the binary from the official releases page. I'm on Linux so I grabbed the latest release:

```bash
curl -sL <tfsec-release-url> -o /usr/local/bin/tfsec
chmod +x /usr/local/bin/tfsec
```

First run: `tfsec --version` printed `1.28.1`. Good.

## Quickstart scan

Created a test directory with a deliberately bad Terraform file:

```hcl
# main.tf
resource "aws_s3_bucket" "public" {
  bucket = "my-public-bucket"
  acl    = "public-read"
}

resource "aws_security_group" "open_ssh" {
  name        = "open-ssh"
  description = "Allow SSH from everywhere"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "unencrypted" {
  identifier             = "mydb"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_encrypted      = false
  publicly_accessible    = true
}
```

Ran `tfsec .` — it found 4 issues immediately:
- `aws-s3-no-public-access` (HIGH) on the bucket ACL
- `aws-s3-enable-bucket-logging` (MEDIUM)
- `aws-security-group-no-ingress-from-0-0-0-0` (CRITICAL) on the SG
- `aws-db-instance-encryption` (HIGH) on the unencrypted RDS

The output is clean — file, line, check ID, severity, description. No noise.

## What tripped me up

**1. It scans `.tf` files recursively but ignores `.tfvars` by default**

I had a `prod.tfvars` with sensitive values and expected tfsec to pick it up. It doesn't — you need `--tfvars-file prod.tfvars` or it won't evaluate variable references. Missed this in the quickstart.

**2. Module depth defaults to unlimited**

My test had a `modules/network/` subdirectory. tfsec scanned it automatically and flagged issues there too. That's actually good, but the quickstart doesn't mention `--module-depth` flag. If you have deep module trees, it can slow things down. `--module-depth=0` skips modules entirely.

**3. Exit codes: 0 = no issues, 1 = issues found, 2 = error**

I tried `tfsec . || echo "failed"` in a script and it "failed" on legitimate findings. That's the design — exit 1 means "scan succeeded but found problems." For CI you want `tfsec .` to fail the build on HIGH/CRITICAL, not on any finding. Need `--minimum-severity=HIGH` to gate properly.

**4. SARIF output needs `--out` flag**

The quickstart shows `--format sarif` but doesn't emphasize you must pair it with `--out results.sarif` or it prints to stdout (which GitHub Actions won't pick up). Learned that the hard way.

**5. No config file created by default**

The docs mention `.tfsec.yml` for excluding checks, setting severity overrides, etc. But `tfsec --init` doesn't exist — you create it manually. The quickstart shows an example but I missed it on first read.

## What worked well

- Zero config to start — point at a directory, get results
- Check IDs are stable and documented (`aws-*`, `azure-*`, `google-*`, `general-*`)
- Inline ignores with `# tfsec:ignore[check-id]` are clean and auditable
- JSON output is machine-parseable for custom tooling

## What I'd try next

Write a `.tfsec.yml` with severity overrides for our environment (downgrade some MEDIUM to LOW where we accept the risk), add it to pre-commit, and wire `--minimum-severity=HIGH` into the CI pipeline as a gate.