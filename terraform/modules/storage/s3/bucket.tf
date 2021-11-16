resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
  acl           = var.acl
  force_destroy = var.force_destroy   
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
    "Env"     = var.env
    "Unit"    = var.unit
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = var.sub
  }
  lifecycle {
    create_before_destroy = true
  }
}
