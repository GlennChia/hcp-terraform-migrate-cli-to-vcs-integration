terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.65"
    }
    github = {
      source  = "integrations/github"
      version = ">=6.6.0"
    }
  }
}

provider "tfe" {
  token = var.tf_token
}

provider "github" {
  token = var.github_token
}