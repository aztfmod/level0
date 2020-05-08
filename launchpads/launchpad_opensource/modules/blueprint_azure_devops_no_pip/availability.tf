
resource "azurerm_availability_set" "avs" {
  count = lookup(var.vm_object, "availability_set", null) == null ? 0 : 1

  name                          = "${var.vm_object.name}-${var.vm_object.availability_set.name}"
  location                      = local.location
  resource_group_name           = azurerm_resource_group.rg.name

  platform_update_domain_count  = var.vm_object.availability_set.platform_update_domain_count
  platform_fault_domain_count   = var.vm_object.availability_set.platform_fault_domain_count

  tags                          = merge(local.tags, lookup(var.vm_object.availability_set, "tags", {}))
}