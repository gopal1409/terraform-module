resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${local.resource_name_prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}


resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}
#we are duplacting the code
#we can use map varaibles to do the iteration. but i am not keen to use the map variables. 
locals {
  web_inbound_ports = {
    "110" : "22",
    "120" : "80",
    "130" : "443"
  }
}
#inside a resource block we can user one single resource 

resource "azurerm_network_security_rule" "web_nsg_inbound_rule" {
  for_each                    = local.web_inbound_ports
  name                        = "Rule-Port-${each.value}" #Rule-port-22
  priority                    = each.key                  #110 
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value #22
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}

