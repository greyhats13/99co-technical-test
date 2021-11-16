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
  engine                        = "redis"
  engine_version                = "6.x"
  maintenance_window            = "sun:20:00-sun:21:00"
  multi_az_enabled              = true
  node_type                     = "cache.r5.xlarge"
  parameter_group_name          = "default.redis6.x.cluster.on"
  automatic_failover_enabled    = true
  port                          = 6379
  replication_group_description = "Redis cluster"
  security_group_ids            = [aws_security_group.sg.id]
  snapshot_window               = "18:00-19:00"
  subnet_group_name             = aws_elasticache_subnet_group.subnet_group.name
  at_rest_encryption_enabled    = true
  kms_key_id                    = data.terraform_remote_state.kms.outputs.kms_key_arn
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
  transit_encryption_enabled = true

  cluster_mode {
    num_node_groups         = 1
    replicas_per_node_group = 1
  }
}