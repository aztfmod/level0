
output "subnet_id_by_name" {
  value = module.blueprint_networking.subnet_id_by_name
}

output "subnet_id_by_key" {
  value = module.blueprint_networking.subnet_id_by_key
}

output "vnet" {
  value = module.blueprint_networking.vnet
}

output "resource_groups" {
  value = {
    "tfstate"   = azurerm_resource_group.rg_tfstate.name
    "security"  = azurerm_resource_group.rg_security.name
    "network"   = azurerm_resource_group.rg_network.name
    "devops"    = azurerm_resource_group.rg_devops.name
  }
}


output "prefix" {
  value = random_string.prefix.result
}


output "keyvault_id" {
  value = azurerm_key_vault.launchpad.id
}

output "launchpad_application_id" {
  value = azuread_service_principal.launchpad.application_id
  sensitive = true
}

output "tfstate-blob-name" {
  value = local.launchpad-blob-name
}

output "log_analytics" {
  value = module.log_analytics
  sensitive = true
}

output "diagnostics" {
  value = module.diagnostics
  sensitive = true
}
