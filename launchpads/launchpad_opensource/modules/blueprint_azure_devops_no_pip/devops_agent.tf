

resource "azurecaf_naming_convention" "stg" {
  name          = var.storage_account_name
  prefix        = var.prefix
  resource_type = "azurerm_storage_account"
  convention    = var.convention
}

resource "azurerm_storage_account" "devops" {
  name                     = azurecaf_naming_convention.stg.result
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_virtual_machine_extension" "devops" {
  name                 = "install_azure_devops_agent"

  virtual_machine_id    = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  #timestamp: use this field only to trigger a re-run of the script by changing value of this field.
  #           Any integer value is acceptable; it must only be different than the previous value.
  settings = jsonencode({
    "timestamp" : 6
  })
  protected_settings = jsonencode({
    "fileUris": ["${var.vm_object.agent_init_script}"],
    "commandToExecute": "bash devops_runtime_baremetal.sh '${var.azure_devops.url}' '${var.azure_devops_pat_token}' '${var.azure_devops.agent_pool.name}' '${var.azure_devops.agent_pool.agent_name_prefix}' '${var.azure_devops.agent_pool.num_agents}' '${var.vm_object.admin_username}' '${var.rover_version}'"
  })

}