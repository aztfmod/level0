#########################################
# Requires 3 Azure AD Applications
# Cluster, Server and Client
#########################################

locals {
  # Azure Active Directory Graph
  active_directory_graph_id         = "00000002-0000-0000-c000-000000000000"
  active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
  active_directory_graph_resource_access_id_Directory_Read_All            = "5778995a-e1bf-45b8-affa-663a9f3f4d04"

  microsoft_graph_id                = "00000003-0000-0000-c000-000000000000"
  microsoft_graph_AppRoleAssignment_ReadWrite_All = "06b708a9-e830-4db3-a914-8e69da51d44f"
  microsoft_graph_delegated_user_read             = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
  microsoft_graph_delegated_directory_read_all    = "06da0dbc-49e2-44d2-8312-53f166ab848a"
  microsoft_graph_application_directory_read_all  = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"

}

# Suffix to randomize more the destroy/create scenario
resource "random_string" "suffix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}

resource "azuread_application" "server" {
  
  name      = "test-aks-server-${random_string.suffix.result}"
  
  group_membership_claims = "All"

    # reference: https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli
  required_resource_access {
    # Microsoft graph resource app id
    resource_app_id = local.microsoft_graph_id

    resource_access {
      id   = local.microsoft_graph_delegated_user_read
      type = "Scope"
    }

    resource_access {
      id   = local.microsoft_graph_delegated_directory_read_all
      type = "Scope"
    }

    # Read Directory Data (Directory.Read.All)
    resource_access {
      id   = local.microsoft_graph_application_directory_read_all
      type = "Role"
    }
  }

}

resource "null_resource" "consent_server" {
  depends_on = [azuread_service_principal_password.server]

  provisioner "local-exec" {
      command = "sleep 30"
  }

  provisioner "local-exec" {
      command = "${path.module}/scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.microsoft_graph_id
        principalId   = azuread_service_principal.server.id
        appRoleId     = local.microsoft_graph_application_directory_read_all
      }
  }


  triggers = {
      grant_admin_concent_command    = sha256(file("${path.module}/scripts/grant_consent.sh"))
  }
}




resource "azuread_service_principal" "server" {
  application_id = azuread_application.server.application_id
}

resource "random_password" "ad_server_password" {
  length  = 90
  special = false

  keepers = {
    service_principal = azuread_service_principal.server.id
  }
}

resource "azuread_service_principal_password" "server" {
  service_principal_id = azuread_service_principal.server.id
  value                = random_password.ad_server_password.result
  end_date             = "2024-01-01T01:02:03Z"
}

##############################################
# AD Client to Impersonate the logged-in user
##############################################
resource "azuread_application" "client" {

  name       = "test-aks-client-${random_string.suffix.result}"
  type       = "native"

  # Impresonate the logged-in user to access the server app_id
  required_resource_access {
    # AKS ad application server
    resource_app_id = azuread_application.server.application_id

    resource_access {
      # Server app Oauth2 permissions id
      id   = lookup(azuread_application.server.oauth2_permissions[0], "id")
      type = "Scope"
    }
  }
}

locals {
  consent_client_cmd = "az ad app permission grant --id ${azuread_application.client.application_id} --api ${azuread_application.server.application_id}"
}

# granting the consent ad-client
resource "null_resource" "consent_client" {
  depends_on = [azuread_service_principal_password.client, null_resource.consent_server]

  triggers = {
    consent_client_cmd = sha256(local.consent_client_cmd)
  }

  provisioner "local-exec" {
    command = local.consent_client_cmd
  }
}

resource "azuread_service_principal" "client" {

  application_id = azuread_application.client.application_id
}

resource "random_password" "ad-client-password" {
  length  = 90
  special = false

  keepers = {
    service_principal = azuread_service_principal.client.id
  }
}

resource "azuread_service_principal_password" "client" {
  service_principal_id = azuread_service_principal.client.id
  value                = random_password.ad-client-password.result
  end_date             = "2024-01-01T01:02:03Z"
}
