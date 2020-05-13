provider "azurerm" {
  features {}
}

provider "azurecaf" {}

terraform {
  required_providers {
    azurerm = "~> 2.8.0"
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

resource "random_string" "alpha1" {
    length  = 1
    special = false
    upper   = false
    number  = false
}

locals {
  landingzone_tag          = {
    "landingzone" = local.launchpad
  }
  tags                = merge(var.tags, local.landingzone_tag, {"workspace" = var.workspace}, {"rover_version" = var.rover_version})
  launchpad-blob-name = var.tf_name
  prefix              = var.prefix == null ? random_string.prefix.result : var.prefix
  prefix_with_hyphen  = local.prefix == "" ? "" : "${local.prefix}-"
  prefix_start_alpha  = local.prefix == "" ? "" : "${random_string.alpha1.result}${local.prefix}"
  launchpad           = basename(abspath(path.root))
}
