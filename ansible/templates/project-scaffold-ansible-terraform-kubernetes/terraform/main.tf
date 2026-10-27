terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}
