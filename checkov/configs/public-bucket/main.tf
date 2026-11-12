# last_verified: 2026-11-12 · checkov 3.4.4
resource "aws_s3_bucket" "web_assets" {
  bucket = "my-company-web-assets"
  acl    = "public-read"
}
