
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

module "vm" {
  # source  = "aztfmod/caf-vm/azurerm"
  # version = "~> 0.1.0"
  source = "git://github.com/aztfmod/terraform-azurerm-caf-vm.git?ref=LL-2001"

  prefix                      = var.prefix
  convention                  = var.convention
  name                        = var.vm_object.name
  resource_group_name         = var.resource_group_name
  location                    = var.location 
  tags                        = merge( lookup(var.vm_object, "tags", {}), local.tags)

  diagnostics_map             = var.diagnostics_map
  log_analytics_workspace_id  = var.log_analytics_workspace.id
  diagnostics_settings        = lookup(var.vm_object, "diagnostics_settings", null)

  network_interface_ids         = [ module.networking_interface.id ]
  primary_network_interface_id  = module.networking_interface.id
  os                            = var.vm_object.os
  os_profile                    = var.vm_object.os_profile
  storage_image_reference       = var.vm_object.storage_image_reference
  storage_os_disk               = var.vm_object.storage_os_disk
  vm_size                       = var.vm_object.vm_size
  key_vault_id                  = var.key_vault_id
}


