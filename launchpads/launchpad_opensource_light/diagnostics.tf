locals {
    azure_diagnostics_logs_event_hub = false
}

module "diagnostics" {
  # source  = "aztfmod/caf-diagnostics-logging/azurerm"
  # version = "~>1.0.0"
  source = "git://github.com/aztfmod/terraform-azurerm-caf-diagnostics-logging.git?ref=2003-refresh"

  name                  = "diag"
  convention            = "cafrandom"
  resource_group_name   = azurerm_resource_group.rg.name
  prefix                = local.prefix
  location              = var.location
  tags                  = local.tags

  enable_event_hub      = local.azure_diagnostics_logs_event_hub
}