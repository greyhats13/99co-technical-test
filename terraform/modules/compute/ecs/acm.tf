resource "aws_acm_certificate" "acm" {
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = ["*.${var.domain_name}"]
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-acm"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = "${var.feature[0]}-acm"
    "Domain"  = var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}
