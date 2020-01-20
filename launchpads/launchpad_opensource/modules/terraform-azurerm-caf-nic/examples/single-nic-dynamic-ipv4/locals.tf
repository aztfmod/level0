locals {
    convention = "random"
    name = "caftest"
    location = "southeastasia"
    prefix = "test"
    resource_groups = {
        test = { 
            name     = "test-caf"
            location = "southeastasia" 
        },
    }
    tags = {
        environment     = "DEV"
        owner           = "CAF"
    }
    
    nic_objects = {
        nics = {
            nic0 = {
                name                            = "nic0"
                # public_ip_key                   = "pip0"
                enable_ip_forwarding            = false
                enable_accelerated_networking   = false
                internal_dns_name_label         = "caftest"
                dns_servers = ["1.2.3.4"]

                private_ip_address_version = "IPv6"
            }
        }
    }

    pip_objects = {
        pips = {
            pip0 = {
                name  = "nic0-pip"

            }
        }
    }
}