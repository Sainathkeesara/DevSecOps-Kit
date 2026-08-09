# last_verified: 2026-08-09 · terrascan n/a

# Custom Terrascan policy: require encryption on S3 buckets.
# Triggered when an aws_s3_bucket resource lacks a
# server_side_encryption_configuration block.
---
apiVersion: v1
kind: policy
metadata:
  name: s3-bucket-default-encryption
  severity: medium
  category: S3
  cloudProvider: aws
  resourceType: aws_s3_bucket
spec:
  rego:
    - |
      package terrascan

      violation[{"msg": msg}] {
        resource := input.resource
        resource.type == "aws_s3_bucket"
        not resource.config.server_side_encryption_configuration
        msg := sprintf("S3 bucket '%s' does not have default encryption", [resource.name])
      }
