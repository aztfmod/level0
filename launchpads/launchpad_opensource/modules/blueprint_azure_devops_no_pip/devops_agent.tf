

resource "azurecaf_naming_convention" "stg" {
  name          = var.storage_account_name
  prefix        = var.prefix
  resource_type = "azurerm_storage_account"
  convention    = var.convention
}

resource "azurerm_storage_account" "devops" {
  name                     = azurecaf_naming_convention.stg.result
  location                 = local.location
  resource_group_name      = local.resource_group_name
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
  source                 = var.vm_object.agent_init_script
}


resource "azurerm_virtual_machine_extension" "devops" {
  name                 = "install_azure_devops_agent"

  virtual_machine_id    = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  #timestamp: use this field only to trigger a re-run of the script by changing value of this field.
  #           Any integer value is acceptable; it must only be different than the previous value.
  settings = jsonencode({
    "timestamp" : 6
  })
  protected_settings = jsonencode({
    "fileUris": ["${azurerm_storage_blob.devops.url}${data.azurerm_storage_account_blob_container_sas.devops_agent_init.sas}"],
    "commandToExecute": "bash devops_agent_init.sh '${var.azure_devops.url}' '${var.azure_devops_pat_token}' '${var.azure_devops.agent_pool.name}' '${var.azure_devops.agent_pool.agent_name_prefix}' 'devops/agent:latest' '${var.azure_devops.agent_pool.num_agents}' '${local.registry.login_server}'"
  })

  lifecycle {
    ignore_changes = [
      protected_settings
    ]
  }

}