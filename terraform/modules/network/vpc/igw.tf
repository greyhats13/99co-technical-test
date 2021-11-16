resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[3]}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = var.sub[3]
  }
}
