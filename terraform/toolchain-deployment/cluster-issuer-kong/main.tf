terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "99c-toolchain-cluster-issuer.tfstate"
    profile = "99c-prd"
  }
}

module "k8s" {
  source   = "../../modules/k8s"
  region   = "ap-southeast-1"
  env      = "prd"
  unit     = "99c"
  code     = "toolchain"
  feature  = "cluster-issuer"
  manifest = file("cluster-issuer.yaml")
}
