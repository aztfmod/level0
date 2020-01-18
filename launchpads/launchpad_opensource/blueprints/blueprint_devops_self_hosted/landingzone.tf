module "blueprint_networking" {
  source = "../../blueprints/blueprint_networking"
  
  prefix                  = local.prefix
  tags                    = local.tags
  # resource_groups         = var.blueprint_networking.resource_groups
  networking_object       = var.blueprint_networking.networking_object
  log_analytics_workspace = local.log_analytics_workspace
  diagnostics_map         = local.diagnostics_map
}


module "blueprint_container_registry" {
  source = "../../blueprints/blueprint_container_registry"
  
  prefix                  = local.prefix
  tags                    = local.tags
  log_analytics_workspace = local.log_analytics_workspace
  diagnostics_map         = local.diagnostics_map
  acr_object              = var.blueprint_container_registry.acr_object
  subnet_id               = module.blueprint_networking.subnet_id_by_name["devopsAgent"]
}

module "blueprint_devops_self_hosted_agent" {
  source = "../../blueprints/blueprint_virtual_machine"
  
  prefix                  = local.prefix
  tags                    = local.tags
  log_analytics_workspace = local.log_analytics_workspace
  diagnostics_map         = local.diagnostics_map
  vm_object               = var.blueprint_devops_self_hosted_agent.vm_object
  subnet_id               = lookup(module.blueprint_networking.subnet_id_by_name, "devopsAgent")
  acr_object              = module.blueprint_container_registry.object
}

