resource "azurerm_role_definition" "mgmt_role1" {
  name               = "management-group"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = [
      "Microsoft.Management/managementGroups/read",
      "Microsoft.Authorization/roleDefinitions/write"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/providers/Microsoft.Management/managementGroups/"
  ]
}

resource "azurerm_role_assignment" "mgmt_role1" {
  scope              = "/providers/Microsoft.Management/managementGroups/"
  role_definition_id = azurerm_role_definition.mgmt_role1.id
  principal_id       = azuread_service_principal.launchpad.object_id
}