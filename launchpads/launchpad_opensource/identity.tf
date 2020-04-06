###
#   Azure AD Application
###
resource "azuread_application" "launchpad" {
  name                       = "${random_string.prefix.result}launchpad"
  
  # Access to Azure Active Directory Graph
  required_resource_access {
    resource_app_id = local.active_directory_graph_id

    # az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[?value=='Application.ReadWrite.OwnedBy']"
    # Application.ReadWrite.OwnedBy
    resource_access {
			id    = local.active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy
			type  = "Role"
    }

    # az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[?value=='Directory.Read.All']"
    # Directory.Read.All
    resource_access {
      id   = local.active_directory_graph_resource_access_id_Directory_ReadWrite_All
      type = "Role"
    }
  }

  # Access to Microsoft Graph
  required_resource_access {
    resource_app_id = local.microsoft_graph_object_id

    resource_access {
			id    = local.microsoft_graph_AppRoleAssignment_ReadWrite_All
			type  = "Role"
    }

  }
}

locals {
  # Azure Active Directory Graph
  active_directory_graph_id         = "00000002-0000-0000-c000-000000000000"
  active_directory_graph_object_id  = "d74f8620-1972-4a99-87f0-41ba5c6d149a"
  active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
  active_directory_graph_resource_access_id_Directory_Read_All            = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
  active_directory_graph_resource_access_id_Directory_ReadWrite_All       = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"

  # Microsoft graph
  microsoft_graph_id                = "00000003-0000-0000-c000-000000000000"
  microsoft_graph_object_id         = "77f43b95-80d8-4760-9a75-0a6a9cfd939d"
  microsoft_graph_AppRoleAssignment_ReadWrite_All = "06b708a9-e830-4db3-a914-8e69da51d44f"

  grant_admin_concent_command = <<EOT
    set -e

    TYPE=$(az account show --query user.type -o tsv)
    if [ $TYPE == "user" ]; then
        echo "granting consent to logged in user"
        az ad app permission admin-consent --id ${azuread_application.launchpad.application_id}

        echo "Initializing state with user: $(az ad signed-in-user show --query userPrincipalName -o tsv)"
    else
        echo "granting consent to logged in service principal" - Need to use the beta rest API for service principals. not supported by az cli yet

        # grant consent (Application.ReadWrite.OwnedBy)
        az rest --method POST --uri https://graph.microsoft.com/beta/servicePrincipals/${local.active_directory_graph_object_id}/appRoleAssignments \
        --header Content-Type=application/json --body '{
          "principalId": "${azuread_service_principal.launchpad.id}",
          "resourceId": "${local.active_directory_graph_object_id}",
          "appRoleId": "${local.active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy}"
        }'

        # grant consent (Directory.Read.All)
        az rest --method POST --uri https://graph.microsoft.com/beta/servicePrincipals/${local.active_directory_graph_object_id}/appRoleAssignments \
        --header Content-Type=application/json --body '{
          "principalId": "${azuread_service_principal.launchpad.id}",
          "resourceId": "${local.active_directory_graph_object_id}",
          "appRoleId": "${local.active_directory_graph_resource_access_id_Directory_ReadWrite_All}"
        }'

        # grant consent (AppRoleAssignment.ReadWrite.All)
        az rest --method POST --uri https://graph.microsoft.com/beta/servicePrincipals/${local.microsoft_graph_object_id}/appRoleAssignments \
        --header Content-Type=application/json --body '{
          "principalId": "${azuread_service_principal.launchpad.id}",
          "resourceId": "${local.microsoft_graph_object_id}",
          "appRoleId": "${local.microsoft_graph_AppRoleAssignment_ReadWrite_All}"
        }'
    fi
EOT

}


resource "azuread_service_principal" "launchpad" {
  application_id = azuread_application.launchpad.application_id
}

resource "azuread_service_principal_password" "launchpad" {
  service_principal_id = azuread_service_principal.launchpad.id
  value                = random_string.launchpad_password.result
  end_date_relative     = "43200m"
}

resource "random_string" "launchpad_password" {
    length  = 250
    special = false
    upper   = true
    number  = true
}

###
#   Grant devops app contributor on the current subscription to be able to deploy the blueprint_azure_devops
###
resource "azurerm_role_assignment" "launchpad_role1" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.launchpad.object_id
}

# resource "azurerm_user_assigned_identity" "tfstate" {
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   name = "${random_string.prefix.result}tfstate_msi"
# }

# resource "azurerm_role_assignment" "tfstate_role1" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Owner"
#   principal_id         = azuread_service_principal.tfstate.object_id
# }


###
#    Grant conscent to the azure ad application
###

resource "null_resource" "grant_admin_concent" {
  depends_on = [azurerm_role_assignment.launchpad_role1]

  provisioner "local-exec" {
      command = "sleep 60"
  }
  provisioner "local-exec" {
      command = local.grant_admin_concent_command
      interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
      grant_admin_concent_command    = sha256(local.grant_admin_concent_command)
  }
}

