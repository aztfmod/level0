
output "object" {
    value = {
        private_ip_address              = module.networking_interface.object.private_ip_address
        public_ip_address               = module.public_ip.ip_address
        admin_username                  = module.vm.admin_username
        msi_system_principal_id         = module.vm.msi_system_principal_id
    }
}

output "ssh_private_key_pem_secret_id" {
    value =  module.vm.ssh_private_key_pem_secret_id
}