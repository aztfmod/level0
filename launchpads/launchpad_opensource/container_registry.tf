
module "blueprint_container_registry" {
  source = "./blueprints/blueprint_container_registry"
  
  prefix                    = local.prefix
  convention                = var.convention
  tags                      = local.tags
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  workspace                 = var. workspace
  log_analytics_workspace   = module.log_analytics.object
  diagnostics_map           = module.diagnostics.diagnostics_map
  acr_object                = var.blueprint_container_registry.acr_object
  subnet_id                 =  lookup(module.blueprint_networking.subnet_id_by_name, "devopsAgent", null)
}