resource "azurecaf_naming_convention" "rg" {
  name          = var.resource_group_name
  prefix        = var.prefix
  resource_type = "rg"
  convention    = var.convention
}

resource "azurerm_resource_group" "devops" {
  name     = azurecaf_naming_convention.rg.result
  location = var.location
}

resource "azurecaf_naming_convention" "stg" {
  name          = var.storage_account_name
  prefix        = var.prefix
  resource_type = "azurerm_storage_account"
  convention    = var.convention
}

resource "azurerm_storage_account" "devops" {
  name                     = azurecaf_naming_convention.stg.result
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "devops" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.devops.name
  container_access_type = "private"
}


data "azurerm_storage_account_blob_container_sas" "devops_agent_init" {
  connection_string = azurerm_storage_account.devops.primary_connection_string
  container_name    = azurerm_storage_container.devops.name
  https_only        = true

  start  = timestamp()
  expiry = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(timestamp(), "1h"))

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

resource "azurerm_storage_blob" "devops" {
  name                   = "devops_agent_init.sh"
  storage_account_name   = azurerm_storage_account.devops.name
  storage_container_name = azurerm_storage_container.devops.name
  type                   = "Block"
  source                 = var.agent_init_script
}


# Create the networking card of the server
module "networking_interface" {
  source  = "aztfmod/caf-nic/azurerm"
  version = "~> 0.2.0"

  prefix                = var.prefix
  tags                  = local.tags
  resource_group_name   = azurerm_resource_group.devops.name
  location              = azurerm_resource_group.devops.location

  name                  = "nic"
  convention            = var.convention
  subnet_id             = var.subnet_id
}
