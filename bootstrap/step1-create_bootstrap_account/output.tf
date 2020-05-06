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