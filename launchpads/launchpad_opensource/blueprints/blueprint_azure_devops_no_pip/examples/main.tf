provider "azurerm" {
    features {}
}

module "devops" {
    source = "../"

    prefix                  = local.prefix
    agent_init_script       = var.blueprint_azure_devops_no_pip.agent_init_script
    subnet_id               = azurerm_subnet.devops.id
}

resource "random_string" "prefix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}

locals {
  prefix  = var.use_prefix == true ? random_string.prefix.result : "" 
}

resource "azurecaf_naming_convention" "rg_vnet" {
  name          = "vnet"
  prefix        = local.prefix
  resource_type = "azurerm_resource_group"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_vnet" {
  name     = azurecaf_naming_convention.rg_vnet.result
  location = var.location
}

resource "azurecaf_naming_convention" "vnet" {
  name          = "vnet"
  prefix        = local.prefix
  resource_type = "azurerm_virtual_network"
  convention    = var.convention
}

resource "azurerm_virtual_network" "vnet" {
  name                = azurecaf_naming_convention.vnet.result
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "devops" {
  name                 = "devops"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.0.0/24"
}