

# module "container_registry" {
#   source  = "aztfmod/caf-container-registry/azurerm"
#   version = "~> 2.0.0"

#   name                        = var.container_registry_name
#   convention                  = var.convention
#   max_length                  = "49"
#   resource_group_name         = azurerm_resource_group.rg_devops.name
#   location                    = azurerm_resource_group.rg_devops.location
#   prefix                      = local.prefix
#   tags                        = local.tags
#   admin_enabled               = false
#   sku                         = var.acr_object.sku

#   # Diagnostics and activity logs
#   la_workspace_id             = module.log_analytics.id
#   diagnostics_settings        = var.acr_object.diagnostics_settings
#   diagnostics_map             = module.diagnostics.diagnostics_map
# }


# resource "null_resource" "build_azure_devops_agent" {
#     depends_on = [
#         module.container_registry
#     ]

#  provisioner "local-exec" {
#       command = <<BASH
#         az acr build --image devops/agent:latest --registry ${module.container_registry.login_server} --file ./scripts/Docker/devops_agent.Dockerfile ./scripts/Docker/
# BASH

#     on_failure = fail
#   }
# }

