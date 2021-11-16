data "terraform_remote_state" "kms" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-tfstate"
    key     = "${var.unit}/${var.env}/security/kms/${var.unit}-${var.env}-security-kms-main.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_ssm_parameter" "ssm" {
  for_each  = var.list_of_ssm
  name      = "/${var.unit}/${var.env}/${var.code}/${var.feature}/${var.sub}/${each.key}"
  type      = "SecureString"
  value     = each.value
  overwrite = var.overwrite
  key_id    = data.terraform_remote_state.kms.outputs.kms_alias_arn
}
