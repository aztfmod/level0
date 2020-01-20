variable "blueprint_devops_self_hosted_agent" {}
variable "blueprint_networking" {}
variable "blueprint_container_registry" {}

variable "logged_user_objectId" {
    description = "objectId of the logged user initializing the launchpad"
}

variable "rover_pilot_object_id" {
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
    default = {
        "level" = "level0"
    }
}
 
variable "convention" {
    description = "Naming convention to apply to the resources at creating time"
    default = "cafrandom"
}


variable "workspace" {
    description = "Define the workspace to deploy the launchapd [level0, sandpit]"
}
