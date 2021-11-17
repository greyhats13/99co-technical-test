resource "aws_iam_role" "codepipeline_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #not best practise, for testing purpose
}

resource "aws_codepipeline" "codepipeline" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  role_arn   = aws_iam_role.codepipeline_role.arn
  depends_on = [aws_codebuild_project.build_project]

  artifact_store {
    location = data.terraform_remote_state.s3.outputs.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["Source"]

      configuration = {
        Owner                = data.aws_ssm_parameter.github_owner.value
        OAuthToken           = data.aws_ssm_parameter.github_token.value
        Repo                 = github_repository.repo[0].name
        Branch               = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["Source"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = data.terraform_remote_state.ecs.outputs.compute_ecs_id
        ServiceName = "${var.unit}-${var.env}-${var.code}-${var.feature}"
        FileName    = "${var.unit}-${var.env}-${var.code}-${var.feature}.json"
      }
    }
  }
}
