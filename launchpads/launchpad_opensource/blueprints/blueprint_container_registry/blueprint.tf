
module "container_registry" {
  source  = "aztfmod/caf-container-registry/azurerm"
  version = "~> 1.0.0"

  name                        = var.acr_object.name
  convention                  = var.convention
  rg                          = var.resource_group_name
  location                    = var.location
  prefix                      = var.prefix
  tags                        = local.tags
  admin_enabled               = var.acr_object.admin_enabled
  sku                         = var.acr_object.sku

  # Diagnostics and activity logs
  la_workspace_id             = var.log_analytics_workspace.id
  diagnostics_settings        = var.acr_object.diagnostics_settings
  diagnostics_map             = var.diagnostics_map
}