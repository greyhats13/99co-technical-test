
resource "aws_security_group" "sg" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}-sg"
  description = "Security Group for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
  vpc_id      = data.terraform_remote_state.network.outputs.network_vpc_id
  tags = {
    Name      = "${var.unit}-${var.env}-${var.code}-${var.feature}--${var.sub}-sg"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}

resource "aws_security_group_rule" "sg_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress TCP 22 for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}

resource "aws_security_group_rule" "sg_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress HTTP 80 for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}

resource "aws_security_group_rule" "sg_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress HTTPS 443 for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}

#atlantis server
resource "aws_security_group_rule" "sg_in_atlantis" {
  type              = "ingress"
  from_port         = 4141
  to_port           = 4141
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress TCP 4141 for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}

#phpmyadmin
resource "aws_security_group_rule" "sg_in_phpmyadmin" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow ingress TCP 8081 for ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}

resource "aws_security_group_rule" "sg_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Allow egress all protocol ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
}