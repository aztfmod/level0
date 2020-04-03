module "caf_name_stg" {
  source  = "aztfmod/caf-naming/azurerm"
  version = "~> 0.1.0"
  
  name        = local.stg_name
  type        = "st"
  convention  = var.convention

}

locals {
  # storage account prefix
  stg_name = "tfstate"
}


resource "azurerm_storage_account" "stg" {
  name                     = module.caf_name_stg.st
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
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