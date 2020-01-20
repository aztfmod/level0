
# locals {

#     run_devops_command = <<EOT
#         ssh -l ${module.blueprint_devops_self_hosted_agent.object.admin_username} ${module.blueprint_devops_self_hosted_agent.object.host_connection} << EOF
#             docker run -d -e AZP_URL=https://dev.azure.com/azure-terraform -e AZP_TOKEN=ljjiusginwdoktcdgjitly53gwxqya4thes2xsi2akzkz4znwlja -e AZP_POOL="self-hosted-level0" ${module.blueprint_container_registry.object.login_server}/devops
        
#     EOT
# }

# ##
# #   4 - Connect to the Azure devops server and pull the devops container from the registry
# ##
# resource "null_resource" "run_devops_container" {
#     depends_on = [
#         null_resource.pull_docker_image
#     ]

#     provisioner "local-exec" {
#         command = local.run_devops_command
#     }

#     triggers = {
#         docker_build_command    = sha256(local.run_devops_command)

#         # Triggers from the dependency
#         docker_build_command    = sha256(local.docker_build_command)
#         login_server            = module.blueprint_container_registry.object.login_server
#         admin_username          = module.blueprint_container_registry.object.admin_username
#         admin_password          = module.blueprint_container_registry.object.admin_password
#     }
# }

