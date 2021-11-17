terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-storage-s3-pipeline-prd.tfstate"
    profile = "99c-prd"
  }
}

module "s3_bucket" {
  source  = "../../../modules/storage"
  region  = "ap-southeast-1"
  unit    = "99c"
  env     = "prd"
  code    = "storage"
  feature = "s3-pipeline"
}