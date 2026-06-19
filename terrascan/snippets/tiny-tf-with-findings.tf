# tiny Terraform that should flag a few Terrascan rules

resource "aws_s3_bucket" "no_logs" {
  bucket = "no-logging-bucket"
  acl    = "private"
  # no logging config — Terrascan should flag this
}

resource "aws_ebs_snapshot" "not_encrypted" {
  volume_id = "vol-12345678"
  # no encrypted = true — should trigger a finding
}
