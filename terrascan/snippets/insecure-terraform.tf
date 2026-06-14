# Deliberately insecure Terraform — testing Terrascan rules

resource "aws_security_group" "wide_open" {
  name        = "wide-open-sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-bucket"
  acl    = "public-read"
}

resource "aws_db_instance" "unencrypted_db" {
  engine         = "mysql"
  storage_encrypted = false
  publicly_accessible = true
}
