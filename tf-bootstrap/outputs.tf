output "terraform_cloud_block" {
  description = "Copy this block to the tf-local folder for testing"
  value       = <<EOT
terraform {
  cloud {
    organization = "${var.tf_organization_name}"

    workspaces {
      name = "${tfe_workspace.this.name}"
    }
  }
}
EOT
}

output "github_html" {
  description = "GitHub repo URL"
  value       = github_repository.this.html_url
}