blueprint_networking = {
    
    networking_object = {

        resource_group = {    
            name     = "network"
            location = "southeastasia" 
        }

        vnet = {
            name                = "gitops"
            address_space       = ["192.168.200.0/24"] 
            dns                 = []
        }
        specialsubnets     = {
        }
        subnets = {
            subnet1        = {                          # Reserved for VPN Gateway service for point to site VPN from the rover
                name                = "GatewayService"
                cidr                = "192.168.200.0/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                
                ]
                nsg_outbound        = []
            }
            subnet2        = {
                name                = "bastion"
                cidr                = "192.168.200.8/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh", "100", "Inbound", "Allow", "*", "*", "22", "*", "*"],
                ]
                nsg_outbound        = []
            }
            level0        = {
                name                = "level0"
                cidr                = "192.168.200.16/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
                ]
                nsg_outbound        = []
            }
            level1        = {
                name                = "level1"
                cidr                = "192.168.200.24/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
                ]
                nsg_outbound        = []
            }
            level2        = {
                name                = "level2"
                cidr                = "192.168.200.32/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
                ]
                nsg_outbound        = []
            }
            level3        = {
                name                = "level3"
                cidr                = "192.168.200.40/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
                ]
                nsg_outbound        = []
            }
            level4release        = {
                name                = "level4-release"
                cidr                = "192.168.200.48/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
                ]
                nsg_outbound        = []
            }
            level4build        = {
                name                = "level4-build"
                cidr                = "192.168.200.56/29"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
                    ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
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