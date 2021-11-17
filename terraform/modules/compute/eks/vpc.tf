resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    "Name"    = "${var.unit}-${var.env}-network-vpc"
    "Env"     = var.env
    "Code"    = "network"
    "Feature" = "vpc"
  }
}
