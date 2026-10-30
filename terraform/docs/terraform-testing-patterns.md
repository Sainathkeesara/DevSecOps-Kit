---
last_verified: 2026-10-30
tool_version: n/a
sources:
  - https://scalr.com/learning-center/ultimate-guide-to-using-terraform-with-ansible
---

# Terraform testing: unit, contract, and integration patterns

## Purpose

Terraform configurations benefit from automated testing to catch regressions before applying changes to infrastructure. Testing provides confidence that the configuration behaves as expected across different environments and that modifications do not introduce unintended side effects. A testing suite typically covers three layers: unit validation of individual resources, contract verification of resource interactions, and integration confirmation that the deployed infrastructure matches the intended state.

## What this covers

This guide outlines patterns for each testing layer, focusing on approaches that integrate with common CI pipelines and produce actionable feedback without requiring costly remote runs for every check.

## Unit tests

Unit tests validate that a single resource block renders as expected and that input variables produce the anticipated effect. The most lightweight approach uses `terraform validate` to confirm the configuration syntax and schema compliance:

```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
}

# Validate the configuration
terraform validate
```

Beyond syntax, some teams render the configuration with `terraform plan -generate-plan` and inspect the JSON output to verify resource attributes. This catches misconfigured default values or unintended argument changes before a plan is ever run.

## Contract tests

Contract tests verify that resource interactions respect expected agreements, such as required tags, networking constraints, or IAM permission boundaries. A common pattern is to use `terratest` to spin up a temporary infrastructure segment and assert specific properties:

```go
tf.NewTerraform(t, testname).
  InitWithInput(nil, tf.IOptions{
    ManifestPath: "./infra",
  })
  
  // Assert the instance has the required tag
  tut.AssertExistsE(t, "aws:environment")
  
  // Assert the security group allows only expected ports
  tut.AssertEquals(t, 80, getSecurityGroupPort(t, "allow_http"))
```

Contract tests require a temporary environment, so they are typically run on a schedule or against a dedicated test account rather than on every pull request.

## Integration tests

Integration tests confirm that the assembled infrastructure matches the desired state after a real or simulated apply. Because `terraform apply` can be destructive, many teams use `terraform plan -out=plan.out` and then validate the plan output against expected resource counts or attributes. A typical verification step checks:

- The number of resources of each type matches the configuration
- Output values resolve to the expected formats
- No unexpected changes are included in the plan

When a CI pipeline has access to a transient cloud environment, the plan can be applied and the resulting state compared against a golden file captured from a known-good run.

## Verification

A testing workflow is verified when every commit that modifies Terraform configuration triggers at least a `terraform validate` step, and the pipeline fails if the validation exits non-zero. Additional layers (contract or integration tests) are considered active when they are merged and regularly exercised without incurring prohibitive cloud resource costs.

## Common errors

- **Skipping `terraform validate`** in CI can allow syntax errors or schema violations to reach the planning stage, wasting time and resources.
- **Over-reliance on remote runs** without local unit or contract checks inflates cost and slows feedback loops.
- **Failing to capture plan artifacts** makes it difficult to diff changes across commits, especially when the plan is discarded after review.