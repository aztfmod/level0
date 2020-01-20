
# resource "null_resource" "login" {


#     provisioner "local-exec" {
#         command = local.arg_devops_login
#     }

#     triggers = {
#         pat_token   = var.pat_token
#         arg         = local.arg_devops_login
#         # time        = timestamp()               # force the login to be re-executed at evey call
#     }
# }

# locals {
#     arg_devops_login = <<EOT
#         export AZURE_DEVOPS_EXT_PAT="${var.pat_token}"

#         az devops configure --defaults project="${var.azure_devops["project"]}" organization="${var.azure_devops["base_url_organization"]}${var.azure_devops["organization"]}"
#     EOT
# }
