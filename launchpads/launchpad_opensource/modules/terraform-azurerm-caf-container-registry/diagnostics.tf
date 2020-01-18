module "diagnostics_acr" {
  source  = "aztfmod/caf-diagnostics/azurerm"
  version = "1.0.0"

  name                            = azurerm_container_registry.acr.name
  resource_id                     = azurerm_container_registry.acr.id
  log_analytics_workspace_id      = var.log_analytics_workspace_id
  diagnostics_map                 = var.diagnostics_map
  diag_object                     = var.diagnostics_settings
}