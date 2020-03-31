
locals {
    solution_plan_map = {
        KeyVaultAnalytics = {
            "publisher" = "Microsoft"
            "product"   = "OMSGallery/KeyVaultAnalytics"
        }
    }   
}

module "log_analytics" {
    # source  = "aztfmod/caf-log-analytics/azurerm"
    # version = "~> 1.0"
    source = "git://github.com/aztfmod/terraform-azurerm-caf-log-analytics.git?ref=v2.0.1"

    name                              = var.workspace
    convention                        = var.convention
    solution_plan_map                 = local.solution_plan_map
    resource_group_name               = azurerm_resource_group.rg.name
    prefix                            = local.prefix
    location                          = var.location
    tags                              = var.tags
    
}