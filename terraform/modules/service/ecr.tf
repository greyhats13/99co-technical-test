##### ECR
resource "aws_ecr_repository" "ecr_php" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-php"
}

resource "aws_ecr_lifecycle_policy" "ecr_policy_php" {
  repository = aws_ecr_repository.ecr_php.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}

resource "aws_ecr_repository" "ecr_nginx" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-nginx"
}

resource "aws_ecr_lifecycle_policy" "ecr_policy_nginx" {
  repository = aws_ecr_repository.ecr_nginx.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}
