provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

data "terraform_remote_state" "kms" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-security-kms-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_ssm_parameter" "ssm" {
  for_each  = var.list_of_ssm
  name      = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/${each.key}"
  type      = "SecureString"
  value     = each.value
  overwrite = var.overwrite
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}
