output "object" {
  description = "Output the full object"
  value = azurerm_public_ip.public_ip
}

output "ip_address" {
  description = "Output the ip address"
  value = azurerm_public_ip.public_ip.ip_address
}

output "fqdn" {
  description = "Output the fully qualified domain name"
  value = azurerm_public_ip.public_ip.fqdn
}

output "name" {
  description = "Output the object name"
  value = azurerm_public_ip.public_ip.name
}

output "id" {
  description = "Output the object ID"
  value = azurerm_public_ip.public_ip.id
}

output "id_by_key" {
    depends_on = [azurerm_public_ip.pip]

    value = {
        for key in keys(azurerm_public_ip.pip):
        key => azurerm_public_ip.pip[key].id
    }
}

output "fqdn_by_key" {
    depends_on = [azurerm_public_ip.pip]
    
    value = {
        for key in keys(azurerm_public_ip.pip):
        key => azurerm_public_ip.pip[key].fqdn
    }
}