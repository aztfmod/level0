output "id" {
    description = "The Container Registry ID."
    value = azurerm_container_registry.acr.id
}

output "login_server" {
    description = "The URL that can be used to log into the container registry."
    value = azurerm_container_registry.acr.login_server
}

output "admin_username" {
    description = "The Username associated with the Container Registry Admin account - if the admin account is enabled"
    value = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
    description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
    sensitive = true
    value = azurerm_container_registry.acr.admin_password
}