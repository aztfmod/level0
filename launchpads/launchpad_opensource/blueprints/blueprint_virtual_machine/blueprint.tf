
# TODO: Remove when PAW included in the launchpad
# Create the public ip to connect the server through ssh
module "public_ip" {
  source  = "aztfmod/caf-public-ip/azurerm"
  version = "~> 1.0.0"

  # Resource location
  rg                               = var.resource_group_name
  location                         = var.location
  tags                             = local.tags

  # IP Address details
  name                             = var.public_ip.ip_name
  convention                       = var.convention
  ip_addr                          = var.public_ip

  # Diagnostics
  diagnostics_map                  = var.diagnostics_map
  log_analytics_workspace_id       = var.log_analytics_workspace.id
  diagnostics_settings             = var.public_ip.diagnostics_settings
}

# TODO: more work to support multiple nic on different subnets
# Create the networking card of the server
module "networking_interface" {
  source  = "aztfmod/caf-nic/azurerm"
  version = "~> 0.2.0"

  prefix                = var.prefix
  tags                  = local.tags
  resource_group_name   = var.resource_group_name
  location              = var.location

  name                  = var.vm_object.nic_object.name
  convention            = var.convention

  subnet_id             = var.subnet_id
  public_ip_address_id  = module.public_ip.id
}


# # Create the virtual machine
# module "vm" {
#   source = "../../modules/terraform-azurerm-caf-vm"

#   prefix                        = var.prefix
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   tags                          = local.tags
#   convention                    = var.convention

#   name                          = var.vm_object.name
#   os                            = var.vm_object.os
#   os_profile                    = var.vm_object.os_profile
#   storage_os_disk               = var.vm_object.storage_os_disk
#   storage_image_reference       = var.vm_object.storage_image_reference
#   network_interface_ids         = module.networking_interface.nic_ids
#   primary_network_interface_id  = module.networking_interface.objects[var.vm_object.nic_objects.primary_nic_key].id
#   vm_size                       = var.vm_object.vm_size  
# }


# module "vm_provisioner" {
#   source = "../../modules/terraform-azurerm-caf-provisioner"

#   host_connection               = lookup(module.public_ip.fqdn_by_key, var.vm_object.nic_objects.remote_host_pip)
#   scripts                       = var.vm_object.caf-provisioner.scripts
#   scripts_param                 = [
#                                   var.vm_object.os_profile.admin_username
#                                 ]
#   admin_username                = module.vm.admin_username
#   ssh_private_key_pem           = module.vm.ssh_private_key_pem
#   os_platform                   = var.vm_object.caf-provisioner.os_platform
# }
