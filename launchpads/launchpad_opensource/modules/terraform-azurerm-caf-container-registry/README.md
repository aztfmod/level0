# Deploys an Azure Container Registry
Creates an Azure Container Registry in a given region 

Reference the module to a specific version (recommended):
```hcl
module "acr" {
    source  = "aztfmod/caf-container-registry/azurerm"
    version = "0.x.y"
    
    resource_group_name               = var.rg
    asr_vault_name                    = var.name
    location                          = var.location
    tags                              = var.tags
    opslogs_retention_period          = var.retention
    diagnostics_map                   = var.diagsmap
    la_workspace_id                   = var.laworkspace.id
}
```

## Inputs

| Name | Type | Default | Description | 
| -- | -- | -- | -- | 
| name | string | None | Specifies the name of the Container Registry. Changing this forces a new resource to be created. |
| resource_group_name | string | None | The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. |
| location | string | None | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.  | 
| tags | map | None | Map of tags for the deployment.  | 
| la_workspace_id | string | None | Log Analytics Repository ID. | 
| diagnostics_map | map | None | Map with the diagnostics repository information.  | 
| diagnostics_settings | object | None | Map with the diagnostics settings for ASR deployment. See the required structure in the following example or in the diagnostics module documentation. | 
| admin_enabled | bool | False | Specifies whether the admin user is enabled.  | 
| sku | string | Basic | The SKU name of the the container registry. Possible values are Basic, Standard and Premium. Default = Basic.  | 
| georeplication_locations | list | null | A list of Azure locations where the container registry should be geo-replicated (only valid if SKU is premium)  | 
| convention | string | None | Naming convention to be used (check at the naming convention module for possible values).  | 
| prefix | string | None | Prefix to be used (to be deprecated)  | 


## Output

| Name | Type | Description | 
| -- | -- | -- | 
| object | object | Returns the full object of the created Azure Container Registry. |
| name | string | Returns the name of the created Azure Container Registry. |
| id | string | Returns the ID of the created Azure Container Registry. | 