
output "object" {
    value = {
        host_connection                 = module.public_ip.fqdn_by_key[var.vm_object.nic_objects.remote_host_pip]
        fqdn                            = module.public_ip.fqdn_by_key
        admin_username                  = module.vm.admin_username
        script_os_platform              = "centos"
        msi_system_principal_id         = module.vm.msi_system_principal_id
    }
}