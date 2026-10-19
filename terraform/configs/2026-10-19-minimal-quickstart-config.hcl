# last_verified: 2026-10-19 · terraform n/a
# My first minimal Terraform configuration, following the official quickstart.
# One provider and one resource — just enough to run `terraform init` and `terraform plan`.
# The AMI is a placeholder for us-east-1; swap it for the AMI you actually want to use.

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

resource "aws_instance" "quickstart" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-quickstart"
  }
}
