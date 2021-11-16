resource "aws_kms_key" "kms" {
  description              = "Customer Managed Key ${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub} for most inodemi services"
  key_usage                = var.key_usage
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = var.policy
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = var.sub
  }
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
  target_key_id = aws_kms_key.kms.key_id
}
