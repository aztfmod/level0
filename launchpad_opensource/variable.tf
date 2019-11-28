variable "logged_user_objectId" {
    description = "objectId of the logged user initializing the launchpad"
}

variable "location" {
    description = "Azure region to deploy the launchpad in the form or 'southeastasia' or 'westeurope'"
}

variable "tf_name" {
    description = "Name of the terraform state in the blob storage"
}