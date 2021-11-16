output "aurora_id" {
  value = aws_rds_cluster.aurora_cluster.id
}

output "aurora_arn" {
  value = aws_rds_cluster.aurora_cluster.arn
}

output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "aurora_master_username" {
  value = aws_rds_cluster.aurora_cluster.master_username
}

output "aurora_port" {
  value = aws_rds_cluster.aurora_cluster.port
}