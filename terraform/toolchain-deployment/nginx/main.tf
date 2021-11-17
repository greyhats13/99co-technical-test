terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "99c-toolchain-nginx.tfstate"
    profile = "99c-prd"
  }
}

module "helm" {
  source     = "../../modules/helm"
  region     = "ap-southeast-1"
  env        = "prd"
  unit       = "99c"
  code       = "toolchain"
  feature    = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  values     = []
  helm_sets = [
    {
      name  = "controller.replicaCount"
      value = 2
    },
    {
      name  = "controller.autoscaling.enabled"
      value = true
    },
    {
      name  = "controller.autoscaling.minReplicas"
      value = 2
    },
    {
      name  = "controller.autoscaling.maxReplicas"
      value = 256
    },
    {
      name  = "controller.nodeSelector.service"
      value = "backend"
    }
  ]
  override_namespace = "ingress"
  no_env             = true
}