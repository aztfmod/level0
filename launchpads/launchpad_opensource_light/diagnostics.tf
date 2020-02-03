locals {
    azure_diagnostics_logs_event_hub = false
}

module "diagnostics" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "~>1.0.0"

  name                  = "diag"
  convention            = var.convention
  resource_group_name   = azurerm_resource_group.rg.name
  prefix                = local.prefix
  location              = var.location
  tags                  = local.tags

  enable_event_hub      = local.azure_diagnostics_logs_event_hub
}