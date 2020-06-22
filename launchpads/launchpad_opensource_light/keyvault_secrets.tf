
## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "launchpad_resource_group" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azuread_application.launchpad]
    name          = "launchpad-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_storage_account_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_prefix" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_blob_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-blob-name"
    value        = local.launchpad-blob-name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_blob_container" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-blob-container"
    value        = azurerm_storage_container.launchpad.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

###
#   Store values identity in keyvault secrets
###

resource "azurerm_key_vault_secret" "launchpad_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-name"
    value        = azuread_application.launchpad.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_application_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-application-id"
    value        = azuread_application.launchpad.application_id
    key_vault_id = azurerm_key_vault.launchpad.id
}


resource "azurerm_key_vault_secret" "launchpad_client_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-service-principal-client-id"
    value        = azuread_service_principal.launchpad.object_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_client_secret" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-service-principal-client-secret"
    value        = random_password.launchpad.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_tenant_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-tenant-id"
    value        = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_subscription_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad,  azuread_application.launchpad]
    name         = "launchpad-subscription-id"
    value        = data.azurerm_client_config.current.subscription_id
    key_vault_id = azurerm_key_vault.launchpad.id
}