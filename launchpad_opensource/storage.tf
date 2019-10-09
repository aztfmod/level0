resource "azurerm_resource_group" "rg" {
  name     = "${random_string.prefix.result}-terraform-state"
  location = "southeastasia"

    tags = {
    blueprint  = "tfstate"
  }
}

resource "random_string" "stg" {
    length  = 17
    upper   = false
    special = false
}


locals {

  # must start with a letter
  stg_name = "tfstate${random_string.stg.result}"
}


resource "azurerm_storage_account" "stg" {
  name                     = "${local.stg_name}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    stgtfstate  = "level0"
    container   = "tfstate"
    prefix      = random_string.prefix.result
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.stg.name}"
  container_access_type = "private"
}