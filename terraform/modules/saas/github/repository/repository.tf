resource "github_repository" "repository" {
  name         = "${var.unit}-${var.code}"
  description  = var.description
  visibility   = var.visibility
  auto_init    = var.auto_init
  has_issues   = var.has_issues
  has_projects = var.has_projects
  has_wiki     = var.has_wiki
  lifecycle {
    prevent_destroy = false
  }
}

resource "github_branch" "branch" {
  repository    = github_repository.repository.name
  source_branch = var.source_branch
  branch        = var.branch_name
}

resource "github_actions_environment_secret" "secret" {
  environment       = var.env
  secret_name       = var.secret_name
  plaintext_value   = var.plaintext_value
}
