# variable "resource_groups" {

# }

# variable "resource_group_key" {
#     description = "Resource group's key of the resource group to deploy the resources"
# }

variable "tags" {

}

variable "prefix" {

}


variable "convention" {
    description = "Naming convention to apply to the resources at creating time"
}

variable "acr_object" {

}

variable "subnet_id" {
    description = "Subnet ID to authorize the access from"
}


variable "diagnostics_map" {

}

variable "log_analytics_workspace" {

}