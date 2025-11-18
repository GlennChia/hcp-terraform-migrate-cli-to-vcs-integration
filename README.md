# Terraform from OSS to CLI-driven workflow to Version Control workflow

# 1. Architecture

![architecture diagram](./docs/01-architecture/01-architecture-diagram.png)

- Part 1: Run terraform apply locally in [tf-local/](./tf-local/)
- Part 2: Modify [main.tf](./tf-local/main.tf) with the `terraform` block referencing the specific workspace
- Part 3: Update the workspace settings to use the Version Control workflow

# 2. Deployment

The code provided in [tf-bootstrap/](./tf-bootstrap/) bootstraps a GitHub repository with the Terraform configuration in [tf-github-bootstrap/main.tf](./tf-bootstrap/tf-github-bootstrap/main.tf) that matches [tf-local/main.tf](./tf-local/main.tf). It also creates a Terraform project, and a workspace that will be the target of the workspace migration. Finally, it creates a Terraform GitHub OAuth client that will be used during VCS integration.

![bootstrap](./docs/01-architecture/02-bootstrap.png)

Step 1: Copy [terraform.tfvars.example](./tf-bootstrap/terraform.tfvars.example) to `terraform.tfvars` and adjust the variables accordingly.

Step 2: In [tf-bootstrap/](./tf-bootstrap/) run `terraform init` and `terraform apply --auto-approve`

# 3. Verify

## 3.1 GitHub repo

GitHub repo created with code from [tf-github-bootstrap/main.tf](./tf-bootstrap/tf-github-bootstrap/main.tf).

![github repo](./docs/02-deployment/01-github-repo/01-github-repo.png)

## 3.2 Terraform workspace

An empty workspace is created. Copy the `terraform` block in the `Example code` section. This is used later in [4.2 Migrate state to HCP Terraform/TFE](#42-migrate-state-to-hcp-terraformtfe)

![workspace](./docs/02-deployment/02-tf/01-workspace.png)

# 4. Testing

## 4.1 Run terraform locally

Current [tf-local/main.tf](./tf-local/main.tf)

![local files](./docs/03-testing/01-local-state/01-local-files.png)

Run `terraform init`. This creates the `.terraform` folder and `.terraform.lock.hcl` file

![terraform init](./docs/03-testing/01-local-state/02-terraform-init.png)

Run `terraform apply`. This creates the resource and creates a `terraform.tfstate` file

![terraform apply](./docs/03-testing/01-local-state/03-terraform-apply.png)

## 4.2 Migrate state to HCP Terraform/TFE

Add `terraform` block that was copied from [3.2 Terraform workspace](#32-terraform-workspace) to [tf-local/main.tf](./tf-local/main.tf)

![tf cloud block](./docs/03-testing/02-local-state-to-tf-state/01-tf-cloud-block.png)

Create a `~/.terraformrc` file with the token following:

```hcl
credentials "app.terraform.io" {
  token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
}
```

![tf token](./docs/03-testing/02-local-state-to-tf-state/02-tf-token.png)

Run `terraform init` and enter `yes` at the prompt. This migrates the state to HCP Terraform/TFE.

![terraform init](./docs/03-testing/02-local-state-to-tf-state/03-terraform-init.png)

The local `terraform.tfstate` file is now empty

![terraform state empty](./docs/03-testing/02-local-state-to-tf-state/04-terraform-state-empty.png)

A `terraform.tfstate.backup` file is created locally

![terraform state backup](./docs/03-testing/02-local-state-to-tf-state/05-terraform-state-backup.png)

In HCP Terraform/TFE, the workspace overview shows 1 resource and 1 output. This matches the terraform apply.

![workspace overview](./docs/03-testing/02-local-state-to-tf-state/06-workspace-overview.png)

Workspace states shows the state that was migrated

![workspace states](./docs/03-testing/02-local-state-to-tf-state/07-workspace-states.png)

View the state contents

![workspace state](./docs/03-testing/02-local-state-to-tf-state/08-workspace-state.png)

## 4.3 Change to version control integration

In the workspace settings choose `Version Control` -> `Connect to version control`

![connect to version control](./docs/03-testing/03-cli-to-vcs/01-connect-to-version-control.png)

Choose `Version Control Workflow`

![version control workflow](./docs/03-testing/03-cli-to-vcs/02-version-control-workflow.png)

Then choose `GitHub.com (Custom)`. This GitHub OAuth Client was created in [tf-bootstrap/02-tfc-github-oauth-token.tf](./tf-bootstrap/02-tfc-github-oauth-token.tf)

![connect to vcs](./docs/03-testing/03-cli-to-vcs/03-connect-to-vcs.png)

Choose the bootstrapped repository created in [tf-bootstrap/01-github-repo.tf](./tf-bootstrap/01-github-repo.tf). The repo is named `tf-test-migrate-workspace`

![choose repo](./docs/03-testing/03-cli-to-vcs/04-choose-repo.png)

Confirm changes

![confirm changes](./docs/03-testing/03-cli-to-vcs/05-confirm-changes.png)

Workspace settings now shows `Connected to VCS`

![connected to vcs](./docs/03-testing/03-cli-to-vcs/06-connected-to-vcs.png)

Workspace overview shows a plan was run against the latest commit.

![workspace overview](./docs/03-testing/03-cli-to-vcs/07-workspace-overview.png)

## 4.4 Test making a change

Make a change to the configuration in the GitHub repo.

![make a change](./docs/03-testing/04-test-change/01-make-a-change.png)

Commit the change

![commit change](./docs/03-testing/04-test-change/02-commit-change.png)

This starts a workspace plan

![workspace plan](./docs/03-testing/04-test-change/03-workspace-plan.png)

The workspace run shows an apply is pending. Choose `Confirm & apply`

![apply pending](./docs/03-testing/04-test-change/04-apply-pending.png)

Apply finished

![apply finished](./docs/03-testing/04-test-change/05-apply-finished.png)
