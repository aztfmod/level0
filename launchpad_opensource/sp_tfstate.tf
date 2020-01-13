resource "azuread_application" "tfstate" {
  name                       = "${random_string.prefix.result}tfstate"
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

