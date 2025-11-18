resource "github_repository" "this" {
  name               = "tf-test-migrate-workspace"
  description        = "repo created with basic tf configs to test migration from CLI to VCS"
  auto_init          = true # produces an initial commit
  gitignore_template = "Terraform"
  visibility         = "private"
}

resource "github_repository_file" "main_tf" {
  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: basic config"
  overwrite_on_create = true
  file                = "main.tf"
  content             = file("./tf-github-bootstrap/main.tf")
}
