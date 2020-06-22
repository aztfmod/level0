
output "launchpad_ARM_CLIENT_ID" {
  value       = azuread_application.launchpad.application_id
}

output "launchpad_ARM_CLIENT_SECRET" {
  value       = azuread_service_principal_password.launchpad.value
  sensitive   = true
}

output "launchpad_ARM_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.current.subscription_id
}

output "launchpad_ARM_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}