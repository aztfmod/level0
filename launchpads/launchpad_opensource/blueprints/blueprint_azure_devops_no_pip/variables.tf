variable "prefix" {
    description = "Prefix to prepend to all resources to increase the randomness"
    default = ""
}

variable "convention" {
    description = "(Optional) (Default = cafrandom) Naming convention to apply to the resources at creating time"
    default = "cafrandom"
}

variable tags {
    default = {}
    type = map
}

variable "location" {
  type = string
  default = "westus2"
}

variable "resource_group_name" {
    description = "Name of the resource group to deploy the Azure DevOps resources"
    default = "devops"
}

variable "storage_account_name" {
    description = "Storage account name to store diagnostics and Azure DevOps init script"
    default = ""
}

variable "agent_init_script" {
    
}

variable "subnet_id" {
    description = "Id of the Azure Subnet to deploy the devops agent"
}