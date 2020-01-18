
## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "tfstate_resource_group" {
    name          = "tfstate-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_storage_account_name" {
    name         = "tfstate-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_container" {
    name         = "tfstate-container"
    value        = azurerm_storage_container.tfstate.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_prefix" {
    name         = "tfstate-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_blob_name" {
    name         = "tfstate-blob-name"
    value        = local.tfstate-blob-name
    key_vault_id = azurerm_key_vault.tfstate.id
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

### Service Principal for devops 
resource "azurerm_key_vault_secret" "tfstate_sp_devops_subscription_id" {
    name         = "tfstate-sp-devops-subscription-id"
    value        = data.azurerm_client_config.current.subscription_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_client_id" {
    name         = "tfstate-sp-devops-client-id"
    value        = azuread_service_principal.devops.application_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_client_secret" {
    name         = "tfstate-sp-devops-client-secret"
    value        = random_string.devops_password.result
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_tenant_id" {
    name         = "tfstate-sp-devops-tenant-id"
    value        = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.tfstate.id
}