module "caf_name_rg" {
  source  = "aztfmod/caf-naming/azurerm"
  version = "~> 0.1.0"
  
  name        = "${local.prefix}${var.workspace}-terraform-state"
  type        = "rg"
  convention  = var.convention

}

resource "azurerm_resource_group" "rg" {
  name      = module.caf_name_rg.rg
  location = var.location

  tags = local.tags
}