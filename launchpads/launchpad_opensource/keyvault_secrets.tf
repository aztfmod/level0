
## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "launchpad_resource_group" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name          = "launchpad-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_storage_account_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name         = "launchpad-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_prefix" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name         = "launchpad-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_blob_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name         = "launchpad-blob-name"
    value        = local.launchpad-blob-name
    key_vault_id = azurerm_key_vault.launchpad.id
}

# resource "azurerm_key_vault_secret" "tfstate_msi_client_id" {
#     name         = "tfstate-msi-client-id"
#     value        = azurerm_user_assigned_identity.tfstate.client_id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

# resource "azurerm_key_vault_secret" "tfstate_msi_principal_id" {
#     name         = "tfstate-msi-principal-id"
#     value        = azurerm_user_assigned_identity.tfstate.principal_id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

# resource "azurerm_key_vault_secret" "tfstate_msi_id" {
#     name         = "tfstate-msi-id"
#     value        = azurerm_user_assigned_identity.tfstate.id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

