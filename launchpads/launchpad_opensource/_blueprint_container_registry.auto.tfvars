blueprint_container_registry = {

    acr_object = {
        
        resource_group = {    
            name     = "container-registry"
            location = "southeastasia" 
        }

        name            = "level0"
        sku             = "Basic"
        admin_enabled   = true

        diagnostics_settings = {
            log = [
                ["ContainerRegistryRepositoryEvents", true, true, 5],
                ["ContainerRegistryLoginEvents", true, true, 5],
            ]
            metric = [
                ["AllMetrics", true, true, 30],
            ]
        }
    }
}