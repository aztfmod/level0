module "caf_name_gen" {
  source  = "aztfmod/caf-naming/azurerm"
  version = "~> 0.1.0"

  name    = var.name
  type    = "gen"
  convention  = var.convention
}

resource "azurerm_container_registry" "acr" {
  name                      = module.caf_name_gen.gen
  resource_group_name       = var.resource_group_name
  location                  = var.location
  sku                       = var.sku
  admin_enabled             = var.admin_enabled
  georeplication_locations  = var.georeplication_locations
  tags                      = local.tags
}