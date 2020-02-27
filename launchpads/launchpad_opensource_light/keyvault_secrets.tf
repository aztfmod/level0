
## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "launchpad_resource_group" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad]
    name          = "launchpad-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_storage_account_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad]
    name         = "launchpad-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_prefix" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad]
    name         = "launchpad-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_blob_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad]
    name         = "launchpad-blob-name"
    value        = local.launchpad-blob-name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_blob_container" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad]
    name         = "launchpad-blob-container"
    value        = azurerm_storage_container.launchpad.name
    key_vault_id = azurerm_key_vault.launchpad.id
}
