
acr_object = {
    
    sku             = "Premium"

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