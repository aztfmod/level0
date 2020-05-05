data "azuredevops_projects" "project" {
    project_name = var.azure_devops_project
}

# DEVOPS VARIABLES
resource "azuredevops_variable_group" "release-level0-boostrap" {
  project_id   = data.azuredevops_projects.project.projects.*.project_id[0]
  name         = "release-level0-bootstrap"
  description  = "Managed by Terraform release-level0-boostrap"
  allow_access = false

  variable {
    name  = "ARM_CLIENT_ID"
    value = azuread_application.bootstrap.application_id
  }
  variable {
    name  = "ARM_CLIENT_SECRET"
    value = azuread_service_principal_password.bootstrap.value
    is_secret = true

  }
  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = data.azurerm_client_config.current.subscription_id
  }
  variable {
    name  = "ARM_TENANT_ID"
    value = data.azurerm_client_config.current.tenant_id
  }
}

