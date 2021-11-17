output "ecs_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "nlb_id" {
  value = aws_lb.nlb.id
}

output "nlb_arn" {
  value = aws_lb.nlb.arn
}