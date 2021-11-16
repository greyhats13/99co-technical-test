output "elasticache_arn" {
    value = aws_elasticache_replication_group.elasticache.arn
}

output "elasticache_id" {
    value = aws_elasticache_replication_group.elasticache.id
}

output "elasticache_engine_version_actual" {
    value = aws_elasticache_replication_group.elasticache.engine_version_actual
}

output "elasticache_configuration_endpoint_address" {
    value = aws_elasticache_replication_group.elasticache.configuration_endpoint_address
}

output "elasticache_port" {
    value = aws_elasticache_replication_group.elasticache.port
}