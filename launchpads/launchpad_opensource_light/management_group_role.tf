#
# Grant permissions to the launchpad application to create management groups in the tenant
#
resource "azurerm_role_assignment" "management_group_contributor" {
  scope                 = "/providers/Microsoft.Management/managementGroups/${data.azurerm_client_config.current.tenant_id}"
  role_definition_name  = "Management Group Contributor"
  principal_id          = azuread_service_principal.launchpad.id
}