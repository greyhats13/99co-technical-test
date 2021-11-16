resource "aws_ssm_parameter" "elasticache_host" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/REDIS_HOST"
  type   = "SecureString"
  value  = aws_elasticache_replication_group.elasticache.configuration_endpoint_address
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "elasticache_port" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/REDIS_PORT"
  type   = "SecureString"
  value  = aws_elasticache_replication_group.elasticache.configuration_endpoint_address
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_ssm_parameter" "elasticache_password" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/REDIS_PASSWORD"
  type   = "SecureString"
  value  = random_password.elasticache_password.result
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}