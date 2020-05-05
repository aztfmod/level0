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
    "landingzone"     = local.launchpad
  }
  tags                = merge(var.tags, local.landingzone_tag, {"workspace" = var.workspace}, {"rover_version" = var.rover_version})
  launchpad-blob-name = var.tf_name
  prefix              = var.use_prefix == true ? random_string.prefix.result : null
  launchpad           = basename(abspath(path.root))
}
