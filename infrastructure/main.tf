terraform {
  required_version = ">= 0.13"

  required_providers {
    github = {
      source = "integrations/github"
      version = ">= 4.5.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.13"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

provider "flux" {}

provider "kubectl" {}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}
