resource "azurerm_public_ip" "web_linuixvm_publicip" {
    for_each = var.car
  name                = "${local.resource_name_prefix}-publicip-${each.key}"
  ##the name of the public will be unqiue
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   #dynamic
  sku                 = "Standard" #basic #premium
  tags                = local.common_tags
  
}