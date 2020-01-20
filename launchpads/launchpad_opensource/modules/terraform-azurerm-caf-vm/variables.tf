variable "prefix" {
  
}

variable "tags" {
  
}

variable "name" {
  description = "(Required) Specifies the name of the Virtual Machine. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group in which the Virtual Machine should exist. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) Specifies the Azure Region where the Virtual Machine exists. Changing this forces a new resource to be created."
}

variable "network_interface_ids" {
  description = "(Required) A list of Network Interface ID's which should be associated with the Virtual Machine."
  type = list(string)
}

variable "primary_network_interface_id" {
  description = "(Required) The primary Network Interface ID's which should be associated with the Virtual Machine. Note when using multiple NICs you must set it in the nic_object configuration"
  type = string
}

variable "os" {
    description = "Define if the operating system is 'Linux' or 'Windows'"
    default = "Windows"
}

variable "os_profile" {
  description = "(Required) A windows or Linux profile as per documentation"
}

variable "storage_image_reference" {

}

variable "storage_os_disk" {
  default = null
}

variable "os_profile_secrets" {
  default = null
}

variable "vm_size" {
  description = "(Required) Azure VM size name, to list all images available in a regionm use : az vm list-sizes --location <region>"
}

variable "convention" {
  description = "(Required) Naming convention to use."
}
