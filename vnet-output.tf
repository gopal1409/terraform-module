output "virtual_network_name" {
  description = "show me the vnet name"
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  description = "id of vnet"
  value       = azurerm_virtual_network.vnet.id
}

output "web_subnet_name" {
  value = azurerm_subnet.web_subnet.name
}

output "web_subnet_id" {
  value = azurerm_subnet.web_subnet.id
}