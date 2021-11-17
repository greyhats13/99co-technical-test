terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "99c-toolchain-cert-manager.tfstate"
    profile = "99c-prd"
  }
}

module "helm" {
  source     = "../../modules/helm"
  region     = "ap-southeast-1"
  env        = "prd"
  unit       = "99c"
  code       = "toolchain"
  feature    = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  values     = []
  helm_sets = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "controller.nodeSelector.service"
      value = "backend"
    }
  ]
  override_namespace = "kube-system"
  no_env             = true
}
