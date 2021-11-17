resource "aws_lb_target_group" "nlb_tg" {
  name                 = "${var.unit}-${var.env}-${var.code}-${var.feature}-tg"
  port                 = var.container_port
  protocol             = var.protocol
  vpc_id               = data.terraform_remote_state.network.outputs.network_vpc_id
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    protocol            = var.protocol
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-tg"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = "${var.feature}-tg"
  }
}

resource "aws_lb_listener" "nlb_http_listener" {
  load_balancer_arn = data.terraform_remote_state.ecs.outputs.compute_nlb_arn
  port              = var.container_port
  protocol          = var.protocol

  default_action {
    target_group_arn = aws_lb_target_group.nlb_tg.id
    type             = "forward"
  }
}