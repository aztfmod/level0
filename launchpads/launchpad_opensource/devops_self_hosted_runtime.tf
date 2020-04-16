resource "null_resource" "install_docker_and_tools" {
    depends_on = [module.blueprint_devops_self_hosted_agent]

    connection {
        type        = "ssh"
        user        = module.blueprint_devops_self_hosted_agent.object.admin_username
        host        = module.blueprint_devops_self_hosted_agent.object.public_ip_address
        private_key = file("~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private")
        agent       = false 
    }

    
    # Deploy
    provisioner "file" {
        source      = "${path.module}/scripts/devops_runtime.sh"
        destination = "/home/${ module.blueprint_devops_self_hosted_agent.object.admin_username}/devops_runtime.sh"
    }

    # Execute
    provisioner "remote-exec" {
        inline = [
            "chmod +x /home/${module.blueprint_devops_self_hosted_agent.object.admin_username}/devops_runtime.sh; ",
            "/home/${module.blueprint_devops_self_hosted_agent.object.admin_username}/devops_runtime.sh ${module.blueprint_devops_self_hosted_agent.object.admin_username}"
        ]
    }

    # Cleanup
    provisioner "remote-exec" {
        inline = [
            "rm -f /home/${module.blueprint_devops_self_hosted_agent.object.admin_username}/devops_runtime.sh; ",
        ]
    }
}
