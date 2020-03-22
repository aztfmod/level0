provider "azurerm" {
  version = "~> 2.2.0"
  features {}
}

terraform {
}

provider "azuread" {
  version = "~> 0.7.0"
}

provider "random" {
  version = "~> 2.2.1"
}

provider "null" {
  version = "~> 2.1.0"
}

provider "tls" {
  version = "~> 2.1.1"
}

provider "azurecaf" {
  
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
    "landingzone"     = basename(abspath(path.root))
  }
  tags                = merge(var.tags, local.landingzone_tag, {"workspace" = var.workspace})
  launchpad-blob-name = var.tf_name
  prefix              = var.use_prefix == true ? random_string.prefix.result : ""
}
