#
# Grant permissions to the launchpad application to create management groups
#
resource "azurerm_role_assignment" "management_group_contributor" {
  scope                 = "/providers/Microsoft.Management/managementGroups/"
  role_definition_name  = "Management Group Contributor"
  principal_id          = azuread_service_principal.launchpad.id
}