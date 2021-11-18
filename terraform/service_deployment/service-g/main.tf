terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-service-e-prd.tfstate"
    profile = "99c-prd"
  }
}

module "deployment" {
  source                   = "../../modules/service"
  region                   = "ap-southeast-1"
  unit                     = "99c"
  env                      = "prd"
  code                     = "service"
  feature                  = "e"
}
