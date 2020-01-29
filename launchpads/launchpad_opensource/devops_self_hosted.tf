
module "blueprint_devops_self_hosted_agent" {
  source = "./blueprints/blueprint_virtual_machine"
  
  convention              = var.convention
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  prefix                  = local.prefix
  tags                    = local.tags
  log_analytics_workspace = module.log_analytics.object
  diagnostics_map         = module.diagnostics.diagnostics_map
  vm_object               = var.blueprint_devops_self_hosted_agent.vm_object
  public_ip               = var.blueprint_devops_self_hosted_agent.public_ip
  subnet_id               = module.blueprint_networking.subnet_id_by_name.devopsAgent
}
