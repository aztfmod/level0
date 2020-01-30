data "azurerm_client_config" "current" {}


resource "azuread_group" "developers_rover" {
  name = "${random_string.prefix.result}-caf-level0-rover-developers"
}

resource "random_string" "kv_name" {
  length  = 23 - length(random_string.prefix.result)
  special = false
  upper   = false
  number  = true
}

resource "random_string" "kv_middle" {
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {
    kv_name = "${random_string.prefix.result}${random_string.kv_middle.result}${random_string.kv_name.result}"
}


resource "azurerm_key_vault" "launchpad" {
    name                = local.kv_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tenant_id           = data.azurerm_client_config.current.tenant_id

    sku_name = "standard"

    tags = {
      workspace = var.workspace
    }

    # access_policy {
    #   tenant_id       = data.azurerm_client_config.current.tenant_id
    #   object_id       = azuread_service_principal.launchpad.object_id

    #   key_permissions = []

    #   secret_permissions = [
    #     "Get",
    #     "List",
    #     "Set",
    #     "Delete"
    #   ]
    # }

    # access_policy {
    #   tenant_id       = data.azurerm_client_config.current.tenant_id
    #   object_id       = azuread_group.developers_rover.id

    #   key_permissions = []

    #   secret_permissions = [
    #     "Get",
    #     "List",
    #     "Set",
    #     "Delete"
    #   ]
    # }

    # ## Temp - to simply improvement of the launchpad. Let the loggedin user to have permissions
    # access_policy {
    #   tenant_id       = data.azurerm_client_config.current.tenant_id
    #   object_id       = var.logged_user_objectId

    #   key_permissions = []

    #   secret_permissions = [
    #       "Set",
    #       "Get",
    #       "List",
    #       "Delete"
    #   ]
    # }


}

resource "azurerm_key_vault_access_policy" "launchpad" {
  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_service_principal.launchpad.object_id

  key_permissions = []

  secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
  ]

}

resource "azurerm_key_vault_access_policy" "developer_group" {
  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_group.developers_rover.id

  key_permissions = []

  secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
  ]

}


# To allow deployment from developer machine - bootstrap
# Todo: add a condition
resource "azurerm_key_vault_access_policy" "developer" {
  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.logged_user_objectId

  key_permissions = []

  secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
  ]
}

resource "azurerm_key_vault_access_policy" "rover" {
  count = var.rover_pilot_client_id == "" ? 0 : 1

  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.rover_pilot_client_id

  key_permissions = []

  secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
  ]
}

