# Required resources to test the module
resource "azurerm_resource_group" "test" {
  name     = local.name
  location = local.location
}

resource "azurerm_virtual_network" "test" {
  name                = "acceptanceTestVirtualNetwork1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefix       = "10.0.1.0/24"
}

# Testing the module
module "test_nic" {
  source = "../../"

  prefix              = local.prefix
  tags                = local.tags
  location            = local.location
  resource_group_name = azurerm_resource_group.test.name
  nic_objects         = local.nic_objects.nics
  pip_objects         = lookup(local.pip_objects, "pips", null)
  subnet_id           = azurerm_subnet.test.id
}

