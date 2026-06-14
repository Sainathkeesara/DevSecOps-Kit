# First Terrascan scan

I installed Terrascan today and pointed it at a Terraform file I wrote that opens port 22 to 0.0.0.0/0. Wanted to see what it catches.

Installed via the pre-built binary since I'm on Linux:

```bash
curl -sL https://github.com/tenable/terrascan/releases/latest/download/terrascan_linux_amd64.tar.gz | tar xz
sudo mv terrascan /usr/local/bin/
```

Ran the scan:

```bash
terrascan scan -d test/
```

It found 3 violations in my test Terraform:

| Rule | Severity | What it flagged |
|------|----------|-----------------|
| AWS.SecurityGroup.OpenAll | HIGH | `ingress with 0.0.0.0/0 on port 22` |
| AWS.SecurityGroup.SSHAccess | MEDIUM | `SSH port open to the world` |
| AWS.S3Bucket.PublicRead | MEDIUM | `S3 bucket should not be public` |

I didn't expect it to catch the S3 bucket thing since I was testing with an EC2-focused file, but I guess it scanned everything in the directory.

The JSON output was cleaner for piping:

```bash
terrascan scan -d test/ -o json | jq '.results.violations[] | {rule: .rule_name, severity: .severity, file: .file}'
```

Got stuck on the SARIF output flag at first — `-o sarif` gave me an error about missing template. Turns out you need to pass `-o sarif` with `--config-path` set, otherwise it looks for a template file that doesn't exist in the default install. Skipped that for now.

Next I want to write a deliberately insecure Terraform file to test more rules, then figure out the CI integration.
