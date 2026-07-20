# last_verified: 2026-07-20 · Terraform n/a

variable "env" {
  type    = string
  default = "dev"
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}