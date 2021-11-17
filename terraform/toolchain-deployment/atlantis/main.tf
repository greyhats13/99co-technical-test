terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "99c-toolchain-jenkins.tfstate"
    profile = "99c-prd"
  }
}

module "cloudflare" {
  source             = "../../modules/cloudflare"
  env                = var.env
  unit               = var.unit
  code               = var.code
  feature            = var.feature
  cloudflare_secrets = var.cloudflare_secrets
  zone_id            = var.cloudflare_secrets["zone_id"]
  type               = var.type
  ttl                = var.ttl
  proxied            = var.proxied
  allow_overwrite    = var.allow_overwrite
}

module "helm" {
  source     = "../../modules/helm"
  region     = "ap-southeast-1"
  env        = "prd"
  unit       = "99c"
  code       = "toolchain"
  feature    = "atlantis"
  repository = "https://charts.jetstack.io"
  chart      = "atlantis"
  values     = ["values.yaml"]
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
}