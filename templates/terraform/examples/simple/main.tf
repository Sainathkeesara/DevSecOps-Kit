module "secure_bucket" {
  source = "../"

  name            = "my-secure-bucket"
  environment     = "production"
  enable_encryption = true

  tags = {
    Team       = "Platform"
    CostCenter = "Engineering"
  }
}
