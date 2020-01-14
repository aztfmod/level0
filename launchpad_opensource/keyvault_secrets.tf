# The data object waits for the permissions to be set before it can be used by the provider
data "azuread_application" "tfstate" {
    depends_on      = [
        azurerm_key_vault.tfstate, 
        azurerm_role_assignment.sp_tfstate_reader, 
        azurerm_role_assignment.tfstate_role1,
        null_resource.grant_admin_concent
    ]
    name            = azuread_application.tfstate.name
}

provider "azurerm" {
    # client_id       = data.azuread_application.tfstate.application_id
    client_id          = "c7607f52-2e2e-4953-a421-aa48a025db6d"
    client_secret   = random_string.tfstate_password.result
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id

    alias           = "sp_tfstate"
}


## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "tfstate_resource_group" {
    provider      = azurerm.sp_tfstate

    name          = "tfstate-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_storage_account_name" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_container" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-container"
    value        = azurerm_storage_container.tfstate.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_prefix" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_blob_name" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-blob-name"
    value        = local.tfstate-blob-name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_client_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-client-id"
    value        = azurerm_user_assigned_identity.tfstate.client_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_principal_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-principal-id"
    value        = azurerm_user_assigned_identity.tfstate.principal_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-id"
    value        = azurerm_user_assigned_identity.tfstate.id
    key_vault_id = azurerm_key_vault.tfstate.id
}

### Service Principal for devops 
resource "azurerm_key_vault_secret" "tfstate_sp_devops_subscription_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-sp-devops-subscription-id"
    value        = data.azurerm_client_config.current.subscription_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_client_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-sp-devops-client-id"
    value        = azuread_service_principal.devops.application_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_client_secret" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-sp-devops-client-secret"
    value        = random_string.devops_password.result
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_sp_devops_tenant_id" {
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-sp-devops-tenant-id"
    value        = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.tfstate.id
}