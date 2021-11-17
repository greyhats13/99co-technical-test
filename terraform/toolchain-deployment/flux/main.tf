terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-flux-prd.tfstate"
    profile = "99c-prd"
  }
}

module "flux" {
  source    = "../../modules/flux"
  namespace = "flux-system"
  github_url = "ssh://git@github.com/99c/99c-toolchain-flux.git"
}
