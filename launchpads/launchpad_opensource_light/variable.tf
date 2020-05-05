variable "logged_user_objectId" {
    description = "objectId of the logged user initializing the launchpad"
}

variable "rover_pilot_client_id" {
    description = "This variable is set when improving the launchpad to allow a rover to access the keyvault when running the rover command"
    default = null
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


variable "use_prefix" {
    description = "(Optional) (Default = true) Generate a prefix that will be used to prepend all resources names"
    type    = bool
    default = true
}

variable "enable_collaboration" {
    description = "(Optional) (Default = 0) When set to 1 create an Azure AD group to allow multiple developers to access the launchpad"
    default = false
}

variable "rover_version" {
    description = "Version of the rover used to deploy the landing zone"
}