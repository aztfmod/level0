data "azuredevops_projects" "project" {
    project_name = var.azure_devops_project
}

## Variable groups
resource "azuredevops_variable_group" "vargroups" {

  for_each = var.variable_groups
    project_id   = data.azuredevops_projects.project.projects.*.project_id[0]
    name         = each.value.name
    description  = "Managed by Terraform - ${each.value.name}"
    allow_access = true

    dynamic "variable" {
      for_each = each.value.variables//lookup(each.value, variables, [])
      content {
        name  = variable.key 
        value = variable.value 
      }
    }
}

## Agent pools
## Those pools are created in the organization, not the project
resource "azuredevops_agent_pool" "pool" {
  for_each = var.agent_pools
    name = each.value.name
    auto_provision = false
}

## Pipelines for agent pools
resource "azuredevops_build_definition" "build_definition" {

  for_each = var.release_agents
    project_id      = data.azuredevops_projects.project.projects.*.project_id[0]
    name            = each.value.name
    path            = each.value.folder

    repository {
      repo_type     = "TfsGit"
      repo_name     = var.variable_groups.global.variables.CAF_CONFIG_REPO
      yml_path      = each.value.yaml
    }

}

