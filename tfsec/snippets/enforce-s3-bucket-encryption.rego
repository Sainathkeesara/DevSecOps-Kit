# last_verified: 2026-10-28 · tfsec n/a
package tfsec.s3

deny[reason] {
    not input.s3_bucket
    input.s3_bucket.type == "aws"
    not input.s3_bucket.server_side_encryption_enabled
    reason = "S3 bucket does not have server-side encryption enabled"
}