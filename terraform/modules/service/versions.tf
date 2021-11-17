terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    github = {
      source = "integrations/github"
    }
  }
  required_version = ">= 1.0"
}
