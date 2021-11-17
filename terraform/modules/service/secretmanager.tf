resource "aws_secretsmanager_secret" "secret" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  kms_key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

locals {
  parameters = {
    APP_NAME               = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    APP_ENV                = "${var.env}"
    APP_KEY                = ""
    APP_DEBUG              = "true"
    APP_URL                = "http://localhost"
    LOG_CHANNEL            = "stack"
    LOG_LEVEL              = "debug"
    DB_CONNECTION          = "mysql"
    DB_HOST                = data.terraform_remote_state.rds.outputs.compute_aurora_cluster_endpoint
    DB_PORT                = data.terraform_remote_state.rds.outputs.compute_aurora_port
    DB_DATABASE            = "${var.code}-${var.feature}"
    DB_USERNAME            = "root"
    DB_PASSWORD            = data.aws_ssm_parameter.db_password.value
    BROADCAST_DRIVER       = "log"
    CACHE_DRIVER           = "file"
    QUEUE_CONNECTION       = "sync"
    SESSION_DRIVER         = "file"
    SESSION_LIFETIME       = 120
    MEMCACHED_HOST         = "127.0.0.1"
    REDIS_HOST             = data.terraform_remote_state.elasticache.outputs.compute_elasticache_configuration_endpoint_address
    REDIS_PASSWORD         = data.aws_ssm_parameter.redis_password.value
    REDIS_PORT             = data.terraform_remote_state.elasticache.outputs.compute_elasticache_port
    MAIL_MAILER            = "smtp"
    MAIL_HOST              = "mailhog"
    MAIL_PORT              = 1025
    MAIL_USERNAME          = "null"
    MAIL_PASSWORD          = "null"
    MAIL_ENCRYPTION        = "null"
    MAIL_FROM_ADDRESS      = "null"
    MAIL_FROM_NAME         = "AVANA"
    AWS_ACCESS_KEY_ID      = ""
    AWS_SECRET_ACCESS_KEY  = ""
    AWS_DEFAULT_REGION     = var.region
  }
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(local.parameters)
}
