data "azurerm_client_config" "current" {}

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

    # Must be set as bellow to force the permissions to be re-applied by TF if changed outside of TF (portal, powershell...)
    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_service_principal.launchpad.object_id
      application_id  = azuread_service_principal.launchpad.application_id

      key_permissions = []

      secret_permissions = [
          "set",
          "get",
          "list",
          "delete"
      ]
    }

    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_group.developers_rover.id

      key_permissions = []

      secret_permissions = [
          "set",
          "get",
          "list",
          "delete"
      ]
    }

    ## Temp - to simply improvement of the launchpad. Let the loggedin user to have permissions
    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = var.logged_user_objectId

      key_permissions = []

      secret_permissions = [
          "set",
          "get",
          "list",
          "delete"
      ]
    }


}

# To allow deployment from developer machine - bootstrap
# Todo: add a condition
resource "azurerm_key_vault_access_policy" "developer" {
  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.logged_user_objectId

  key_permissions = []

  secret_permissions = [
      "set",
      "get",
      "list",
      "delete"
  ]
}

resource "azurerm_key_vault_access_policy" "rover" {
  count = var.rover_pilot_object_id == "" ? 0 : 1

  key_vault_id = azurerm_key_vault.launchpad.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.rover_pilot_object_id

  key_permissions = []

  secret_permissions = [
      "set",
      "get",
      "list",
      "delete"
  ]
}



resource "azuread_group" "developers_rover" {
  name = "${random_string.prefix.result}-caf-level0-rover-developers"
}
