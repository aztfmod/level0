variable "ad_application_name" {
  type        = string
  description = "Azure AD Application Name in charge of managing the launchpad"
}

variable "subscription_role" {
  type        = string
  description = "(Default = Owner) Role given to the default subscription to the bootsrap account"
  default     = "Owner"
}

variable "azure_ad_directory_roles" {
}

variable "azure_devops_project" {
  description = "Azure devops project. Must exist"
}

variable "azure_devops_organization_url" {
  description = "URL of the Azure Devops organization"
}

variable "pat_full_access_scope" {
  description = "Provide full access to the devops configuration project to create agent pools, variable groups and pipelines"
}

