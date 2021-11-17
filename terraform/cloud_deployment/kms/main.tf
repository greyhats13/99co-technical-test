terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-security-kms-prd.tfstate"
    profile = "99c-prd"
  }
}

data "local_file" "kms_policy" {
  filename = "${path.module}/kms_policy.json"
}

module "kms" {
  source                   = "../../modules/security/kms"
  region                   = "ap-southeast-1"
  unit                     = "99c"
  env                      = "prd"
  code                     = "security"
  feature                  = ["kms"]
  description              = "General Customer Managed Key on prd account"
  key_usage                = "ENCRYPT_DECRYPT"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  is_enabled               = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy                   = data.local_file.kms_policy.content
}
