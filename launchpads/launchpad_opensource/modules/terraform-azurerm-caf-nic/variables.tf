variable "prefix" {

}

variable "tags" {

}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the network interface. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) Specifies the Azure Region where the NIC is deployed. Changing this forces a new resource to be created."
}

variable "nic_objects" {
  description = "(Required) NIC configuration object"
}

variable "pip_objects" {
  description = "(Required) Public IP configuration object"
  default = null
}

variable "subnet_id" {
  description = "(Required) Subnet_id to deploy the networking cards"
}

variable "pips_id_by_key" {
  description = "(Optional) Object of public ip IDs by Key"
  default = null
}