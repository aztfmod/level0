resource "azurecaf_naming_convention" "stg" {
  name          = var.workspace
  prefix        = local.prefix
  resource_type = "st"
  convention    = "cafrandom"
}

locals {
  # storage account prefix
  stg_name = "tfstate"
}


resource "azurerm_storage_account" "stg" {
  name                     = azurecaf_naming_convention.stg.result
  resource_group_name      = azurerm_resource_group.rg_tfstate.name
  location                 = azurerm_resource_group.rg_tfstate.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    tfstate     = var.workspace
    workspace   = var.workspace
    prefix      = random_string.prefix.result
    launchpad   = local.launchpad
  }
}

resource "azurerm_storage_container" "launchpad" {
  name                  = var.workspace
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}