provider "azurerm" {
  features {}
}

provider "azurecaf" {}

terraform {
  required_providers {
    azurerm = "~> 2.6.0"
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
    container_name        = var.workspace 
    resource_group_name   = var.lowerlevel_resource_group_name
    key                   = "launchpad_opensource.tfstate"
  }
}

locals {
  blueprint_tag = {
    "module" = basename(abspath(path.module))
  }
  tags                        = merge(var.tags, local.blueprint_tag)
  registry                    = data.terraform_remote_state.launchpad_opensource.outputs.registry
  resource_groups             = data.terraform_remote_state.launchpad_opensource.outputs.resource_groups

  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = local.resource_groups[var.vm_object.resource_group_key]

  log_analytics_workspace_id  = data.terraform_remote_state.launchpad_opensource.outputs.log_analytics.id
  diagnostics_map             = data.terraform_remote_state.launchpad_opensource.outputs.diagnostics.diagnostics_map

  subnet_id_by_name           = data.terraform_remote_state.launchpad_opensource.outputs.subnet_id_by_name

  keyvault_id                 = data.terraform_remote_state.launchpad_opensource.outputs.keyvault_id

}

data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}