resource "tfe_oauth_client" "github" {
  organization        = var.tf_organization_name
  organization_scoped = true # Whether or not the oauth client is scoped to all projects and workspaces in the organization. Defaults to true
  api_url             = "https://api.github.com"
  http_url            = "https://github.com"
  oauth_token         = var.github_token
  service_provider    = "github"
}