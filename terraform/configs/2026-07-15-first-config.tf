# last_verified: 2026-07-15 · terraform n/a

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "first_bucket" {
  bucket = "my-first-terraform-bucket"
}

variable "bucket_name" {
  description = "Name for the demo bucket"
  type        = string
  default     = "my-first-terraform-bucket"
}

output "bucket_id" {
  value = aws_s3_bucket.first_bucket.id
}
