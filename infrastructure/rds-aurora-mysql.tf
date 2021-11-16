resource "aws_security_group" "sg" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-sg"
  description = "Security Group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
  vpc_id      = data.terraform_remote_state.network.outputs.network_vpc_id
  tags = {
    Name      = "${var.unit}-${var.env}-${var.code}-${var.feature}-sg"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}

resource "aws_security_group_rule" "sg_in_tcp" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [aws.vpc.cidr_blocks]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress TCP 3306 for ${var.unit}-${var.env}-${var.code}-${var.feature}"
}

resource "aws_security_group_rule" "sg_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow egress all protocol ${var.unit}-${var.env}-${var.code}-${var.feature}"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-network-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-db-subnet-group"
  subnet_ids  = data.terraform_remote_state.network.outputs.network_db_subnet_id
  description = "DB subnet group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-db-subnet-group"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
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

resource "random_password" "aurora_password" {
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

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier                  = "${var.unit}-${var.env}-${var.code}-${var.feature}-cluster-${var.region}"
  engine_mode                         = "provisioned"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.10.0"
  availability_zones                  = [data.aws_availability_zones.az.names[0], data.aws_availability_zones.az.names[1]]
  master_username                     = "root"
  master_password                     = random_password.aurora_password.result
  port                                = 3306
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids              = [aws_security_group.sg.id]
  iam_database_authentication_enabled = false
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.cluster_parameter_group.id
  backup_retention_period             = 5
  copy_tags_to_snapshot               = true
  storage_encrypted                   = true
  kms_key_id                          = data.terraform_remote_state.kms.outputs.kms_key_arn
  backtrack_window                    = 0
  allow_major_version_upgrade         = true
  enabled_cloudwatch_logs_exports     = ["error", "general", "slowquery"]
  preferred_backup_window             = "07:00-09:00"
  deletion_protection                 = true
  apply_immediately                   = true
  skip_final_snapshot                 = false
  final_snapshot_identifier           = "${var.unit}-${var.env}-${var.code}-${var.feature}-final-snapshot"
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-cluster"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      engine_version
    ]
  }
}

resource "aws_iam_role" "monitoring_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "monitoring_attach_policy" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                           = 2
  identifier                      = "${var.unit}-${var.env}-${var.code}-${var.feature}-instance-${element(data.aws_availability_zones.az.names, count.index)}-${count.index}"
  cluster_identifier              = aws_rds_cluster.aurora_cluster.id
  instance_class                  = "db.r5.xlarge"
  engine                          = aws_rds_cluster.aurora_cluster.engine
  engine_version                  = aws_rds_cluster.aurora_cluster.engine_version
  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group.id
  publicly_accessible             = false
  copy_tags_to_snapshot           = aws_rds_cluster.aurora_cluster.copy_tags_to_snapshot
  promotion_tier                  = count.index
  availability_zone               = element(data.aws_availability_zones.az.names, count.index)
  performance_insights_enabled    = true
  performance_insights_kms_key_id = data.terraform_remote_state.kms.outputs.kms_key_arn
  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.monitoring_role.arn
  auto_minor_version_upgrade      = true
  apply_immediately               = true
  ca_cert_identifier              = "rds-ca-2019"
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-instance-${element(data.aws_availability_zones.az.names, count.index)}-${count.index}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}

resource "aws_appautoscaling_target" "autoscaling_target" {
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.aurora_cluster.id}"
  min_capacity       = 2
  max_capacity       = 15
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  name               = "${var.unit}-${var.env}-${var.code}-${var.feature}-autoscaling-policy"
  service_namespace  = aws_appautoscaling_target.autoscaling_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.autoscaling_target.scalable_dimension
  resource_id        = aws_appautoscaling_target.autoscaling_target.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageDatabaseConnections"
    }

    target_value       = 750
    scale_in_cooldown  = 1800
    scale_out_cooldown = 60
  }
}
