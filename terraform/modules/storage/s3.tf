provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

resource "aws_s3_bucket" "s3" {
  bucket        = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name    = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    Env     = var.env
  }
  lifecycle {
    create_before_destroy = true
  }
}
