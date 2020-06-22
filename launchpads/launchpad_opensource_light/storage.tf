resource "azurecaf_naming_convention" "stg" {
  name          = var.workspace
  prefix        = local.prefix
  resource_type = "st"
  convention    = "cafrandom"
}

resource "azurerm_storage_account" "stg" {
  name                     = azurecaf_naming_convention.stg.result
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "BlobStorage"
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

resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.logged_user_objectId
}

resource "azurerm_role_assignment" "storage_blob_contributor_launchpad" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.launchpad.object_id
}