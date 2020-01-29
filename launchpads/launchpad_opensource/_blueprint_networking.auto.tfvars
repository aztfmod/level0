blueprint_networking = {
    
    networking_object = {

        resource_group = {    
            name     = "network"
            location = "southeastasia" 
        }

        vnet = {
            name                = "sg-vnet-001"
            address_space       = ["10.100.0.0/23"] 
            dns                 = []
        }
        specialsubnets     = {
        }
        subnets = {
            subnet1        = {
                name                = "devopsAgent"
                cidr                = "10.100.0.0/25"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh", "100", "Inbound", "Allow", "*", "*", "22", "*", "*"],
                ]
                nsg_outbound        = []
            }
        }

        diags = {
            log = [
                # ["Category name", "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                ["VMProtectionAlerts", true, true, 5],
            ]
            metric = [
                #["Category name", "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                ["AllMetrics", true, true, 2],
            ]
        }
    }
}