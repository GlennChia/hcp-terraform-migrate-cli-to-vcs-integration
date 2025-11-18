resource "tfe_project" "this" {
  organization = var.tf_organization_name
  name         = "test-cli-to-vcs-project"
}

resource "tfe_workspace" "this" {
  name           = "test-cli-to-vcs-workspace"
  organization   = var.tf_organization_name
  queue_all_runs = true
  project_id     = tfe_project.this.id
  force_delete   = true
  auto_apply     = false
}
