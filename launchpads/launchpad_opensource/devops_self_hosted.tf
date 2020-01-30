
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
  subnet_id               = lookup(module.blueprint_networking.subnet_id_by_name, "devopsAgent", null)
  keyvault_id             = azurerm_key_vault.launchpad.id
}

module "vm_provisioner" {
  source = "git://github.com/aztfmod/terraform-azurerm-caf-provisioner.git?ref=1912"

  host_connection               = module.blueprint_devops_self_hosted_agent.host_connection
  scripts                       = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.scripts
  scripts_param                 = [
                                  var.blueprint_devops_self_hosted_agent.vm_object.os_profile.admin_username
                                ]
  admin_username                = var.blueprint_devops_self_hosted_agent.vm_object.os_profile.admin_username
  ssh_private_key_pem_secret_id = module.blueprint_devops_self_hosted_agent.ssh_private_key_pem_secret_id
  os_platform                   = var.blueprint_devops_self_hosted_agent.vm_object.caf-provisioner.os_platform
}