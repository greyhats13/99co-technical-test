provider "github" {
  token        = data.aws_ssm_parameter.github_token.value
  owner        = data.aws_ssm_parameter.github_owner.value
}

resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "webhook-codepipeline-${var.unit}-${var.env}-${var.code}-${var.feature}"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = "webhook-secret-${var.unit}-${var.env}-${var.code}-${var.feature}"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/main"
  }
}

resource "github_repository_webhook" "github_webhook" {
  repository = "99co-backend"
  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = "webhook-secret-${var.unit}-${var.env}-${var.code}-${var.feature}"
  }
  events = ["push"]
}