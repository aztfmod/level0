variable "blueprint_devops_self_hosted_agent" {}
variable "blueprint_networking" {}
variable "blueprint_container_registry" {}

variable "logged_user_objectId" {
    description = "objectId of the logged user initializing the launchpad"
}

variable "rover_pilot_client_id" {
    description = "This variable is set when improving the launchpad to allow a rover to access the keyvault when running the rover command"
    default = ""
}


variable "location" {
    description = "Azure region to deploy the launchpad in the form or 'southeastasia' or 'westeurope'"
}

variable "tf_name" {
    description = "Name of the terraform state in the blob storage"
    default="terraform.tfstate"
}

variable "tags" {
    default = {}
}
 
variable "convention" {
    description = "(Optional) (Default = cafrandom) Naming convention to apply to the resources at creating time"
    default = "cafrandom"
}


variable "workspace" {
    description = "Define the workspace to deploy the launchapd [level0, sandpit]"
}


variable "use_prefix" {
    description = "(Optional) (Default = true) Generate a prefix that will be used to prepend all resources names"
    default = true
}


### Azure Devops variables
variable "enable_azure_devops" {
    description = "Feature flag to install Azure devops self hosted agent and setup the Azure devops project"
    default = true
}

variable "azure_devops_pat_token" {}
variable "azure_devops_project" {}
variable "azure_devops_url_organization" {
    description = "The value should be the URI of your Azure DevOps organization, for example: https://dev.azure.com/MyOrganization/ or your Azure DevOps Server organization"
}