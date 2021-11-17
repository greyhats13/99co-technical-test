terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-network-prd.tfstate"
    profile = "99c-prd"
  }
}

module "vpc" {
  source               = "../../modules/network"
  region               = "ap-southeast-1"
  unit                 = "99c"
  env                  = "prd"
  code                 = "network"
  feature              = "vpc"
  sub                  = ["main", "subnet", "nat-gw", "igw", "rt"]
  creator              = "tf"
  vpc_cidr             = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
