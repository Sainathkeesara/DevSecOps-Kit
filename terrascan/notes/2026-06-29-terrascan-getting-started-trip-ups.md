# Terrascan getting-started tutorial — what tripped me up

I followed the Terrascan getting-started from the GitHub README. The quick start has three steps: Install, Scan, Integrate. Here's what actually happened.

## Step 1: Install

The README shows a one-liner curl command to grab the latest Linux binary. It worked but I hit a surprise — the repo was archived in Nov 2025 and the latest release (v1.19.9) is from Sep 2024. The tool still works, but it's no longer maintained by Tenable. That's worth knowing if you're planning long-term CI usage.

I installed via the curl method:

```bash
curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz
tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz
sudo install terrascan /usr/local/bin && rm terrascan
```

The `grep -o -E` pattern is fragile — if GitHub changes the release asset URL format, this breaks. I'd rather just grab the known URL from the releases page.

```bash
terrascan version
# v1.19.9
```

## Step 2: Scan

I created a tiny Terraform file to test:

```hcl
resource "aws_s3_bucket" "public" {
  bucket = "test-bucket"
  acl    = "public-read"
}
```

Ran `terrascan scan` in the directory:

```
violation: AWS.S3Bucket.DSHPublicReadGetObject.AClReadPublicRead
severity: MEDIUM
```

The exit code tripped me up. Terrascan exits `3` when it finds violations but no scan errors — that's *with* violations. Exit `0` means clean. So a naive CI check like `terrascan scan || exit 1` would fail on violations, which is actually what you want for a gating pipeline. But the README says exit codes 3, 4, and 5 all indicate something was found — 3 is violations-only, 4 is errors-only, 5 is both. I'd expected 1 for violations like most tools.

```bash
terrascan scan --output json 2>/dev/null | jq '.results.violations | length'
# 1
```

The first run also failed because Terrascan hadn't downloaded its policies yet. It did that automatically on first `scan`, but took ~10 seconds with no progress output. I thought it hung.

## Step 3: Integrate (tried locally)

The README points to the docs site for CI integration, which covers GitHub Actions, GitLab CI, Jenkins. I tried `terrascan scan -i terraform --output json --severity high`. The `--severity` flag filters output but the exit code still reflects ALL violations regardless of filter. So if you want to fail only on HIGH, you need to parse JSON yourself:

```bash
terrascan scan --output json | jq -e '.results.violations[] | select(.severity=="HIGH")' > /dev/null
```

## Got stuck on

- **Exit codes**: expected standard 0/1, got 0/3/4/5. The README has a table but I didn't see it until I went back to look.
- **Policies download**: silent on first `scan`. Adding `--log-level debug` shows what's happening.
- **Archived status**: the repo banner says archived but the CLI still works. I wonder how long the policy download URLs will stay up.
- **--severity filter doesn't change exit code**: JSON parsing is required for proper CI gating.
- **iac-type detection**: `terrascan scan` auto-detects IaC type by scanning the directory. I assumed it would fail with a clear error if no Terraform files were present — it just prints an empty result table and exits 0.

## What I'd try next

Try scanning a real Terraform module with multiple resources. The custom Rego policies from the docs look interesting — I want to write a rule that blocks S3 buckets without versioning and see how it integrates with `terrascan scan --config-path`.
