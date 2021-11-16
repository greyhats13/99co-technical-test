provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

data "terraform_remote_state" "avn_network" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-network-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name               = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-cluster"
  # capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  # default_capacity_provider_strategy {
  #   capacity_provider = "FARGATE_SPOT"
  # }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
