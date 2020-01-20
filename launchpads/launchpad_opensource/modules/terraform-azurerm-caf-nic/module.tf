locals {
  nic_keys = keys(var.nic_objects)
}

resource "random_string" "ip_configuration" {
  length  = 30
  special = false
}

resource "azurerm_network_interface" "nic" {
  for_each = var.nic_objects

  name                = "${var.prefix}-${each.value.name}"
  resource_group_name = var.resource_group_name
  location            = var.location


  enable_ip_forwarding          = lookup(each.value, "enable_ip_forwarding", null)
  internal_dns_name_label       = lookup(each.value, "internal_dns_name_label", null)
  dns_servers                   = lookup(each.value, "dns_servers", null)
  enable_accelerated_networking = lookup(each.value, "enable_accelerated_networking", null)
  tags                          = lookup(each.value, "tags", null) == null ? local.tags : merge(local.tags, each.value.tags)

  ip_configuration {
    name                          = "ipConfig-${each.value.name}-${random_string.ip_configuration.result}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = lookup(each.value, "private_ip_address_allocation", "Dynamic")

    # Optional parameters
    private_ip_address         = lookup(each.value, "private_ip_address", null)
    private_ip_address_version = lookup(each.value, "private_ip_address_version", null)

    # Only link a public ip to the nic if the public_ip_key value is set in the landing zone config file
    public_ip_address_id       = lookup(each.value, "public_ip_key", null) == null ? null : lookup(var.pips_id_by_key, each.value.public_ip_key, null)
  }
}

