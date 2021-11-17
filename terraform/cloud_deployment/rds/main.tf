terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-rds-aurora-prd.tfstate"
    profile = "99c-prd"
  }
}

module "rds" {
  source                              = "../../modules/compute/rds"
  region                              = "ap-southeast-1"
  unit                                = "99c"
  env                                 = "prd"
  code                                = "compute"
  feature                             = "aurora"
  parameter_group_family              = "aurora-mysql5.7"
  engine_mode                         = "provisioned"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.10.0"
  master_username                     = "root"
  port                                = 3306
  backup_retention_period             = 5
  preferred_backup_window             = "07:00-09:00"
  iam_database_authentication_enabled = false
  copy_tags_to_snapshot               = true
  storage_encrypted                   = true
  backtrack_window                    = 0
  allow_major_version_upgrade         = true
  enabled_cloudwatch_logs_exports     = ["error", "general", "slowquery"]
  deletion_protection                 = false
  apply_immediately                   = true
  skip_final_snapshot                 = true
  number_of_instance                  = 2 #for 1 write and 1 read
  instance_class                      = "db.r5x.large"
  publicly_accessible                 = false
  performance_insights_enabled        = true
  monitoring_interval                 = 60
  auto_m99cr_version_upgrade          = true
  ca_cert_identifier                  = "rds-ca-2019"
  scalable_dimension                  = "rds:cluster:ReadReplicaCount"
  service_namespace                   = "rds"
  min_capacity                        = 1
  max_capacity                        = 15
  policy_type                         = "TargetTrackingScaling"
  predefined_metric_type              = "RDSReaderAverageDatabaseConnections"
  target_value                        = 750  #750 connection for 16gb memory
  scale_in_cooldown                   = 1800 #30 minutes to cooldown after spikes
  scale_out_cooldown                  = 60   #If spikes autoscaling as soos as possible
}
