###
#   Azure AD Application
###
resource "azuread_application" "launchpad" {
  name                       = "${random_string.prefix.result}launchpad"
  # Access to Azure Active Directory Graph
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    # Directory.ReadWrite.All
    resource_access {
      id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
      type = "Role"
    }

    # Application.ReadWrite.All
    resource_access {
      id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
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

# resource "azurerm_user_assigned_identity" "tfstate" {
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   name = "${random_string.prefix.result}tfstate_msi"
# }

# resource "azurerm_role_assignment" "tfstate_role1" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Owner"
#   principal_id         = azuread_service_principal.tfstate.object_id
# }


###
#    Grant conscent to the azure ad application
###

locals {
  grant_admin_concent_command = "az ad app permission admin-consent --id ${azuread_application.launchpad.application_id}"
}
resource "null_resource" "grant_admin_concent" {
    depends_on = [azurerm_role_assignment.launchpad_role1]

    provisioner "local-exec" {
        command = local.grant_admin_concent_command
    }

    triggers = {
        grant_admin_concent_command    = sha256(local.grant_admin_concent_command)
    }
}

###
#   Store values in keyvault secrets
###

resource "azurerm_key_vault_secret" "launchpad_name" {
    name         = "launchpad-name"
    value        = azuread_application.launchpad.name
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_application_id" {
    name         = "launchpad-application-id"
    value        = azuread_application.launchpad.application_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_object_id" {
    name         = "launchpad-service-principal-object-id"
    value        = azuread_service_principal.launchpad.object_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_client_id" {
    name         = "launchpad-service-principal-client-id"
    value        = azuread_service_principal.launchpad.application_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_client_secret" {
    name         = "launchpad-service-principal-client-secret"
    value        = random_string.launchpad_password.result
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_tenant_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name         = "launchpad-tenant-id"
    value        = data.azurerm_client_config.current.tenant_id
    key_vault_id = azurerm_key_vault.launchpad.id
}

resource "azurerm_key_vault_secret" "launchpad_subscription_id" {
    depends_on    = [azurerm_key_vault_access_policy.developer]
    name         = "launchpad-subscription-id"
    value        = data.azurerm_client_config.current.subscription_id
    key_vault_id = azurerm_key_vault.launchpad.id
}