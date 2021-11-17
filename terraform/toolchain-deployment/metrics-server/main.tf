terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "99c-toolchain-metrics-server.tfstate"
    profile = "99c-prd"
  }
}

module "helm" {
  source             = "../../modules/helm"
  region             = "ap-southeast-1"
  env                = "prd"
  unit               = "99c"
  code               = "toolchain"
  feature            = "metrics-server"
  repository         = "https://kubernetes-sigs.github.io/metrics-server/"
  chart              = "metrics-server"
  values             = []
  helm_sets          = []
  override_namespace = "kube-system"
  no_env             = true
}
