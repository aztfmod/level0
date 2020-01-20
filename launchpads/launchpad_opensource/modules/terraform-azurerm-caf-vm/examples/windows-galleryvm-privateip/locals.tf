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
    solution_plan_map = {
        NetworkMonitoring = {
            "publisher" = "Microsoft"
            "product"   = "OMSGallery/NetworkMonitoring"
        },
    }

    os = "Windows"
    os_profile = {
        computer_name  = "testcafvm"
        admin_username = "testadmin"
        admin_password = "Password1234!"
        provision_vm_agent = false
        license_type = "Windows_Server"
        #Support for BYOL (HUB) - values can be "Windows_Server" or "Windows_Client"
    }
    storage_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter-Core"
        version   = "latest"
    }
    storage_os_disk = {
        name              = "myosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
        disk_size_gb      = "128"
    }
    vm_size = "Standard_DS1_v2"
}