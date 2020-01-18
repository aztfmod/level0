
resource "azurerm_resource_group" "rg" {
  name      = var.networking_object.resource_group.name
  location  = var.networking_object.resource_group.location
  tags      = local.tags
}

module "virtual_network" {
  source  = "aztfmod/caf-virtual-network/azurerm"
  version = "0.2.0"

  prefix                    = var.prefix
  location                  = azurerm_resource_group.rg.location
  virtual_network_rg        = azurerm_resource_group.rg.name
  networking_object         = var.networking_object
  tags                      = local.tags
  diagnostics_map           = var.diagnostics_map
  diagnostics_settings      = var.networking_object.diags
  log_analytics_workspace   = var.log_analytics_workspace
}

