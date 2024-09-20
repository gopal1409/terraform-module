/*resource "azurerm_subnet" "bastion_service_subnet" {
  name                 = var.bastion_service_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_service_address_prefix
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${local.resource_name_prefix}-bastion-publicip"
  ##the name of the public will be unqiue
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${local.resource_name_prefix}-bastion-host"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_service_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}*/