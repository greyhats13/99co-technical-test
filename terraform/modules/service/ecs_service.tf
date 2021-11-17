provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions    = data.template_file.container_definitions.rendered
  cpu                      = 2 * var.cpu
  memory                   = 2 * var.memory
  family                   = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = var.network_mode
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  cluster         = data.terraform_remote_state.ecs.outputs.compute_ecs_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  launch_type     = var.launch_type

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_tg.arn
    container_name   = "${var.unit}-${var.env}-${var.code}-${var.feature}-php"
    container_port   = var.container_port
  }

  network_configuration {
      subnets         = data.terraform_remote_state.network.outputs.network_app_subnet_id
      security_groups = [aws_security_group.sg.id]
  }
}
