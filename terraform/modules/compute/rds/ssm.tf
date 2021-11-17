resource "aws_ssm_parameter" "aurora_cluster_endpoint" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/DB_WRITE_HOST"
  type   = "SecureString"
  value  = aws_rds_cluster.aurora_cluster.endpoint
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "aurora_reader_endpoint" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/DB_READ_HOST"
  type   = "SecureString"
  value  = aws_rds_cluster.aurora_cluster.reader_endpoint
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "aurora_master_username" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/DB_MASTER_USERNAME"
  type   = "SecureString"
  value  = aws_rds_cluster.aurora_cluster.master_username
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "aurora_master_password" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/DB_MASTER_PASSWORD"
  type   = "SecureString"
  value  = random_password.aurora_password.result
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "aurora_port" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/DB_PORT"
  type   = "SecureString"
  value  = aws_rds_cluster.aurora_cluster.port
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}