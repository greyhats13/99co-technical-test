resource "aws_internet_gateway" "igw" {
  vpc_id   = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.unit}-${var.env}-${var.code}-${var.feature[2]}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[2]
    "Creator" = var.creator
  }
}