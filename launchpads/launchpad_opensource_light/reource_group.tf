resource "azurecaf_naming_convention" "rg" {
  name          = "${var.workspace}-terraform-state"
  prefix        = local.prefix
  resource_type = "rg"
  convention    = var.convention
}

resource "azurerm_resource_group" "rg" {
  name      = azurecaf_naming_convention.rg.result
  location  = var.location

  tags = local.tags
}