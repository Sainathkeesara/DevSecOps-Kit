# last_verified: 2026-10-27 · terraform n/a
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr
}

output "vpc_id" {
  value = aws_vpc.this.id
}
