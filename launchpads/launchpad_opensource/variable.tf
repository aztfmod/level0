variable "blueprint_networking" {}

variable "logged_user_objectId" {
    description = "objectId of the logged user initializing the launchpad"
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
    type = map
}
 
variable "convention" {
    description = "(Optional) (Default = cafrandom) Naming convention to apply to the resources at creating time"
    default = "cafrandom"
}


variable "workspace" {
    description = "Define the workspace to deploy the launchapd [level0, sandpit]"
}


variable "prefix" {
    description = "(Optional) (Default = true) Generate a prefix that will be used to prepend all resources names"
    default = null
}

## Feature flags
variable "enable_collaboration" {
    type        = bool
    description = "(Optional) (Default=true) When enabled, create the Azure AD security group to allow multiple devops engineers to access the launchpad from different rover"
    default = true
}


# Resource group names
variable "resource_group_tfstate" {
    description = "Name of the resource group hosting the terraform state storage accounts"
    default = "launchpad-tfstate"
}

variable "resource_group_security" {
    description = "Name of the resource group hosting the security services"
    default = "launchpad-security"
}

variable "resource_group_devops" {
    description = "Name of the resource group hosting the ops services"
    default = "launchpad-ops"
}

variable "resource_group_networking" {
    description = "Name of the resource group hosting the network services"
    default = "launchpad-network"
}

# Resource names
variable "resource_storage_tfstate_name_prefix" {
    description = "Name of the storage account hosting the tfstate (note l0, l1, l2, l4 added automatically). Note the keyvault name applies a cafrandom policy."
    default = "tfstate"
}

variable "resource_log_analytics_name" {
    description = "Name of the log analytics used for the gitops environment"
    default = "gitops"
}

variable "resource_diagnostics_name" {
    description = "Name of the diagnotic storage account used for the gitops environment"
    default = "diag"
}

variable "azure_diagnostics_logs_event_hub" {
    default = false
    type = bool
}

variable "resource_keyvault_name" {
    description = "Name of the Azure Keyvault storing secrets required for rover and pipelines. Note the keyvault name applies a cafrandom policy."
    default = "gitops"
}

variable "environment" {
    default = "sandpit"
}

variable "rover_version" {
    description = "Version of the rover used to deploy the landing zone"
}