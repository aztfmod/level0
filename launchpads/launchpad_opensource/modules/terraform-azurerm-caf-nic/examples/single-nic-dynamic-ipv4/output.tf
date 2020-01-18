output "objects" {
  description = "Output the networking interfaces as a full object (azurerm_network_interface.nic)"
  value       = module.test_nic.objects
}

output "nic_ids" {
  value = module.test_nic.nic_ids
}