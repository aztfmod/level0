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
  }
}

resource "azurerm_storage_container" "launchpad" {
  name                  = var.workspace
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_blob_contributor" {
  count = var.limited_privilege == 0 ? 1 : 0
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.logged_user_objectId
}