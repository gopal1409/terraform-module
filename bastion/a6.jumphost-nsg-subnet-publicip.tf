#public ip for jump
resource "azurerm_public_ip" "jump_linuixvm_publicip" {
  name                = "${local.resource_name_prefix}-jumphostpublicip"
  ##the name of the public will be unqiue
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   #dynamic
  sku                 = "Standard" #basic #premium
  tags                = local.common_tags
}
#subnet for jump

resource "azurerm_subnet" "jump_subnet" {
  name                 = "${local.resource_name_prefix}-${var.jump_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.jump_subnet_address
}
##nic for jump
resource "azurerm_network_interface" "jumpvm_nic" {
   
  name                = "${local.resource_name_prefix}-jumpnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "internal"
    #a private ip
    subnet_id                     = azurerm_subnet.jump_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump_linuixvm_publicip.id
  }
}

##nsg for jump host
resource "azurerm_network_security_group" "jump_subnet_nsg" {
  name                = "${local.resource_name_prefix}-jumpnsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}


resource "azurerm_subnet_network_security_group_association" "jump_nsg_associate"{
  subnet_id                 = azurerm_subnet.jump_subnet.id
  network_security_group_id = azurerm_network_security_group.jump_subnet_nsg.id
}
#we are duplacting the code
#we can use map varaibles to do the iteration. but i am not keen to use the map variables. 
locals {
  jump_inbound_ports = {
    "110" : "22",
    "120" : "3389"
    
  }
}
#inside a resource block we can user one single resource 

resource "azurerm_network_security_rule" "jump_nsg_inbound_rule" {
  for_each                    = local.jump_inbound_ports
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
  network_security_group_name = azurerm_network_security_group.jump_subnet_nsg.name
}

