# Terrascan — quick primer

> First-day notes for someone who's never used Terrascan. Personal voice, plain language.

## What is it?

Terrascan is a static code analyzer for Infrastructure as Code (IaC). If you've used a linter like ESLint for JavaScript, it's the same idea — but for Terraform, CloudFormation, Kubernetes, and other IaC formats. It checks your templates against a library of security and compliance rules before you ever apply them to infrastructure.

## What does it do?

It reads your IaC files and flags anything that violates its rules — open security groups, hardcoded secrets, missing encryption, that sort of thing. You run it from the CLI, point it at a directory of Terraform files, and it prints a list of violations with severity levels, file paths, and rule IDs. It also supports custom policies written in Rego (the same policy language OPA uses).

## Why does it exist?

Before tools like Terrascan, the only way to catch security misconfigurations in IaC was either manual code review or waiting until after `terraform apply` broke something (or worse, got exploited). Terrascan shifts left — it runs during development, in CI pipelines, or as a pre-commit hook. The people who use it day-to-day are platform engineers, DevOps folks, and security engineers who review IaC PRs.

## Key terminology

- **IaC (Infrastructure as Code)** — Writing infrastructure config (servers, networks, databases) in files instead of clicking around a cloud console. Terraform is the most popular IaC tool right now.
- **Rule** — A single check Terrascan runs against your code. Example: "S3 bucket should have encryption enabled." Each rule has a unique ID and a severity level (HIGH, MEDIUM, LOW).
- **Policy** — A group of rules organized around a compliance standard. Terrascan ships with policies for CIS benchmarks, PCI DSS, HIPAA, and others.
- **Scan** — A single run of Terrascan against a directory or file. Output can be human-readable (terminal) or machine-readable (JSON, YAML, SARIF).
- **Rego** — The policy language from Open Policy Agent (OPA). Terrascan uses Rego for custom policies. It takes some getting used to — it's not like writing if/else.
- **Violation** — What Terrascan calls a finding. Each violation shows the file, line number, rule ID, severity, and a description.
- **SARIF** — A JSON-based format for static analysis results. GitHub Code Scanning eats SARIF, so you can integrate Terrascan results into GitHub.
- **--policy-type** — A flag that tells Terrascan which compliance standard to check against (e.g. `aws`, `azure`, `gcp`, `k8s`).

## A tiny example

```bash
# Install Terrascan (macOS / Linux)
curl -fsSL https://github.com/tenable/terrascan/releases/latest/download/terrascan_linux_amd64.tar.gz | tar xz

# Run a scan on a directory with Terraform files
./terrascan scan -d ./terraform/
```

This downloads Terrascan and runs a scan against a `terraform/` directory. If there are violations, it prints them to the terminal with file paths, rule IDs, and severity levels.

## What I'll cover next

I want to actually install it properly (not just curl a binary), run it against a deliberately insecure Terraform template to see what it catches, and then figure out how to integrate it into a GitHub Actions workflow so every PR gets scanned automatically.
