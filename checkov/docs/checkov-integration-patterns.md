# Checkov integration patterns: Terraform plan scanning and custom policies

## Purpose

Two integration patterns that come up regularly with Checkov: (1) scanning a Terraform plan JSON to catch misconfigurations before apply, and (2) writing custom policies for rules the built-in set doesn't cover. Both let you shift Checkov earlier in the pipeline — plan scanning finds issues during review, not after apply, and custom policies encode team-specific conventions.

## When to use each pattern

- **Terraform plan scanning** — when you want to validate infrastructure changes before they reach the cloud. The plan JSON contains every resource attribute; Checkov evaluates it the same way it evaluates static `.tf` files, but against the resolved values from the Terraform state and provider.
- **Custom policies** — when the built-in Checkov rules don't match your team's standards (e.g., a specific tag format, naming convention, or internal compliance rule). Custom policies are YAML files that Checkov evaluates alongside the built-in set.

## Prerequisites

- Checkov 3.x installed (`pip install checkov` or Docker image `bridgecrew/checkov`)
- Terraform 1.x for plan export
- A Terraform project to test against

## Steps

### 1. Terraform plan scanning

Generate the plan JSON and scan it with Checkov:

```bash
# Generate the plan file
terraform plan -out=plan.tfplan

# Convert to JSON
terraform show -json plan.tfplan > plan.json

# Scan with Checkov
checkov -f plan.json --compact
```

The `-f` flag tells Checkov to scan a single file. The `--compact` flag shortens the output lines, which helps in CI logs.

A common mistake: Checkov expects the **full** plan JSON, not a human-readable diff. Running `terraform show plan.tfplan` (without `-json`) produces text output that Checkov can't parse.

Checkov outputs results grouped by resource. For each failing resource it shows the rule ID, severity, and the attribute path:

```
Check: CKV_AWS_123: "Ensure no security groups allow ingress from 0.0.0.0/0 to port 22"
	PASSED for resource aws_security_group.allow_ssh
	FAILED for resource aws_security_group.allow_all_ssh
```

Wrap this in a CI step that fails the build on `FAILED` results with severity >= `HIGH`. The exit code is 0 when all checks pass or only `--soft-fail` checks fail, and non-zero otherwise.

### 2. Custom policy writing

Checkov custom policies live in YAML files. Each file defines one or more rules using a simple `metadata` + `definition` structure.

Create a directory for custom policies:

```bash
mkdir -p checkov_custom_policies
```

A minimal custom policy that enforces an `environment` tag on all AWS resources:

```yaml
# checkov_custom_policies/enforce_environment_tag.yaml
metadata:
  id: CUSTOM_ENV_TAG_001
  name: "Ensure all AWS resources have an environment tag"
  category: "general"

definition:
  cond_type: "attribute"
  resource_types:
    - "aws_*"
  attribute: "tags.environment"
  operator: "exists"
```

This policy checks every resource matching `aws_*` and passes if the `tags.environment` attribute exists.

To run with the custom policy:

```bash
checkov -d . --external-checks-dir checkov_custom_policies
```

More complex policies can check attribute values. For example, enforcing that EC2 instances are at least `t3.medium`:

```yaml
metadata:
  id: CUSTOM_EC2_SIZE_001
  name: "Enforce minimum EC2 instance size"
  category: "general"

definition:
  cond_type: "attribute"
  resource_types:
    - "aws_instance"
  attribute: "instance_type"
  operator: "regex_match"
  value: "^t3\\.(medium|large|xlarge|2xlarge)$|^m5\\..*"
```

The `operator` field supports `exists`, `not_exists`, `equals`, `not_equals`, `regex_match`, `contains`, `within`, `not_within`, and `starts_with`.

Custom policies work with plan JSON scanning too:

```bash
checkov -f plan.json --external-checks-dir checkov_custom_policies
```

## Verification

1. Run `checkov -f plan.json` against a known-bad Terraform plan (e.g., an open security group). Confirm it reports the failure.
2. Run the same plan with `--external-checks-dir checkov_custom_policies` and your custom tag policy against a resource that lacks the tag. Confirm it fails with the custom `CUSTOM_ENV_TAG_001` rule ID.
3. Run `checkov -d . --external-checks-dir checkov_custom_policies --compact --skip-check LOW` to test severity filtering alongside custom policies. Confirm LOW severity rules are suppressed.

## Common errors

- **"Failed to parse plan file"** — The JSON is not valid Terraform plan JSON. Make sure you used `terraform show -json` and not plain `terraform show`. Also confirm the plan was generated from the same Terraform version you're running.
- **Custom policy not being evaluated** — Checkov silently skips invalid YAML. Verify the policy with `checkov --external-checks-dir . --list` — it lists all loaded policies. If yours isn't listed, the YAML structure is wrong. The `resource_types` field must use underscore-prefixed Terraform types (`aws_s3_bucket`, not `AWS::S3::Bucket`).
- **`aws_*` wildcard not matching** — The wildcard only matches a single level. `aws_*` matches `aws_s3_bucket` but not `aws_s3_bucket_public_access_block` — that requires `aws_s3_bucket*`.
- **Policy runs on every scan but should only apply to certain services** — There's no built-in condition for resource attributes in the metadata. Use separate policy files per service and include/exclude them with `--external-checks-dir` per scan target.

## References

- [Checkov Terraform plan scanning docs](https://www.checkov.io/5.Policy%20Index/terraform.html)
- [Custom policies YAML reference](https://www.checkov.io/3.Custom%20Policies/Custom%20Policies%20Overview.html)
- [Checkov CLI argument reference](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html)
