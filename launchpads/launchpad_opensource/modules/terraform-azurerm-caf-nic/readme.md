# Deploys an Azure Virtual Machine Network Interface Card
Creates an Azure Virtual Machine NIC 


Reference the module to a specific version (recommended):
```hcl
module "vm_nic" {
    source  = "aztfmod/caf-container-registry/azurerm"
    version = "0.x.y"
    
    prefix              = var.prefix
    tags                = var.tags
    location            = var.location
    resource_group_name = var.rg.name
    nic_objects         = var.nics
    pip_objects         = var.pips
    subnet_id           = var.subnet.test.id

}
```

## Inputs

| Name | Type | Default | Description | 
| -- | -- | -- | -- | 
| name | string | None | Specifies the name of the NIC. Changing this forces a new resource to be created. |
| resource_group_name | string | None | The name of the resource group in which to create the VM. Changing this forces a new resource to be created. |
| location | string | None | Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created.  |
| tags | map | None | Map of tags for the deployment.  | 
| prefix | string | None | Prefix to be used. | 
| nic_objects | object | None |  NIC configuration object as described below. | 
| pip_objects | object | None |  PIP configuration object as described below. | 
| subnet_id | string | None | Subnet_id to deploy the networking cards | 
| pips_id_by_key | map | None | Object of public ip IDs by Key | 


## Parameters

### nic_objects
Is a complex object describing a set of NIC to be created as follow: 

```hcl
nic_objects = {
    nics = {
        nic0 = {
            name                            = "nic0"
            public_ip_key                   = "pip0"
            enable_ip_forwarding            = false
            enable_accelerated_networking   = false
            internal_dns_name_label         = "caftest"
            dns_servers = ["1.2.3.4"]

            private_ip_address_allocation = "static"
            private_ip_address = "10.0.1.16"
            private_ip_address_version = "IPv4"
        }
    }
}
```

### pip_objects
Is a complex object describing the PIP and associating it to the NIC by their names.

```hcl
pip_objects = {
    pips = {
        pip0 = {
            name  = "nic0-pip"

        }
    }
}
```

## Output

| Name | Type | Description | 
| -- | -- | -- | 
| objects | list(string) | Output the networking interfaces as a full object (azurerm_network_interface.nic) |
| nic_ids | list(string) | List of nic ids |