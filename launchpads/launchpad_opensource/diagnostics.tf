
module "diagnostics" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "~> 2.0.1"

  name                  = "diag"
  convention            = var.convention
  resource_group_name   = azurerm_resource_group.rg_devops.name
  prefix                = local.prefix
  location              = azurerm_resource_group.rg_devops.location
  tags                  = local.tags

  enable_event_hub      = var.azure_diagnostics_logs_event_hub
}