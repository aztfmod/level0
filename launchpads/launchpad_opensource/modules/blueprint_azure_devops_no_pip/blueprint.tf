
resource "azurecaf_naming_convention" "stg" {
  name          = var.storage_account_name
  prefix        = var.prefix
  resource_type = "azurerm_storage_account"
  convention    = var.convention
}
