variable "blueprint_azure_devops_no_pip" {
}

variable "use_prefix" {
    default = true
    type = bool
}

variable "convention" {
    description = "(Optional) (Default = cafrandom) Naming convention to apply to the resources at creating time"
    default = "cafrandom"
}

variable "location" {
  type = string
  default = "westus2"
}

