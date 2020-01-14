output "storage_account_name" {
  value = azurerm_storage_account.stg.name
}

output "container" {
  value = azurerm_storage_container.tfstate.name
}

output "resource_group" {
  value = azurerm_resource_group.rg.name
}


output "prefix" {
  value = random_string.prefix.result
}


output "tfstate_map" {
  value = map(
    "storage_account_name", azurerm_storage_account.stg.name,
    "container", azurerm_storage_container.tfstate.name,
    "resource_group", azurerm_resource_group.rg.name,
    "prefix", random_string.prefix.result
  )
}

# output "deployment_msi" {
#   value = map(
#     "id", azurerm_user_assigned_identity.tfstate.id,
#     "principal_id", azurerm_user_assigned_identity.tfstate.principal_id,
#     "client_id", azurerm_user_assigned_identity.tfstate.client_id
#   )
# }

output "keyvault_id" {
  value = azurerm_key_vault.tfstate.id
}

output "devops_application_id" {
  value = azuread_service_principal.devops.application_id
  sensitive = true
}

output "devops_client_secret" {
  value = random_string.devops_password.result
  sensitive = true
}

output "tfstate-blob-name" {
  value = local.tfstate-blob-name
}
