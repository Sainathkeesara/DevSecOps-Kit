# last_verified: 2026-08-09 · terrascan n/a

# Custom Terrascan policy: block public S3 bucket access.
# Triggered when an aws_s3_bucket_public_access_block resource has
# block_public_acls or block_public_policy set to false.
---
apiVersion: v1
kind: policy
metadata:
  name: s3-bucket-block-public-access
  severity: high
  category: S3
  cloudProvider: aws
  resourceType: aws_s3_bucket_public_access_block
spec:
  rego:
    - |
      package terrascan

      violation[{"msg": msg}] {
        resource := input.resource
        resource.type == "aws_s3_bucket_public_access_block"
        resource.config.block_public_acls == false
        msg := sprintf("S3 bucket '%s' has public ACLs enabled", [resource.name])
      }

      violation[{"msg": msg}] {
        resource := input.resource
        resource.type == "aws_s3_bucket_public_access_block"
        resource.config.block_public_policy == false
        msg := sprintf("S3 bucket '%s' allows public policies", [resource.name])
      }
