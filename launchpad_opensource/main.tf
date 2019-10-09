provider "azurerm" {
  version = "=1.33.1"
}

provider "azuread" {
  version = "=0.6.0"
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
  tfstate-blob-name = "level0_launchpad.tfstate"
}
