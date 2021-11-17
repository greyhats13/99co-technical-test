resource "aws_security_group" "sg" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-sg"
  description = "Security Group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
  vpc_id      = data.terraform_remote_state.network.outputs.network_vpc_id
  tags = {
    Name      = "${var.unit}-${var.env}-${var.code}-${var.feature}-sg"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}

resource "aws_security_group_rule" "sg_in_tcp" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = [data.terraform_remote_state.network.outputs.network_vpc_cidr_block]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress TCP ${var.port} for ${var.unit}-${var.env}-${var.code}-${var.feature}"
}

resource "aws_security_group_rule" "sg_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow egress all protocol ${var.unit}-${var.env}-${var.code}-${var.feature}"
}