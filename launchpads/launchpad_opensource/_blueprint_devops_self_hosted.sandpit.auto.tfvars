blueprint_devops_self_hosted_agent = {

    vm_object = {   

        resource_group = {
            name     = "devop-agents"
            location = "southeastasia" 
        }


        name = "devops-"
        os_profile = {
            computer_name = "devopsagent1"
            admin_username = "devopsadmin"
        }

        vm_size = "Standard_B1s"

        os = "Linux"

        save_ssh_private_key_pem = true

        storage_image_reference = {
            publisher = "OpenLogic"
            offer     = "Centos"
            sku       = "7.6"
            version   = "latest"
            # id        = "sdsd"
        }


        storage_os_disk = {
            name                        = "os_disk"
            caching                     = "ReadWrite"
            create_option               = "FromImage"
            managed_disk_type           = "Standard_LRS"
            disk_size_gb                = 128
            # write_accelerator_enabled   = true
        }

        nic_object = {
            name = "nic"
        }
        
        caf-provisioner = {
            os_platform = "centos"
            scripts = [
                "install_docker.sh",
                "install_azure_cli.sh"
            ]
        }
        
    }

    
    public_ip = {
        ip_name = "pip"    
        allocation_method   = "Static"
        #Dynamic Public IP Addresses aren't allocated until they're assigned to a resource (such as a Virtual Machine or a Load Balancer) by design within Azure 
        
        #properties below are optional 
        sku                 = "Standard"                        #defaults to Basic
        ip_version          = "IPv4"                            #defaults to IP4, Only dynamic for IPv6, Supported arguments are IPv4 or IPv6, NOT Both

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
    }

    azure_devops = {
        
        organization = "https://dev.azure.com/azure-terraform"

        # az devops project create --org https://dev.azure.com/azure-terraform --name release-management
        projects = {
            release = {
                name = "release-management"
                description = "This project stores the release pipelines and configuration registry"
            }
        }

        pools = {
            pool1 = {
                name = "self-hosted-level0"
            }
            pool2 = {
                name = "self-hosted-level1"
            }
            pool3 = {
                name = "self-hosted-level2"
            }
            
        }
    }

}