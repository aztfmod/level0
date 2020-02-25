resource "azuread_group" "developers_rover" {
  count = var.enable_collaboration == true ? 1 : 0

  name = "${local.prefix}caf-level0-rover-developers"
}


###
#   Grant devops app contributor on the current subscription to be able to deploy the blueprint_azure_devops
###
resource "azurerm_role_assignment" "developers_rover" {
  count = var.enable_collaboration == true ? 1 : 0
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.developers_rover.0.id
}

resource "azurerm_key_vault_access_policy" "developers_rover" {
  count = var.enable_collaboration == true ? 1 : 0
  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_group.developers_rover.0.id

  key_permissions = []

  secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
  ]

}

resource "azurerm_role_assignment" "storage_blob_contributor_developers_rover" {
  count = var.enable_collaboration == true ? 1 : 0
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_group.developers_rover.0.id
}