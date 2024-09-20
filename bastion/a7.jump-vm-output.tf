output "jumphost_public_ip" {
  value = azurerm_public_ip.jump_linuixvm_publicip.ip_address
}