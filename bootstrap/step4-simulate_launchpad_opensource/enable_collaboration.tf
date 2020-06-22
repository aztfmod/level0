## Not using azuread_group as it is based on the ActiveDirectory Graph and does not support the delete when ran from a service principal
# Need AzureAd provider to move to Microsoft Graph to support deletion


locals {
  adgroup = "test-level0-rover-developers"
}


resource "null_resource" "ad_group_devops_rover" {

  provisioner "local-exec" {
      command     = "/usr/bin/az ad group create --display-name '${local.adgroup}' --mail-nickname '${local.adgroup}' -o json"
      on_failure  = fail

  }

  provisioner "local-exec" {
      command = "sleep 60"
  }

}


data "azuread_group" "devops_rover" {
  depends_on = [ null_resource.ad_group_devops_rover ]
  name = local.adgroup
}



resource "azuread_group_member" "launchpad_app" {
  depends_on = [null_resource.ad_group_devops_rover]
  group_object_id   = data.azuread_group.devops_rover.id
  member_object_id  = azuread_service_principal.launchpad.object_id

  lifecycle {
    ignore_changes = [
      member_object_id, group_object_id
    ]
  }
}


###
#   Grant devops app contributor on the current subscription to be able to deploy the blueprint_azure_devops
###
resource "azurerm_role_assignment" "developers_rover" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.devops_rover.id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}
