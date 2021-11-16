data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 0 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-public-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = "subnet"
    "Sub"     = "${var.sub[1]}-public"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}

resource "aws_subnet" "node" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"                                                  = "${var.unit}-${var.env}-network-subnet-node-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"                                                   = var.env
    "Code"                                                  = var.code
    "Feature"                                               = "subnet"
    "Sub"                                                   = "node"
    "Zones"                                                 = element(data.aws_availability_zones.az.names, count.index)
    "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}"
  }
}

resource "aws_subnet" "app" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 2 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-app-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = "${var.sub[1]}-app"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}

resource "aws_subnet" "data" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 3 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-data-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = "${var.sub[1]}-data"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}
