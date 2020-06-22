resource "azurecaf_naming_convention" "stg" {
  count = 1

  name          = "${var.resource_storage_tfstate_name_prefix}l${count.index}"
  prefix        = local.prefix
  resource_type = "azurerm_storage_account"
  convention    = "cafrandom"
}


resource "azurerm_storage_account" "stg" {
  count = 1

  name                     = azurecaf_naming_convention.stg[count.index].result
  resource_group_name      = azurerm_resource_group.rg_tfstate.name
  location                 = azurerm_resource_group.rg_tfstate.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    tfstate     = "level${count.index}"
    workspace   = var.workspace
    prefix      = random_string.prefix.result
    launchpad   = local.launchpad
  }
}

resource "azurerm_storage_container" "launchpad" {
  count = 1
  name                  = var.workspace
  storage_account_name  = azurerm_storage_account.stg[count.index].name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_blob_contributor_developers_rover_level0" {
  scope                = azurerm_storage_account.stg.0.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.devops_rover.id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}

resource "azurerm_role_assignment" "storage_blob_contributor_bootstrap" {
  scope                = azurerm_storage_account.stg.0.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.logged_user_objectId

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}
