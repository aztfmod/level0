
provider "azuredevops" {
  org_service_url       = var.azure_devops_organization_url
  personal_access_token = var.pat_full_access_scope
}

terraform {
  required_providers {
    azuredevops = "~> 0.0.1" 
  }
}
