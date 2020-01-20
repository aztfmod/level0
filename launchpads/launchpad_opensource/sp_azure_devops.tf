# resource "azuread_application" "devops" {
#   name                       = "${random_string.prefix.result}devops"
  
#   # Access to Azure Active Directory Graph
#   required_resource_access {
#     resource_app_id = "00000002-0000-0000-c000-000000000000"

#     # Directory.ReadWrite.All
#     resource_access {
#       id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#       type = "Role"
#     }

#     # Application.ReadWrite.All
#     resource_access {
#       id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
#       type = "Role"
#     }
#   }
# }

# resource "azuread_service_principal" "devops" {
#   application_id = azuread_application.devops.application_id
# }

# resource "azuread_service_principal_password" "devops" {
#   service_principal_id = azuread_service_principal.devops.id
#   value                = random_string.devops_password.result
#   end_date_relative    = "43200m"
# }

# resource "random_string" "devops_password" {
#     length  = 250
#     special = false
#     upper   = true
#     number  = true
# }

# ## Grant devops app contributor on the current subscription to be able to deploy the blueprint_azure_devops
# resource "azurerm_role_assignment" "devops_role1" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Owner"
#   principal_id         = azuread_service_principal.devops.object_id
# }



# ## Store the details in keyvault
# resource "azurerm_key_vault_secret" "devops_application_id" {
#     name         = "devops-application-id"
#     value        = azuread_application.devops.application_id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

# resource "azurerm_key_vault_secret" "devops_object_id" {
#     name         = "devops-service-principal-object-id"
#     value        = azuread_service_principal.devops.object_id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

# resource "azurerm_key_vault_secret" "devops_client_id" {
#     name         = "devops-service-principal-client-id"
#     value        = azuread_service_principal.devops.id
#     key_vault_id = azurerm_key_vault.tfstate.id
# }

# resource "azurerm_key_vault_secret" "devops_password" {
#     name         = "devops-service-principal-password"
#     value        = random_string.devops_password.result
#     key_vault_id = azurerm_key_vault.tfstate.id
# }


# ##
# #    Grant conscent to the azure ad application
# ##

# locals {
#   grant_admin_concent_command = "az ad app permission admin-consent --id ${azuread_application.devops.application_id}"
# }
# resource "null_resource" "grant_admin_concent" {
#     depends_on = [azurerm_role_assignment.devops_role1]

#     provisioner "local-exec" {
#         command = local.grant_admin_concent_command
#     }

#     triggers = {
#         grant_admin_concent_command    = sha256(local.grant_admin_concent_command)
#     }
# }