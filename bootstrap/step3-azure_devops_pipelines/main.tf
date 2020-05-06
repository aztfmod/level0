provider "azurerm" {
  features {}
}

provider "azuredevops" {
  org_service_url       = var.azure_devops_organization_url
  personal_access_token = var.pat_full_access_scope
}

terraform {
  required_providers {
    azurerm = "~> 2.8.0"
    azuredevops = "~> 0.0.1" 
    azuread = "~> 0.8.0"
    random  = "~> 2.2.1"
    null    = "~> 2.1.0"
  }
}

data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}
