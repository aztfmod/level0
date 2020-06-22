

resource "azurerm_role_definition" "launchpad" {
  name        = "caf-${local.prefix_with_hyphen}${var.environment}-launchpad"
  scope       = data.azurerm_subscription.primary.id
  description = "Provide a least privilege role to the caf boostrap Azure AD application"

  permissions {
    actions     = [
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete"
    ]

  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "launchpad" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_id   = azurerm_role_definition.launchpad.id
  principal_id         = azuread_service_principal.launchpad.object_id
}