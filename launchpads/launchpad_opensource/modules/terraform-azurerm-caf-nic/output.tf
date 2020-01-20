output "objects" {
  description = "Output the networking interfaces as a full object (azurerm_network_interface.nic)"
  value       = azurerm_network_interface.nic
}

output "nic_ids" {
  description = "List of nic ids"
  value       = [
    for nic in azurerm_network_interface.nic:
      nic.id
  ]
}