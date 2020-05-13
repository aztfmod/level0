variable prefix {
  type        = string
  default     = ""
  description = "Prefix to randomize the resource names or support multiple deployment in the same subscription"
}

variable step1_tfstate_path {
    default = "../step1-create_bootstrap_account"
}