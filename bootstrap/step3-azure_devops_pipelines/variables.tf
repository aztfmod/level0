variable "variable_groups" {
  type        = map
}

variable "azure_devops_project" {
    description = "Azure devops project. Must exist"
}

variable "agent_pools" {}
variable "release_agents" {}

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