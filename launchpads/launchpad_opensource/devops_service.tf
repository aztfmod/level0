# data "azuredevops_projects" "projects" {
#   project_name  = var.azure_devops.azure_devops_project.name
# }


// This section creates a project
# resource "azuredevops_project" "release" {
#   count = length(data.azuredevops_projects.projects.projects) == 0 ? 1 : 0
  
#   project_name       = var.azure_devops.azure_devops_project.name
#   visibility         = var.azure_devops.azure_devops_project.visibility
#   version_control    = var.azure_devops.azure_devops_project.version_control
#   work_item_template = var.azure_devops.azure_devops_project.work_item_template
# }


# // Create the agent pools
# resource "azuredevops_agent_pool" "pools" {
#   for_each        = var.azure_devops.agent_pools

#   name            = each.value.name
#   pool_type       = lookup(each.value, "pool_type", null)
#   auto_provision  = lookup(each.value, "auto_provision", null)
# }