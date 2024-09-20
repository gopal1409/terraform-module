resource "azurerm_network_interface" "webvm_nic" {
    for_each = var.car
  name                = "${local.resource_name_prefix}-nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "internal"
    #a private ip
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.web_linuixvm_publicip[each.key].id
  }
}