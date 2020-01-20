locals {
    ssh_private_key_pem = base64decode(module.vm.ssh_private_key_pem)

    save_ssh_key_cmd = <<EOT
        cat <<EOF > ~/.ssh/${lookup(module.public_ip.fqdn_by_key, var.vm_object.nic_objects.remote_host_pip)}.private 
${local.ssh_private_key_pem}
EOF
    EOT
}


resource "null_resource" "save_ssh_key" {
    depends_on  = [module.vm_provisioner]
    count       = var.vm_object.save_ssh_private_key_pem == true ? 1 : 0

    triggers = {
        command = local.save_ssh_key_cmd
    }

    provisioner "local-exec" {
        command = local.save_ssh_key_cmd
    }
}