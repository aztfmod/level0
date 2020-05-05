resource "azurecaf_naming_convention" "stg" {
  count = 5

  name          = "${var.resource_storage_tfstate_name_prefix}l${count.index}"
  prefix        = local.prefix
  resource_type = "azurerm_storage_account"
  convention    = "cafrandom"
}


resource "azurerm_storage_account" "stg" {
  count = 5

  name                     = azurecaf_naming_convention.stg[count.index].result
  resource_group_name      = azurerm_resource_group.rg_tfstate.name
  location                 = azurerm_resource_group.rg_tfstate.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    tfstate     = "level${count.index}"
    workspace   = var.workspace
    prefix      = random_string.prefix.result
    launchpad   = local.launchpad
  }
}

resource "azurerm_storage_container" "launchpad" {
  count = 5
  name                  = var.workspace
  storage_account_name  = azurerm_storage_account.stg[count.index].name
  container_access_type = "private"
}