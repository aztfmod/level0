## Variable groups
resource "azuredevops_variable_group" "pat" {
    project_id   = data.azuredevops_projects.project.projects.*.project_id[0]
    name         = "release-global-pat"
    description  = "Managed by Terraform"
    allow_access = false

    variable {
        name  = "TF_VAR_azure_devops_pat_token"
        value = var.pat_agent_pools_manage_scope
        is_secret = true
    }
}