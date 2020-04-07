data "azurerm_client_config" "current" {}

resource "azurecaf_naming_convention" "keyvault" {
  name          = var.workspace
  prefix        = local.prefix
  resource_type = "kv"
  convention    = "cafrandom"
}


resource "azurerm_key_vault" "launchpad" {
    name                = azurecaf_naming_convention.keyvault.result
    location            = azurerm_resource_group.rg_security.location
    resource_group_name = azurerm_resource_group.rg_security.name
    tenant_id           = data.azurerm_client_config.current.tenant_id

    sku_name = "standard"

    tags = {
      tfstate   = var.workspace
      workspace = var.workspace
    }


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

# Required to test deployment of new versions of the launchpad with the rover.
resource "azurerm_key_vault_access_policy" "rover" {
  count = var.rover_pilot_client_id == null ? 0 : var.rover_pilot_client_id == var.logged_user_objectId ? 0 : 1

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


