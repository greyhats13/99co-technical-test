data "terraform_remote_state" "kms" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-security-kms-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_ssm_parameter" "bastion_private_key" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/${var.sub}/BASTION_PRIVATE_KEY"
  type   = "SecureString"
  value  = tls_private_key.rsa.private_key_pem
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}