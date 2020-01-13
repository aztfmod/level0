resource "azuread_application" "tfstate" {
  name                       = "${random_string.prefix.result}tfstate"
    # Access to Azure Active Directory Graph
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    # Read and Write all applications
    resource_access {
      id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "tfstate" {
  application_id = azuread_application.tfstate.application_id
}

resource "azuread_service_principal_password" "tfstate" {
  service_principal_id = azuread_service_principal.tfstate.id
  value                = random_string.tfstate_password.result
  end_date_relative     = "43200m"
}

resource "random_string" "tfstate_password" {
    length  = 250
    special = false
    upper   = true
    number  = true
}

resource "azurerm_user_assigned_identity" "tfstate" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "${random_string.prefix.result}tfstate_msi"
}

resource "azurerm_role_assignment" "tfstate_role1" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.tfstate.object_id
}

