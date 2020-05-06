

resource "azurerm_role_definition" "bootstrap" {
  name        = "caf-boostrap"
  scope       = data.azurerm_subscription.primary.id
  description = "Provide a least privilege role to the caf boostrap Azure AD application"

  permissions {
    actions     = [
        "Microsoft.Authorization/roleAssignments/write",
        "Microsoft.Resources/subscriptions/read",
        "Microsoft.Authorization/roleAssignments/read",
        "Microsoft.Authorization/roleAssignments/delete",
        "Microsoft.Resources/subscriptions/providers/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "bootstrap" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_id   = azurerm_role_definition.bootstrap.id
  principal_id         = data.terraform_remote_state.step1.outputs.bootstrap_service_principal_object_id
}