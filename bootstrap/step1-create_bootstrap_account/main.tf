provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = "~> 2.8.0"
    azuread = "~> 0.8.0"
    random  = "~> 2.2.1"
    null    = "~> 2.1.0"
  }
}

data "azurerm_client_config" "current" {}

resource "random_string" "prefix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}

locals{
  prefix  = var.use_prefix == true ? "${random_string.prefix.result}-" : ""
}