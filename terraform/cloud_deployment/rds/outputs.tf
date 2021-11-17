output "compute_aurora_id" {
  value = module.rds.aurora_id
}

output "compute_aurora_arn" {
  value = module.rds.aurora_arn
}

output "compute_aurora_cluster_endpoint" {
  value = module.rds.aurora_cluster_endpoint
}

output "compute_aurora_reader_endpoint" {
  value = module.rds.aurora_reader_endpoint
}

output "compute_aurora_master_username" {
  value = module.rds.aurora_master_username
}

output "compute_aurora_port" {
  value = module.rds.aurora_port
}
