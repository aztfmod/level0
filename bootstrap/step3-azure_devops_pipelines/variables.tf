variable "variable_groups" {
  type        = map
  default =  {
    global  = {
        name        = "release-global"      # changing that name requires to change it in the devops agents yaml variables group
        variables   = {
            AGENT_POOL_LEVEL0           = "caf-test-boostrap-level0"         # Must match the level0 agent pool as defined below
        }
    }

    level0 = {
        name        = "release-level0"
        variables   = {
            TF_VAR_pipeline_level           = "level0"
        }
    }
  }
}

variable "azure_devops_project" {
    description = "Azure devops project. Must exist"
}

variable "agent_pools" {
  default = {
    level0 = {
        name    = "caf-test-bootstrap-level0"
    }
  }
}
variable "release_agents" {
  default = {}
}

variable "azure_devops_organization_url" {
  description = "URL of the Azure Devops organization"
}

variable "pat_full_access_scope" {
  description = "Provide full access to the devops configuration project to create agent pools, variable groups and pipelines"
}

variable "pat_agent_pools_manage_scope" {
  description = "Provide Agent Pools (Read & Manage) to allow the Azure Devops self-hosted agents to register to the agent pool and receive jobs."
}

variable "bootstrap_ARM_CLIENT_ID" {}
variable "bootstrap_ARM_CLIENT_SECRET" {}
variable "bootstrap_ARM_SUBSCRIPTION_ID" {}
variable "bootstrap_ARM_TENANT_ID" {}