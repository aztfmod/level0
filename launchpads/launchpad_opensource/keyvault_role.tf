# resource "azurerm_role_assignment" "sp_tfstate_reader" {
#   scope                = "${data.azurerm_subscription.primary.id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.KeyVault/vaults/${azurerm_key_vault.tfstate.name}"
#   role_definition_name = "Reader"
#   principal_id         = azuread_service_principal.tfstate.object_id

# }

# resource "azurerm_role_assignment" "msi_tfstate_reader" {
#   scope                = "${data.azurerm_subscription.primary.id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.KeyVault/vaults/${azurerm_key_vault.tfstate.name}"
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.tfstate.principal_id
# }