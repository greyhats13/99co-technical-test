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

resource "random_password" "elasticache_password" {
  length           = 16
  upper            = true
  lower            = true
  number           = true
  special          = false
  override_special = "_~!#$&*="
  min_lower        = 2
  min_upper        = 2
  min_special      = 0
  min_numeric      = 2
}

resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id          = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  auth_token                    = random_password.elasticache_password.result
  engine                        = var.engine
  engine_version                = var.engine_version
  maintenance_window            = var.maintenance_window
  multi_az_enabled              = var.multi_az_enabled
  node_type                     = var.node_type
  parameter_group_name          = var.parameter_group_name
  automatic_failover_enabled    = var.automatic_failover_enabled
  port                          = var.port
  replication_group_description = "Redis cluster on ${var.env}"
  security_group_ids            = [aws_security_group.sg.id]
  snapshot_window               = var.snapshot_window
  subnet_group_name             = aws_elasticache_subnet_group.subnet_group.name
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  kms_key_id                    = var.at_rest_encryption_enabled ? data.terraform_remote_state.kms.outputs.kms_key_arn : null
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
  transit_encryption_enabled = var.transit_encryption_enabled

  cluster_mode {
    num_node_groups         = 1
    replicas_per_node_group = 1
  }
}