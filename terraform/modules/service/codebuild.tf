resource "aws_iam_role" "codebuild_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #not best practise, for testing purpose
}

resource "aws_codebuild_project" "build_project" {

  name          = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 60

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "STAGE"
      value = "BUILD"
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name = "SERVICE_NAME"
      value = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    }
  }

  cache {
    type = "LOCAL"
    modes = [
      "LOCAL_CUSTOM_CACHE",
      "LOCAL_DOCKER_LAYER_CACHE",
      "LOCAL_SOURCE_CACHE"
    ]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  vpc_config {
    vpc_id             = data.terraform_remote_state.network.outputs.network_vpc_id
    subnets            = data.terraform_remote_state.network.outputs.network_app_subnet_id
    security_group_ids = [aws_security_group.sg.id]
  }
}
