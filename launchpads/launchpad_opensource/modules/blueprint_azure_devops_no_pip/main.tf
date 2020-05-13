provider "azurerm" {
  features {}
}

provider "azurecaf" {}

terraform {
  required_providers {
    azurerm = "~> 2.8.0"
    null    = "~> 2.1.0"
    tls     = "~> 2.1.1"
  }
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

data "terraform_remote_state" "launchpad_opensource" {
  backend = "azurerm"
  config = {
    storage_account_name  = var.lowerlevel_storage_account_name
    container_name        = var.lowerlevel_container_name 
    resource_group_name   = var.lowerlevel_resource_group_name
    key                   = "launchpad_opensource.tfstate"
  }
}

locals {
  blueprint_tag = {
    "module" = basename(abspath(path.module))
  }
  tags                        = merge(var.tags, local.blueprint_tag)

  log_analytics_workspace_id  = data.terraform_remote_state.launchpad_opensource.outputs.log_analytics.id
  diagnostics_map             = data.terraform_remote_state.launchpad_opensource.outputs.diagnostics.diagnostics_map

  subnet_id_by_name           = data.terraform_remote_state.launchpad_opensource.outputs.subnet_id_by_name

  prefix                      = data.terraform_remote_state.launchpad_opensource.outputs.prefix
  keyvault_id                 = data.terraform_remote_state.launchpad_opensource.outputs.keyvault_id

}
