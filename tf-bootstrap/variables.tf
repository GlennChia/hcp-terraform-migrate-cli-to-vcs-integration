variable "tf_token" {
  description = "HCP Terraform token"
  type        = string
  sensitive   = true
}

variable "tf_organization_name" {
  description = "HCP Terraform organization name"
  type        = string
}

variable "github_token" {
  description = "A GitHub OAuth / Personal Access Token. When not provided or made available via the GITHUB_TOKEN environment variable, the provider can only access resources available anonymously"
  type        = string
  sensitive   = true
}
