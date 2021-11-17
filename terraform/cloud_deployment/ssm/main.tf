terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-security-ssm-prd.tfstate"
    profile = "99c-prd"
  }
}

variable "list_of_ssm" {
  #secret value in tfvars, tfvars is in .gitignore
}

module "ssm" {
  source      = "../../modules/security/ssm"
  region      = "ap-southeast-1"
  unit        = "99c"
  env         = "prd"
  code        = "security"
  feature     = "ssm"
  creator     = "tf"
  overwrite   = true
  list_of_ssm = var.list_of_ssm
}
