[![Build status](https://dev.azure.com/azure-terraform/Blueprints/_apis/build/status/modules/public_ip_address)](https://dev.azure.com/azure-terraform/Blueprints/_build/latest?definitionId=0)
# Deploys a public IP address
Creates an Azure public IP address (IPv4 or IPv6)


Reference the module to a specific version (recommended):
```hcl
module "public_ip_address" {
    source  = "aztfmod/caf-public-ip/azurerm"
    version = "0.1.0"

    name                              = var.name
    location                          = var.location
    rg                                = var.rg
    ip_addr                           = var.ipconfig
    diagnostics_settings              = var.ipdiags
    diagnostics_map                   = var.diagsmap
    la_workspace_id                   = var.laworkspace.id
}
```

Or get the latest version
```hcl
module "public_ip_address" {
    source                  = "git://github.com/aztfmod/public_ip_address.git?ref=latest"
  
    name                              = var.name
    location                          = var.location
    rg                                = var.rg
    ip_addr                           = var.ipconfig
    diagnostics_settings              = var.ipdiags
    diagnostics_map                   = var.diagsmap
    la_workspace_id                   = var.laworkspace.id
}
```

# Parameters

## name 
(Required) Name of the public IP to be created.

```hcl 
variable "name" {
  description = "(Required) Name of the public IP to be created"  
}
```

Sample:
```hcl 
name = "mypip"
```

## location
(Required) Location of the public IP to be created.
```hcl 
variable "location" {
  description = "(Required) Location of the public IP to be created"   
}
```

Sample:
```hcl 
location = "southeastasia"
```


## rg 
Resource group of the public IP to be created. 

```hcl 
variable "rg" {
  description = "(Required) Resource group of the public IP to be created"    
}
```
Sample:
```hcl 
rg = "myrg"
```

## ip_addr
(Required) The configuration object describing the public IP configuration
Mandatory properties are:
- allocation_method

Optional properties are:
- sku
- ip_version
- dns_prefix
- timeout
- zones
- public_ip_prefix_id

```hcl
variable "ip_addr" {
 description = "(Required) Map with the settings for public IP deployment"
}
```
Example
```hcl
  ip_addr = {
        allocation_method   = "Static"
        #Dynamic Public IP Addresses aren't allocated until they're assigned to a resource (such as a Virtual Machine or a Load Balancer) by design within Azure 
        
        #properties below are optional 
        sku                 = "Standard"                        #defaults to Basic
        ip_version          = "IPv4"                            #defaults to IP4, Only dynamic for IPv6, Supported arguments are IPv4 or IPv6, NOT Both
        dns_prefix          = "arnaudmytestdeeee" 
        timeout             = 15                                #TCP timeout for idle connections. The value can be set between 4 and 30 minutes.
        zones               = [1]                               #1 zone number, IP address must be standard, ZoneRedundant argument is not supported in provider at time of writing
        #reverse_fqdn        = ""   
        #public_ip_prefix_id = "/subscriptions/00000000-00000-0000-0000-000000000000/resourceGroups/uqvh-hub-ingress-net/providers/Microsoft.Network/publicIPPrefixes/myprefix"
        #refer to the prefix and check sku types are same in IP and prefix 
  }
```


## tags
(Required) Map of tags for the deployment
```hcl
variable "tags" {
  description = "(Required) map of tags for the deployment"
}
```
Example
```hcl
tags = {
    environment     = "DEV"
    owner           = "Arnaud"
    deploymentType  = "Terraform"
  }
```

## la_workspace_id
(Required) Log Analytics Repository ID
```hcl
variable "la_workspace_id" {
  description = "Log Analytics Repository"
}
```
Example
```hcl
la_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/arnaud-hub-operations/providers/microsoft.operationalinsights/workspaces/mylalogs"
```

## diagnostics_map
(Required) Map with the diagnostics repository information"
```hcl
variable "diagnostics_map" {
 description = "(Required) Map with the diagnostics repository information"
}
```
Example
```hcl
  diagnostics_map = {
      diags_sa      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/arnaud-hub-operations/providers/Microsoft.Storage/storageAccounts/opslogskumowxv"
      eh_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/arnaud-hub-operations/providers/Microsoft.EventHub/namespaces/opslogskumowxv"
      eh_name       = "opslogskumowxv"
  }
```

## diagnostics_settings
(Required) Map with the diagnostics settings for public IP address deployment.
See the required structure in the following example or in the diagnostics module documentation.

```hcl
variable "diagnostics_settings" {
 description = "(Required) Map with the diagnostics settings for public IP deployment"
}
```
Example
```hcl
diagnostics_settings = {
    log = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                ["DDoSProtectionNotifications", true, true, 30],
                ["DDoSMitigationFlowLogs", true, true, 30],
                ["DDoSMitigationReports", true, true, 30],
        ]
    metric = [
               ["AllMetrics", true, true, 30],
    ]
}
```

# Output
## object
Returns the resource object of the created public IP.
```hcl
output "object" {
  value = azurerm_public_ip.public_ip
}
```

## name
Returns the resource name of the created public IP.
```hcl
output "name" {
  value = azurerm_public_ip.public_ip.name
}

```

## id
Returns the resource ID of the created public IP.
```hcl
output "id" {
  value = azurerm_public_ip.public_ip.id
}
```

## ip_address
Returns the IP address of the created public IP.
```hcl
output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
```

## fqdn
Returns the FQDN of the created public IP.
```hcl
output "fqdn" {
  value = azurerm_public_ip.public_ip.fqdn
}
```
