# Checkov AI infrastructure checks reference

## Purpose

AI and machine learning services — AWS Bedrock, Google Vertex AI, and third-party APIs like OpenAI — carry the same misconfiguration risks as core infrastructure: unencrypted storage, open network access, missing audit logs, and overprivileged service roles. This reference documents where Checkov covers those services and how to extend it when the built-in rules don't match your architecture.

## When to use

Run AI infrastructure checks after you add a Terraform or CloudFormation resource for Bedrock, Vertex AI, or an OpenAI-backed service. They belong in the same pipeline stage as standard Checkov runs: after `terraform plan` and before merge. If a project uses multiple AI providers, scan all IaC directories in one job and gate on `HIGH` and `CRITICAL` findings.

## Prerequisites

- Checkov 3.x installed locally or in CI
- Terraform or CloudFormation project that provisions AI services
- (Optional) Terraform 1.x for plan JSON scanning — preferred because plan JSON contains resolved attribute values that static file scans may miss

## Coverage by provider

### AWS Bedrock

Checkov evaluates Bedrock resources under the standard AWS framework. Common security properties verified by built-in rules include:

- Encryption at rest for Bedrock agents, knowledge bases, and model invocation logs
- VPC or endpoint configuration that limits public network access
- IAM role scoping that prevents overly broad Bedrock permissions
- Guardrail and filter configuration for content moderation

Use the regular AWS scan path:

```bash
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
checkov -f plan.json --framework terraform_plan --check CKV_AWS_*
```

To find Bedrock-specific checks:

```bash
checkov --list-checks | grep -i bedrock
```

### Google Vertex AI

Vertex AI checks run under the GCP framework. Look for rules that cover:

- Encryption configuration on Vertex AI endpoints, datasets, and model deployment resources
- Authorized networks restricting endpoint access to your VPC
- IAM policy bindings that limit who can invoke, deploy, or modify models

```bash
checkov -d ./gcp --framework terraform_plan --check CKV_GCP_*
checkov --list-checks | grep -i vertex
```

### OpenAI and third-party AI APIs

Checkov does not ship native policies for OpenAI API resources. Treat API keys as secrets and cover them with Checkov's secret scanning (`--framework secrets`) or TruffleHog. For Terraform resources that reference OpenAI-backed services (e.g., `aws_lambda_function` calling OpenAI, or custom resources pointing at an API endpoint), write custom policies in `checkov_custom_policies/` and load them per scan:

```bash
checkov -d . --external-checks-dir checkov_custom_policies --framework terraform_plan
```

Custom policies for AI resources focus on the same patterns as any other policy: encryption requirements, network restrictions, and logging. Because third-party API access patterns vary, custom policies are usually the only way to encode team-specific conventions like "no OpenAI key exposed in plaintext" or "all AI endpoints must exist inside a private subnet."

## Combined AI scan

Run all providers in one pass with a single sarif report:

```bash
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
checkov -f plan.json \
  --framework terraform_plan \
  --check CKV_AWS_*,CKV_GCP_* \
  --output sarif \
  --output cli-json \
  --hard-fail-on HIGH,CRITICAL \
  --compact
```

## Verify

1. Add a Terraform resource for your target AI service (e.g., `aws_bedrock_agent` without encryption, or a `google_vertex_ai_endpoint` without authorized networks).
2. Run `terraform plan -out=plan.tfplan && terraform show -json plan.tfplan > plan.json`.
3. Run `checkov -f plan.json --framework terraform_plan --check CKV_AWS_*` (or `CKV_GCP_*` for GCP) and confirm the finding appears.
4. Apply the remediation, rerun the plan scan, and confirm the finding clears.

## Common errors

- **Check ID not found** — Policy packs are loaded lazily. Verify availability with `checkov --list-checks | grep -i bedrock`. If the check is absent, it needs either a newer Checkov version or a custom policy.
- **Plan scan misses a computed attribute** — If the AI service derives the encryption or network value from a module, confirm the plan JSON contains the resolved value; static file scans won't evaluate computed defaults.
- **False positive on shared VPC / endpoint** — Use `--skip-check` or inline `# checkov:skip=<ID>` comments only after verifying the shared resource is managed outside this repo.

## References

- [Checkov policy index](https://www.checkov.io/5.Policy%20Index/)
- [Checkov custom policies overview](https://www.checkov.io/3.Custom%20Policies/Custom%20Policies%20Overview.html)
- [Checkov CLI argument reference](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html)
