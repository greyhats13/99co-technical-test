resource "aws_eip" "eip" {
  count = var.total_eip
  vpc   = true

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[3]}-${count.index}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[3]
    "Creator" = var.creator
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(aws_subnet.public_subnet)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[4]}-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[4]
    "Creator" = var.creator
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}
