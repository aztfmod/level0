###
## Resource group to store the networking cards and the VM
###
resource "azurerm_resource_group" "rg" {
  name      = var.vm_object.resource_group.name
  location  = var.vm_object.resource_group.location
  tags      = local.tags
}

# TODO: Remove when PAW included in the launchpad
# Create the public ip to connect the server through ssh
module "public_ip" {
  source = "../../modules/terraform-azurerm-caf-public-ip"

  

  name                      = lookup(var.vm_object.public_ip, "name", null)
  rg                        = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  tags                      = merge(lookup(var.vm_object.public_ip, "tags", null), local.tags)

  ip_addr                   = lookup(var.vm_object.public_ip, "ip_addr", null)

  diagnostics_settings      = lookup(var.vm_object.public_ip, "diagnostics_settings", null)
  diagnostics_map           = var.diagnostics_map
  log_analytics_workspace_id  = var.log_analytics_workspace.id
}

# TODO: more work to support multiple nic on different subnets
# Create the networking card of the server
module "networking_interface" {
  source = "../../modules/terraform-azurerm-caf-nic"

  prefix                    = var.prefix
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  tags                      = local.tags
  nic_objects               = var.vm_object.nic_objects.nics
  pips_id_by_key            = module.public_ip.id_by_key
  subnet_id                 = var.subnet_id
}


# Create the virtual machine
module "vm" {
  source = "../../modules/terraform-azurerm-caf-vm"

  prefix                        = var.prefix
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  tags                          = local.tags
  convention                    = var.convention

  name                          = var.vm_object.name
  os                            = var.vm_object.os
  os_profile                    = var.vm_object.os_profile
  storage_os_disk               = var.vm_object.storage_os_disk
  storage_image_reference       = var.vm_object.storage_image_reference
  network_interface_ids         = module.networking_interface.nic_ids
  primary_network_interface_id  = module.networking_interface.objects[var.vm_object.nic_objects.primary_nic_key].id
  vm_size                       = var.vm_object.vm_size  
}


module "vm_provisioner" {
  source = "../../modules/terraform-azurerm-caf-provisioner"

  host_connection               = lookup(module.public_ip.fqdn_by_key, var.vm_object.nic_objects.remote_host_pip)
  scripts                       = var.vm_object.caf-provisioner.scripts
  scripts_param                 = [
                                  var.vm_object.os_profile.admin_username
                                ]
  admin_username                = module.vm.admin_username
  ssh_private_key_pem           = module.vm.ssh_private_key_pem
  os_platform                   = var.vm_object.caf-provisioner.os_platform
}
