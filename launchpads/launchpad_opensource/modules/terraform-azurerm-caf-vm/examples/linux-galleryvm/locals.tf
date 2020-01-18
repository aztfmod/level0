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

    os = "Linux"
    os_profile = {
        computer_name  = "testcafvm"
        admin_username = "testadmin"
    }
    storage_image_reference = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
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