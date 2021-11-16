resource "aws_eip" "eip" {
  count = 2
  vpc   = true

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[2]}-${count.index}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = var.sub[2]
  }
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[2]}-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = var.sub[2]
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}
