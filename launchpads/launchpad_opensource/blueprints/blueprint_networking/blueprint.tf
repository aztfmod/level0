# module "caf_name_rg" {
#   source  = "aztfmod/caf-naming/azurerm"
#   version = "~> 0.1.0"
  
#   name        = "${var.prefix}${var.workspace}-${var.networking_object.resource_group.name}"
#   type        = "rg"
#   convention  = var.convention
# }

# resource "azurerm_resource_group" "rg" {
#   name      = module.caf_name_rg.rg
#   location  = var.networking_object.resource_group.location
#   tags      = local.tags
# }

module "virtual_network" {
  source  = "aztfmod/caf-virtual-network/azurerm"
  version = "~> 1.0.0"

  prefix                    = var.prefix
  convention                = var.convention
  location                  = var.location
  virtual_network_rg        = var.resource_group_name
  networking_object         = var.networking_object
  tags                      = local.tags
  diagnostics_map           = var.diagnostics_map
  diagnostics_settings      = var.networking_object.diags
  log_analytics_workspace   = var.log_analytics_workspace
}

