terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-elasticache-prd.tfstate"
    profile = "99c-prd"
  }
}

module "elasticache" {
  source                     = "../../modules/compute/elasticache"
  region                     = "ap-southeast-1"
  unit                       = "99c"
  env                        = "prd"
  code                       = "compute"
  feature                    = "elasticache"
  engine                     = "redis"
  engine_version             = "6.x"
  maintenance_window         = "sun:14:00-sun:15:00"
  multi_az_enabled           = false
  node_type                  = "cache.r5.xlargemedium"
  parameter_group_name       = "default.redis6.x.cluster.on"
  automatic_failover_enabled = true
  port                       = 6379
  snapshot_window            = "21:00-22:00"
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
}
