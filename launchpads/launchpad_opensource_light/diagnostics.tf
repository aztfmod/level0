locals {
    azure_diagnostics_logs_event_hub = false
}

module "diagnostics" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "2.0.1"

  name                  = "diag"
  convention            = "cafrandom"
  resource_group_name   = azurerm_resource_group.rg.name
  prefix                = local.prefix_start_alpha
  location              = var.location
  tags                  = local.tags

  enable_event_hub      = local.azure_diagnostics_logs_event_hub
}