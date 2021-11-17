provider "github" {
  token        = data.aws_ssm_parameter.github_token.value
  owner        = data.aws_ssm_parameter.github_owner.value
}

resource "github_repository" "repo" {
  count       = var.env =="dev" ? 1:0
  name        = "${var.unit}-${var.code}-${var.feature}"
  description = "Repository for ${var.unit}-${var.code}-${var.feature} service"
  visibility  = "public"
  auto_init   = "true"
  lifecycle {
    prevent_destroy = false
  }
}

resource "github_branch" "dev" {
  count      = var.env =="dev" ? 1:0
  repository = github_repository.repo[0].name
  branch     = "dev"
}

# data "github_team" "team" {
#   slug = "core-team"
# }

# resource "github_team_repository" "repo_team" {
#   team_id    = data.github_team.team.id
#   repository = github_repository.repo[0].name
#   permission = "maintain"
# }

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
  depends_on = [github_repository.repo[0]]
}

resource "github_repository_webhook" "github_webhook" {
  repository = github_repository.repo[0].name
  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = "webhook-secret-${var.unit}-${var.env}-${var.code}-${var.feature}"
  }
  events = ["push"]
}