#####
# Step 1 - Provision a VM
# Setp 2 - Install docker and azure cli
# Step 3 - Login Azure Devops
# Step 4 - Pull azure devops private image
# Step 5 - Register to agent pool

#####

# workaround to add a depends_on the module blueprint_devops_self_hosted_agent
data "azurerm_key_vault" "launchpad" {
  depends_on            = [azurerm_key_vault.launchpad, azurerm_key_vault_access_policy.developers_rover, azurerm_key_vault_access_policy.launchpad]
  name                  = azurerm_key_vault.launchpad.name
  resource_group_name   = azurerm_resource_group.rg_security.name
}

module "blueprint_devops_self_hosted_agent" {
  source = "./blueprints/blueprint_virtual_machine"
  
  convention              = var.convention
  resource_group_name     = azurerm_resource_group.rg_devops.name
  location                = azurerm_resource_group.rg_devops.location
  prefix                  = local.prefix
  tags                    = local.tags
  log_analytics_workspace = module.log_analytics.object
  diagnostics_map         = module.diagnostics.diagnostics_map
  vm_object               = var.blueprint_devops_self_hosted_agent.vm_object
  public_ip               = var.blueprint_devops_self_hosted_agent.public_ip
  subnet_id               = lookup(module.blueprint_networking.subnet_id_by_name, "DevopsBuildSandpit", null)
  key_vault_id            = data.azurerm_key_vault.launchpad.id
}

# module "vm_provisioner" {  
#   source = "git://github.com/aztfmod/terraform-azurerm-caf-provisioner.git?ref=1912"

#   host_connection               = module.blueprint_devops_self_hosted_agent.object.public_ip_address
#   scripts                       = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.scripts
#   scripts_param                 = [
#                                   module.blueprint_devops_self_hosted_agent.object.admin_username
#                                 ]
#   admin_username                = module.blueprint_devops_self_hosted_agent.object.admin_username
#   ssh_private_key_pem_secret_id = module.blueprint_devops_self_hosted_agent.ssh_private_key_pem_secret_id
#   os_platform                   = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.os_platform
# }


locals {
    docker_build_command = <<EOT
sudo docker build -t devops -f ./scripts/Docker/devops_agent.Dockerfile ./scripts/Docker
sudo docker tag devops ${module.blueprint_container_registry.object.login_server}/devops
sudo docker push ${module.blueprint_container_registry.object.login_server}/devops
EOT

    ## This command saves on the local rover volume the private ssh key required to allow the rover to login the docker host in the self hosted agent
    ssh_config_update = <<EOT
mkdir -p ~/.ssh
chmod 600 ~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private
echo "" >> ~/.ssh/config
echo "Host ${module.blueprint_devops_self_hosted_agent.object.public_ip_address}" >> ~/.ssh/config
echo "    IdentityFile ~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private" >> ~/.ssh/config
echo "    StrictHostKeyChecking no" >> ~/.ssh/config
EOT

    docker_ssh_command = <<EOT
ssh -T -i ~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private -l ${module.blueprint_devops_self_hosted_agent.object.admin_username} ${module.blueprint_devops_self_hosted_agent.object.public_ip_address} <<EOF
    az login --identity
    az acr login --name ${module.blueprint_container_registry.object.admin_username}
    docker pull ${module.blueprint_container_registry.object.login_server}/devops
EOF
EOT
}

###
##   1 - Loging the Azure container registry
## TODO - To be executed from the self hosted agent to leverage the MSI and remove password
###
resource "null_resource" "login_azure_container_registry" {
  provisioner "local-exec" {
      command = "pwd=${module.blueprint_container_registry.object.admin_password} printenv pwd | sudo docker login -u ${module.blueprint_container_registry.object.admin_username} --password-stdin ${module.blueprint_container_registry.object.login_server}"
        on_failure = fail
  }
}

##
#   2 - Build the azure devops image and push to the registry
## TODO - To be executed from the self hosted agent to leverage the MSI and remove password
##
resource "null_resource" "build_docker_image" {
    depends_on = [null_resource.login_azure_container_registry]

    provisioner "local-exec" {
        command = local.docker_build_command
        on_failure = fail
    }

    triggers = {
        docker_build_command    = sha256(local.docker_build_command)
        Dockerfile              = sha256(file("./scripts/Docker/devops_agent.Dockerfile"))
        login_server            = module.blueprint_container_registry.object.login_server
        admin_username          = module.blueprint_container_registry.object.admin_username
        admin_password          = module.blueprint_container_registry.object.admin_password
    }
}

## 
#   3 - Save the ssh key of the devops selfhosted server in the ~/.ssh/config
##
resource "null_resource" "ssh_config_update" {
    depends_on = [module.blueprint_devops_self_hosted_agent]

    count = var.save_devops_agent_ssh_key_to_disk ? 1 : 0

    provisioner "local-exec" {
        command = local.ssh_config_update
        on_failure = fail
    }

    triggers = {
        docker_build_command    = sha256(local.ssh_config_update)
        
    }
}



##
#   4 - Connect to the Azure devops server and pull the devops container from the registry
##
resource "null_resource" "pull_docker_image" {
    depends_on = [
        null_resource.build_docker_image,
        null_resource.ssh_config_update,
        azurerm_role_assignment.acr_pull,
        azurerm_role_assignment.acr_reader,
        null_resource.install_docker_and_tools
    ]

    provisioner "local-exec" {
        command = local.docker_ssh_command
        on_failure = fail
    }

    triggers = {
        docker_build_command    = sha256(local.docker_ssh_command)
        login_server            = module.blueprint_container_registry.object.login_server
        admin_username          = module.blueprint_container_registry.object.admin_username
        admin_password          = module.blueprint_container_registry.object.admin_password
    }
}

