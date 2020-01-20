output "network_interface_ids" {
    depends_on = [azurerm_virtual_machine.vm]
    value = azurerm_virtual_machine.vm.network_interface_ids
}

output "primary_network_interface_id" {
    depends_on = [azurerm_virtual_machine.vm]
    value = azurerm_virtual_machine.vm.primary_network_interface_id
}

output "admin_username" {
    depends_on = [azurerm_virtual_machine.vm]
    value = var.os_profile.admin_username
}

# TODO - get a keyvault created to insert the ssh key and share the kv secret id instead
output "ssh_private_key_pem" {
    depends_on = [azurerm_virtual_machine.vm]
    # sensitive = true
    value = base64encode(tls_private_key.ssh.private_key_pem)
}

output "msi_system_principal_id" {
    value = azurerm_virtual_machine.vm.identity.0.principal_id
}

output "name" {
  value = azurerm_virtual_machine.vm.name
}

output "id" {
  value = azurerm_virtual_machine.vm.id
}

output "object" {
    sensitive = true
    value = azurerm_virtual_machine.vm.id
}
