# Allow Azure devops VM to use its MSI to pull the docker images

resource "azurerm_role_assignment" "acr_pull" {
    scope                   = module.blueprint_container_registry.object.id
    role_definition_name    = "AcrPull"
    principal_id            = module.blueprint_devops_self_hosted_agent.object.msi_system_principal_id
}

resource "azurerm_role_assignment" "acr_reader" {
    scope                   = module.blueprint_container_registry.object.id
    role_definition_name    = "Reader"
    principal_id            = module.blueprint_devops_self_hosted_agent.object.msi_system_principal_id
}