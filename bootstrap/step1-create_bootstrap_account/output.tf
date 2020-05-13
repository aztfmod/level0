data "azuread_user" "logged_in_user" {
  object_id = data.azurerm_client_config.current.object_id
}

output "initialized_by_upn" {
  value = data.azuread_user.logged_in_user.user_principal_name
}

output "initialized_by_display_name" {
  value = data.azuread_user.logged_in_user.display_name
}

output "azure_ad_app_bootstrap_name" {
  value = azuread_application.bootstrap.name
}

output "bootstrap_service_principal_object_id" {
  value       = azuread_service_principal.bootstrap.object_id
  description = "Object ID of the bootstrap service principal of the Azure AD application"
}

output "bootstrap_ARM_CLIENT_ID" {
  value       = azuread_application.bootstrap.application_id
}

output "bootstrap_ARM_CLIENT_SECRET" {
  value       = azuread_service_principal_password.bootstrap.value
  sensitive   = true
}

output "bootstrap_ARM_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.current.subscription_id
}

output "bootstrap_ARM_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}

output "prefix" {
  value = local.prefix
}