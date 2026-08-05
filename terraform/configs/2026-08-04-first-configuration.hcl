# last_verified: 2026-08-04 · terraform n/a
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "first" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "my-first-vm"
  }
}