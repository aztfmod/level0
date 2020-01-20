output "object" {
    value = {
        id              = module.container_registry.id
        login_server    = module.container_registry.login_server
        admin_username  = module.container_registry.admin_username
        admin_password  = module.container_registry.admin_password
    }
}