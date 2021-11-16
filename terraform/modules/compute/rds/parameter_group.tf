#Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "cluster_parameter_group" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-cluster-parameter-group"
  family      = var.parameter_group_family
  description = "Cluster Parameter group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
  
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name  = "time_zone"
    value = "asia/bangkok"
  }
}

#Database Parameter Group
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-db-parameter-group"
  family      = var.parameter_group_family
  description = "DB Parameter group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
 
  parameter {
    name  = "general_log"
    value = 1
  }
 
  parameter {
    name  = "long_query_time"
    value = 3
  }
 
  parameter {
    name  = "slow_query_log"
    value = 1
  }
}