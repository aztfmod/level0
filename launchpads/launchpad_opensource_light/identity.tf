###
#   Azure AD Application
###
resource "azuread_application" "launchpad" {
  name                       = "${random_string.prefix.result}launchpad"

  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
        id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
        type = "Role"
      }
  }
}

resource "azuread_service_principal" "launchpad" {
  application_id = azuread_application.launchpad.application_id
}

resource "azuread_service_principal_password" "launchpad" {
  service_principal_id = azuread_service_principal.launchpad.id
  value                = random_string.launchpad_password.result
  end_date_relative     = "43200m"
}

resource "random_string" "launchpad_password" {
    length  = 250
    special = false
    upper   = true
    number  = true
}

###
#   Grant devops app contributor on the current subscription to be able to deploy the blueprint_azure_devops
###
resource "azurerm_role_assignment" "launchpad_role1" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.launchpad.object_id
}


###
#   Store values in keyvault secrets
###

resource "azurerm_key_vault_secret" "launchpad_name" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-name"
    value        = azuread_application.launchpad.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_application_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-application-id"
    value        = azuread_application.launchpad.application_id
    key_vault_id = azurerm_key_vault.launchpad.id
}


resource "azurerm_key_vault_secret" "launchpad_client_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-service-principal-client-id"
    value        = azuread_service_principal.launchpad.object_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_client_secret" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-service-principal-client-secret"
    value        = random_string.launchpad_password.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_tenant_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-tenant-id"
    value        = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_subscription_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer, azurerm_key_vault_access_policy.launchpad, azurerm_key_vault_access_policy.rover]
    name         = "launchpad-subscription-id"
    value        = data.azurerm_client_config.current.subscription_id
    key_vault_id = azurerm_key_vault.launchpad.id
}