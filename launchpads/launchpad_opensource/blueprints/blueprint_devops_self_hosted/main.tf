terraform {
    required_version = ">= 0.12.6"
    backend "azurerm" {
    }
}

provider "azurerm" {
  version = "<= 1.40.0"
}

provider "null" {
  version = "<=2.1.2"
}

provider "tls" {
  version = "<=2.1.1"
}

provider "random" {
  version = "<=2.2.1"
}

data "azurerm_subscription" "current" {}

data "terraform_remote_state" "landingzone_caf_foundations" {
  backend = "azurerm"
  config = {
    storage_account_name  = var.lowerlevel_storage_account_name
    container_name        = var.lowerlevel_container_name 
    resource_group_name   = var.lowerlevel_resource_group_name
    key                   = "landingzone_caf_foundations.tfstate"
  }
}


locals {    
    landingzone_tag          = {
      "landingzone" = basename(abspath(path.root))
    }
    
    prefix                    = "${data.terraform_remote_state.landingzone_caf_foundations.outputs.prefix}-"
    tags                      = merge(data.terraform_remote_state.landingzone_caf_foundations.outputs.tags, local.landingzone_tag)
    blueprint_foundations     = data.terraform_remote_state.landingzone_caf_foundations.outputs.blueprint_foundations

    location                  = local.blueprint_foundations["location"]
    log_analytics_workspace   = local.blueprint_foundations["log_analytics_workspace"]
    diagnostics_map           = local.blueprint_foundations["diagnostics_map"]       
}

