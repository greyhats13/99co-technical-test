# variable "rotation_id" {
#   type = string
#   description = "Password rotation id"
#   default = "rotate-3"
# }

# resource "random_password" "password" {
#   length           = 16
#   upper            = true
#   lower            = true
#   number           = true
#   special          = true
#   override_special = "!@#$%&*()-_=+[]{}<>:?"
#   min_lower        = 2
#   min_upper        = 2
#   min_special      = 2
#   min_numeric      = 2
#   keepers = {
#     # Generate a new id each time we switch to a new AMI id
#     rotation = var.rotation_id
#   }
# }

# data "terraform_remote_state" "kms" {
#   backend = "s3"
#   config = {
#     bucket  = "${var.unit}-${var.env}-storage-s3-tfstate"
#     key     = "${var.unit}/${var.env}/security/kms/${var.unit}-${var.env}-security-kms-main.tfstate"
#     region  = var.region
#     profile = "${var.unit}-${var.env}"
#   }
# }

# resource "aws_ssm_parameter" "ssm" {
#   name      = "/${var.unit}/${var.env}/${var.code}/${var.feature}/${var.sub}/${upper(split("@", var.user.primary_email)[0])}_PASSWORD"
#   type      = "SecureString"
#   value     = random_password.password.result
#   overwrite = var.overwrite
#   key_id    = data.terraform_remote_state.kms.outputs.kms_alias_arn
# }
