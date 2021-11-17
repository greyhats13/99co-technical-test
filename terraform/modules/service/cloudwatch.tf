# Cloudwatch Group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${var.code}/${var.feature}"
  retention_in_days = 30
}
