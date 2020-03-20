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
variable "azure_devops_pat_token" {
    description = "Azure DevOps Personal Access Token to register the self hosted agent"
}

# variable "azure_devops_project" {
#     description = "Azure DevOps project name"
# }

variable "azure_devops_url_organization" {
    description = "The value should be the URI of your Azure DevOps organization, for example: https://dev.azure.com/MyOrganization/ or your Azure DevOps Server organization"
}

# variable "azure_devops_agent_pool" {
#     description = "Azure DevOps agent pool name to host the self hosted agent"
# }

variable "azure_devops" {}

## Feature flags
variable "enable_collaboration" {
      type        = bool
    description = "(Optional) (Default=false) When enabled, create the Azure AD security group to allow multiple devops engineers to access the launchpad from different rover"
    default = false
}

variable "enable_azure_devops" {
    description = "Feature flag to install Azure devops self hosted agent and setup the Azure devops project"
    default = true
}

variable "save_devops_agent_ssh_key_to_disk" {
  type        = bool
  default     = true
  description = "Dump the ssh private key in the ~/.ssh folder with the name [public ip address].private"
}