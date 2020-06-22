resource "azurecaf_naming_convention" "rg_tfstate" {
  name          = var.resource_group_tfstate
  prefix        = local.prefix
  resource_type = "azurerm_resource_group"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_tfstate" {
  name      = azurecaf_naming_convention.rg_tfstate.result
  location  = var.location

  tags = local.tags
}

resource "azurecaf_naming_convention" "rg_security" {
  name          = var.resource_group_security
  prefix        = local.prefix
  resource_type = "azurerm_resource_group"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_security" {
  name      = azurecaf_naming_convention.rg_security.result
  location  = var.location

  tags = local.tags
}

resource "azurecaf_naming_convention" "rg_devops" {
  name          = var.resource_group_devops
  prefix        = local.prefix
  resource_type = "azurerm_resource_group"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_devops" {
  name      = azurecaf_naming_convention.rg_devops.result
  location  = var.location

  tags = local.tags
}

resource "azurecaf_naming_convention" "rg_network" {
  name          = var.resource_group_networking
  prefix        = local.prefix
  resource_type = "azurerm_resource_group"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_network" {
  name      = azurecaf_naming_convention.rg_network.result
  location  = var.location

  tags = local.tags
}
