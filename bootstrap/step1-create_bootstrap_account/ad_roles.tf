# Bootstrap

locals {
  # Azure Active Directory Graph
  active_directory_graph_id         = "00000002-0000-0000-c000-000000000000"
  active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7"
  active_directory_graph_resource_access_id_Directory_Read_All            = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
  active_directory_graph_resource_access_id_Directory_ReadWrite_All       = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"

  # Microsoft graph
  microsoft_graph_id                = "00000003-0000-0000-c000-000000000000"
  microsoft_graph_AppRoleAssignment_ReadWrite_All                         = "06b708a9-e830-4db3-a914-8e69da51d44f"
  microsoft_graph_DelegatedPermissionGrant_ReadWrite_All                  = "8e8e4742-1d95-4f68-9d56-6ee75648c72a"
  microsoft_graph_GroupReadWriteAll                                       = "62a82d76-70ea-41e2-9197-370581804d09"
  microsoft_graph_RoleManagement_ReadWrite_Directory                      = "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8"
}

###
#   Azure AD Application
###
resource "azuread_application" "bootstrap" {
  name    = var.ad_application_name
  
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
    resource_app_id = local.microsoft_graph_id

    resource_access {
			id    = local.microsoft_graph_AppRoleAssignment_ReadWrite_All
			type  = "Role"
    }

    resource_access {
			id    = local.microsoft_graph_DelegatedPermissionGrant_ReadWrite_All
			type  = "Role"
    }

    # resource_access {
		# 	id    = local.microsoft_graph_GroupReadWriteAll
		# 	type  = "Role"
    # }

    resource_access {
			id    = local.microsoft_graph_RoleManagement_ReadWrite_Directory
			type  = "Role"
    }
  }
}

resource "azuread_service_principal" "bootstrap" {
  application_id = azuread_application.bootstrap.application_id
}

resource "azuread_service_principal_password" "bootstrap" {
  service_principal_id = azuread_service_principal.bootstrap.id
  value                = random_password.bootstrap.result
  end_date_relative     = "43200m"
}

resource "random_password" "bootstrap" {
    length  = 250
    special = false
    upper   = true
    number  = true
}


###
#    Grant consent to the azure ad application
###



resource "null_resource" "set_azure_ad_roles" {
  depends_on = [azuread_service_principal_password.bootstrap]
  
  provisioner "local-exec" {
      command = "./scripts/set_ad_role.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        AD_ROLE_NAME  = "Application Developer"
        SERVICE_PRINCIPAL_OBJECT_ID = azuread_service_principal.bootstrap.object_id
      }
  }
}



resource "null_resource" "grant_admin_consent" {
  depends_on = [null_resource.set_azure_ad_roles]

  provisioner "local-exec" {
      command = "./scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.active_directory_graph_id
        principalId   = azuread_service_principal.bootstrap.id
        applicationId = azuread_application.bootstrap.application_id
        appRoleId     = local.active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy
      }
  }

  # Required to create and delete Azure AD groups + add members
  provisioner "local-exec" {
      command = "./scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.active_directory_graph_id
        principalId   = azuread_service_principal.bootstrap.id
        applicationId = azuread_application.bootstrap.application_id
        appRoleId     = local.active_directory_graph_resource_access_id_Directory_ReadWrite_All
      }
  }

  provisioner "local-exec" {
      command = "./scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.microsoft_graph_id
        principalId   = azuread_service_principal.bootstrap.id
        applicationId = azuread_application.bootstrap.application_id
        appRoleId     = local.microsoft_graph_AppRoleAssignment_ReadWrite_All
      }
  }

   provisioner "local-exec" {
      command = "./scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.microsoft_graph_id
        principalId   = azuread_service_principal.bootstrap.id
        applicationId = azuread_application.bootstrap.application_id
        appRoleId     = local.microsoft_graph_DelegatedPermissionGrant_ReadWrite_All
      }
  }

  #  provisioner "local-exec" {
  #     command = "./scripts/grant_consent.sh"
  #     interpreter = ["/bin/sh"]
  #     on_failure = fail

  #     environment = {
  #       graphId       = local.microsoft_graph_id
  #       principalId   = azuread_service_principal.bootstrap.id
  #       applicationId = azuread_application.bootstrap.application_id
  #       appRoleId     = local.microsoft_graph_GroupReadWriteAll
  #     }
  # }

   provisioner "local-exec" {
      command = "./scripts/grant_consent.sh"
      interpreter = ["/bin/sh"]
      on_failure = fail

      environment = {
        graphId       = local.microsoft_graph_id
        principalId   = azuread_service_principal.bootstrap.id
        applicationId = azuread_application.bootstrap.application_id
        appRoleId     = local.microsoft_graph_RoleManagement_ReadWrite_Directory
      }
  }

}

