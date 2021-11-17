resource "aws_appautoscaling_target" "autscaling_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${data.terraform_remote_state.ecs.outputs.compute_ecs_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  count              = length(var.predefined_metric_type)
  name               = "${var.unit}-${var.env}-${var.code}-${var.feature}-autoscaling"
  policy_type        = var.policy_type
  resource_id        = aws_appautoscaling_target.autscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.autscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_value[count.index]
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type[count.index]
    }
  }

  lifecycle {
    ignore_changes = [
      scalable_dimension
    ]
  }
}
