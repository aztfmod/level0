provider "azurerm" {
  features {}
}

provider "azurecaf" {}

terraform {
  required_providers {
    azurerm = "~> 2.2.0"
    azuread = "~> 0.7.0"
    random  = "~> 2.2.1"
    null    = "~> 2.1.0"
    tls     = "~> 2.1.1"
  }
}

provider "azuredevops" {
  version = "~> 0.0.1"

  org_service_url       = var.azure_devops_url_organization
  personal_access_token = var.azure_devops_pat_token
}


data "azurerm_subscription" "primary" {}


# Used to make sure delete / re-create generate brand new names and reduce risk of being throttled during dev activities
# used to enable multiple developers to work against the same subscription
resource "random_string" "prefix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}

locals {
  landingzone_tag          = {
    "landingzone" = basename(abspath(path.root))
  }
  tags              = merge(var.tags, local.landingzone_tag, {"workspace" = var.workspace})
  launchpad-blob-name = var.tf_name
  prefix            = var.use_prefix == true ? "${random_string.prefix.result}-" : ""
}
