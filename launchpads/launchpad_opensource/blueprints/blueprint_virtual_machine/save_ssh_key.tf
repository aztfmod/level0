data "azurerm_key_vault_secret" "private_key_pem" {
  name         = module.vm.ssh_private_key_pem_secret_id.name
  key_vault_id = module.vm.ssh_private_key_pem_secret_id.key_vault_id
}

locals {
    save_ssh_key_cmd = <<EOT
        cat <<EOF > ~/.ssh/${module.public_ip.ip_address}.private 
${base64decode(data.azurerm_key_vault_secret.private_key_pem.value)}
EOF
    EOT
}


resource "null_resource" "save_ssh_key" {
    depends_on  = [module.vm]
    count       = var.vm_object.save_ssh_private_key_pem == true ? 1 : 0

    triggers = {
        command = local.save_ssh_key_cmd
    }

    provisioner "local-exec" {
        command = local.save_ssh_key_cmd
    }
}