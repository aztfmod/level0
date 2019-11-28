# Blueprint launchpad_opensource

## Capabilities

 - Azure storage account to store terraform remote states
 - Azure AD Applications
   - (app1) terraform state
   - (app2) azure devops        # Allow Azure devops variable group to list and key the secrets from Keyvault
 - Managed identity
   - (msi1) - user - terraform state
 - Azure Keyvault
   - Secrets 
        - tfstate-resource-group
        - tfstate-storage-account-name
        - tfstate-container
        - tfstate-prefix
        - tfstate-blob-name
        - tfstate-msi-client-id
        - tfstate-msi-principal-id
        - tfstate-msi-id
    - Access policy
        - (app1)
            - Secrets ["set","get","list","delete"]
        - (app2)
            - Secrets ["get","list",]
        - (msi1)
            - Secrets ["get"]  