#####
# Step 1 - Provision a VM
# Setp 2 - Login Azure Devops
# Step 3 - 

#####

module "blueprint_devops_self_hosted_agent" {
  source = "./blueprints/blueprint_virtual_machine"
  
  convention              = var.convention
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  prefix                  = local.prefix
  tags                    = local.tags
  log_analytics_workspace = module.log_analytics.object
  diagnostics_map         = module.diagnostics.diagnostics_map
  vm_object               = var.blueprint_devops_self_hosted_agent.vm_object
  public_ip               = var.blueprint_devops_self_hosted_agent.public_ip
  subnet_id               = lookup(module.blueprint_networking.subnet_id_by_name, "devopsAgent", null)
  key_vault_id             = azurerm_key_vault.launchpad.id
}

module "vm_provisioner" {
  source = "git://github.com/aztfmod/terraform-azurerm-caf-provisioner.git?ref=1912"

  host_connection               = module.blueprint_devops_self_hosted_agent.object.public_ip_address
  scripts                       = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.scripts
  scripts_param                 = [
                                  module.blueprint_devops_self_hosted_agent.object.admin_username
                                ]
  admin_username                = module.blueprint_devops_self_hosted_agent.object.admin_username
  ssh_private_key_pem_secret_id = module.blueprint_devops_self_hosted_agent.ssh_private_key_pem_secret_id
  os_platform                   = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.os_platform
}

##### Login Azure Devops

resource "null_resource" "login" {


    provisioner "local-exec" {
        command = local.arg_devops_login
    }

    triggers = {
        pat_token   = var.azure_devops_pat_token
        arg         = local.arg_devops_login
        time        = timestamp()               # force the login to be re-executed at evey call
    }
}

locals {
    arg_devops_login = <<EOT
        az extension add --name azure-devops --yes

        export AZURE_DEVOPS_EXT_PAT="${var.azure_devops_pat_token}"
        az devops configure --defaults project="${var.azure_devops_project}" organization="${var.azure_devops_url_organization}"
    EOT
}



locals {
    docker_build_command = <<EOT
        sudo docker build -t devops -f ./scripts/Docker/devops_agent.Dockerfile ./scripts/Docker

        sudo docker tag devops ${module.blueprint_container_registry.object.login_server}/devops

        sudo docker push ${module.blueprint_container_registry.object.login_server}/devops
    EOT

    ## This command saves on the local rover volume the private ssh key required to allow the rover to login the docker host in the self hosted agent
    ssh_config_update = <<EOT
        chmod 600 ~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private
        echo "" >> ~/.ssh/config
        echo "Host ${module.blueprint_devops_self_hosted_agent.object.public_ip_address}" >> ~/.ssh/config
        echo "    IdentityFile ~/.ssh/${module.blueprint_devops_self_hosted_agent.object.public_ip_address}.private" >> ~/.ssh/config
        echo "    StrictHostKeyChecking no" >> ~/.ssh/config
    EOT

    docker_ssh_command = <<EOT
        ssh -l ${module.blueprint_devops_self_hosted_agent.object.admin_username} ${module.blueprint_devops_self_hosted_agent.object.public_ip_address} << EOF
            az login --identity
            az acr login --name ${module.blueprint_container_registry.object.admin_username}
            docker pull ${module.blueprint_container_registry.object.login_server}/devops
    EOT
}

###
##   1 - Loging the Azure container registry
## TODO - To be executed from the self hosted agent to leverage the MSI and remove password
###
resource "null_resource" "login_azure_container_registry" {
  provisioner "local-exec" {
      command = "pwd=${module.blueprint_container_registry.object.admin_password} printenv pwd | sudo docker login -u ${module.blueprint_container_registry.object.admin_username} --password-stdin ${module.blueprint_container_registry.object.login_server}"
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
    }

    triggers = {
        docker_build_command    = sha256(local.docker_build_command)
        Dockerfile              = sha256(file("./scripts/Docker/devops_agent.Dockerfile"))
        login_server            = module.blueprint_container_registry.object.login_server
        admin_username          = module.blueprint_container_registry.object.admin_username
        admin_password          = module.blueprint_container_registry.object.admin_password
    }
}

# ##
# #   3 - Register the ssh key of the devops selfhosted server in the ~/.ssh/config
# ##
# resource "null_resource" "ssh_config_update" {
#     depends_on = [module.blueprint_devops_self_hosted_agent]

#     provisioner "local-exec" {
#         command = local.ssh_config_update
#     }

#     triggers = {
#         docker_build_command    = sha256(local.ssh_config_update)
#         ssh_key_sha             = sha512(file("~/.ssh/${module.blueprint_devops_self_hosted_agent.object.host_connection}.private"))
#     }
# }



# ##
# #   4 - Connect to the Azure devops server and pull the devops container from the registry
# ##
# resource "null_resource" "pull_docker_image" {
#     depends_on = [
#         null_resource.build_docker_image,
#         null_resource.ssh_config_update
#     ]

#     provisioner "local-exec" {
#         command = local.docker_ssh_command
#     }

#     triggers = {
#         docker_build_command    = sha256(local.docker_ssh_command)
#         login_server            = module.blueprint_container_registry.object.login_server
#         admin_username          = module.blueprint_container_registry.object.admin_username
#         admin_password          = module.blueprint_container_registry.object.admin_password
#     }
# }

