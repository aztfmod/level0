module "rg_test" {
  source  = "aztfmod/caf-resource-group/azurerm"
  version = "0.1.1"
  
    prefix          = local.prefix
    resource_groups = local.resource_groups
    tags            = local.tags
}

# to be enabled for vnext log analytics/diagnostics extension
# module "la_test" {
#   source  = "aztfmod/caf-log-analytics/azurerm"
#   version = "1.0.0"
  
#     convention          = local.convention
#     location            = local.location
#     name                = local.name
#     solution_plan_map   = local.solution_plan_map 
#     prefix              = local.prefix
#     resource_group_name = module.rg_test.names.test
#     tags                = local.tags
# }

# module "diags_test" {
#   source  = "aztfmod/caf-diagnostics-logging/azurerm"
#   version = "1.0.0"

#   convention            = local.convention
#   name                  = local.name
#   resource_group_name   = module.rg_test.names.test
#   prefix                = local.prefix
#   location              = local.location
#   tags                  = local.tags
#   enable_event_hub      = false
# }

resource "azurerm_virtual_network" "vm_test" {
  name                = "${local.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = local.location 
  resource_group_name = module.rg_test.names.test
}

resource "azurerm_subnet" "subnet_test" {
  name                 = "internal"
  resource_group_name  = module.rg_test.names.test
  virtual_network_name = azurerm_virtual_network.vm_test.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "nic_test" {
  name                = "${local.prefix}-nic"
  location            = local.location
  resource_group_name = module.rg_test.names.test

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet_test.id
    private_ip_address_allocation = "Dynamic"
  }
}

module "vm_test" {
  source = "../../"
  
  prefix                      = local.prefix
  convention                  = local.convention
  name                        = local.name
  resource_group_name         = module.rg_test.names.test
  location                    = local.location 
  tags                        = local.tags
  # to be enabled for vnext log analytics/diagnostics extension
  # log_analytics_workspace_id  = module.la_test.id
  # diagnostics_map             = module.diags_test.diagnostics_map
  # diagnostics_settings        = local.diagnostics

  network_interface_ids       = [azurerm_network_interface.nic_test.id]
  primary_network_interface_id= azurerm_network_interface.nic_test.id
  os                          = local.os
  os_profile                  = local.os_profile
  storage_image_reference     = local.storage_image_reference
  storage_os_disk             = local.storage_os_disk
  vm_size                     = local.vm_size
}

