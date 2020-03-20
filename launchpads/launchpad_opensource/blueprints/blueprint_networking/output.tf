
output "subnet_id_by_name" {
  value = module.virtual_network.vnet_subnets
}

output "subnet_id_by_key" {
  value = module.virtual_network.subnet_ids_map
}

output "vnet" {
  value = merge(
    module.virtual_network.vnet,
    {
      resource_group_name = var.resource_group_name
    }
  )
}