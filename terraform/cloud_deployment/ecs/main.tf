terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-eks-prd.tfstate"
    profile = "99c-prd"
  }
}

module "eks" {
  source                           = "../../modules/compute/ecs"
  region                           = "ap-southeast-1"
  unit                             = "99c"
  env                              = "prd"
  code                             = "compute"
  feature                          = ["eks"]
}
