blueprint_container_registry = {

    acr_object = {
        
        resource_group = {    
            name     = "devop-container-registry"
            location = "southeastasia" 
        }

        name    = "acrdevops12123"
        sku     = "Basic"
    }
}