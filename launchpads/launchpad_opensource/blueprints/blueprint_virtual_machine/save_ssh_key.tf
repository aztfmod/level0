
locals {
    save_ssh_key_cmd = <<EOT
        cat <<EOF > ~/.ssh/${module.public_ip.ip_address}.private 
${base64decode(module.vm.private_ssh_key)}
EOF
    EOT
}


resource "null_resource" "save_ssh_key" {
    depends_on  = [module.vm]

    provisioner "local-exec" {
        command = "mkdir -p ~/.ssh"
        on_failure = fail
    }

    provisioner "local-exec" {
        command = local.save_ssh_key_cmd
        on_failure = fail
    }

}