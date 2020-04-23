
# # Allow Azure devops VM to use its MSI to pull the docker images
# resource "azurerm_role_assignment" "acr_pull" {
#     scope                   = local.registry.id
#     role_definition_name    = "AcrPull"
#     principal_id            = azurerm_linux_virtual_machine.vm.identity.0.principal_id
# }

# resource "azurerm_role_assignment" "acr_reader" {
#     scope                   = local.registry.id
#     role_definition_name    = "Reader"
#     principal_id            = azurerm_linux_virtual_machine.vm.identity.0.principal_id
# }



