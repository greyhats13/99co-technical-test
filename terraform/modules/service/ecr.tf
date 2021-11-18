##### ECR
resource "aws_ecr_repository" "ecr" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}"
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_php.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}