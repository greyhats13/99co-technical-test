resource "aws_iam_role" "task_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "task_policy" {
  name   = "${var.unit}-${var.env}-${var.code}-${var.feature}-policy-name"
  role   = aws_iam_role.task_role.id
  policy = var.iam_policy
}

resource "aws_ssm_parameter" "role_arn" {
  name   = "/${var.unit}/${var.env}/secret/${var.code}/${var.feature}/IAM_ROLE_ARN"
  type   = "SecureString"
  value  = aws_iam_role.task_role.arn
  key_id = data.terraform_remote_state.kms.outputs.kms_alias_arn
}

resource "aws_iam_role" "task_execution_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "task_execution_policy" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-task-exeuction-policy"
  role = aws_iam_role.task_execution_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:Describe*",
          "ssm:Get*",
          "ssm:List*"
        ],
        "Resource" : "*"
      }
    ]
  })
}
