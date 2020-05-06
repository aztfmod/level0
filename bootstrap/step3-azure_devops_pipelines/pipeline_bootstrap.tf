resource "azuredevops_variable_group" "release-level0-boostrap" {
  project_id   = data.azuredevops_projects.project.projects.*.project_id[0]
  name         = "release-level0-bootstrap"
  description  = "Managed by Terraform release-level0-boostrap"
  allow_access = true

  variable {
    name  = "ARM_CLIENT_ID"
    value = var.bootstrap_ARM_CLIENT_ID
  }
  variable {
    name  = "ARM_CLIENT_SECRET"
    value = var.bootstrap_ARM_CLIENT_SECRET
    is_secret = true

  }
  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = var.bootstrap_ARM_SUBSCRIPTION_ID
  }
  variable {
    name  = "ARM_TENANT_ID"
    value = var.bootstrap_ARM_TENANT_ID
  }
}