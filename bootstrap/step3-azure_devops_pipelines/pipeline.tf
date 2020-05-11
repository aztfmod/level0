data "azuredevops_projects" "project" {
    project_name = var.azure_devops_project
}

data "azuredevops_git_repositories" "repos" {
  project_id      = local.projects[var.azure_devops_project].project_id
}


locals {
    projects      = zipmap(tolist(data.azuredevops_projects.project.projects.*.name),  tolist(data.azuredevops_projects.project.projects) )
    repositories  = zipmap(tolist(data.azuredevops_git_repositories.repos.repositories.*.name),  tolist(data.azuredevops_git_repositories.repos.repositories) )
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
      repo_id       = local.repositories[each.value.git_repo_name].id
      repo_type     = "TfsGit"
      repo_name     = each.value.git_repo_name
      yml_path      = each.value.yaml
    }

}

