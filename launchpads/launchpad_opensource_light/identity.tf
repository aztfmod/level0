###
#   Azure AD Application
###
resource "azuread_application" "launchpad" {
  name                       = "${random_string.prefix.result}launchpad"

  required_resource_access {

    # Azure Active Directory Graph
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    # az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[?value=='Application.ReadWrite.OwnedBy']"
    # Application.ReadWrite.OwnedBy
    resource_access {
			id    = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
			type  = "Role"
    }

    # az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[?value=='Directory.Read.All']"
    # Directory.Read.All
    resource_access {
      id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
      type = "Role"
    }

  }
}

# Service Principal's objectId for Azure Active Directory Graph (resourceId)
# az ad sp show --id "00000002-0000-0000-c000-000000000000" --query "objectId" --> "d74f8620-1972-4a99-87f0-41ba5c6d149a"
#
# Appl role id (aapRoleId): 
# az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[?value=='Application.ReadWrite.OwnedBy']" --> "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
#
# "principalId": azuread_service_principal.launchpad.id

# az rest --method POST --uri https://graph.microsoft.com/beta/servicePrincipals/d74f8620-1972-4a99-87f0-41ba5c6d149a/appRoleAssignments \
#         --header Content-Type=application/json --body '{
#           "principalId": "8e42819e-a0d0-4c71-bf7c-06f63fed7d69",
#           "resourceId": "d74f8620-1972-4a99-87f0-41ba5c6d149a",
#           "appRoleId": "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
#         }'


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

