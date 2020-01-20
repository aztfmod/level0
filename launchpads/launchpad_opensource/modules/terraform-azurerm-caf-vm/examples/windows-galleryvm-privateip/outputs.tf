output "network_interface_ids" {

    value = module.vm_test.network_interface_ids
}

output "primary_network_interface_id" {
    value = module.vm_test.primary_network_interface_id
}

output "admin_username" {
    depends_on = [azurerm_virtual_machine.vm]
    value = local.os_profile.admin_username
}

# TODO - get a keyvault created to insert the ssh key and share the kv secret id instead
output "ssh_private_key_pem" {
    sensitive = true
    value = module.vm_test.ssh_private_key_pem
}

output "msi_system_principal_id" {
    value = module.vm_test.msi_system_principal_id
}

output "name" {
    value = module.vm_test.name
}

output "id" {
    value = module.vm_test.id
}

output "object" {
    sensitive = true
    value = module.vm_test
}
