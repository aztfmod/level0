# module "caf_name_rg" {
#   source  = "aztfmod/caf-naming/azurerm"
#   version = "~> 0.1.0"
#   # source = "git://github.com/aztfmod/terraform-azurerm-caf-naming.git?ref=ll-fixes"
  
#   name        = "${local.prefix}${var.workspace}-terraform-state"
#   type        = "rg"
#   convention  = "cafclassic"

# }

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