module "caf_name_rg" {
  source  = "aztfmod/caf-naming/azurerm"
  version = "~> 0.1.0"
  # source = "git://github.com/aztfmod/terraform-azurerm-caf-naming.git?ref=ll-fixes"
  
  name        = "${local.prefix}${var.workspace}-terraform-state"
  type        = "rg"
  convention  = "cafclassic"

}

resource "azurerm_resource_group" "rg" {
  name      = module.caf_name_rg.rg
  location = var.location

  tags = local.tags
}