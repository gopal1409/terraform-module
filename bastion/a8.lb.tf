##LETS CREATE THE PUBLIC IP FOPR THE LB
resource "azurerm_public_ip" "lb_publicip" {
  
  name                = "${local.resource_name_prefix}-lbpublicip"
  ##the name of the public will be unqiue
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   #dynamic
  sku                 = "Standard" #basic #premium
  tags                = local.common_tags
}

#now we will create the load balancer
resource "azurerm_lb" "web_lb" {
   name                = "${local.resource_name_prefix}-lb"
  ##the name of the public will be unqiue
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.lb_publicip.id
  }
}

#lets create the backend pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "${local.resource_name_prefix}-backendpool"
}

#we will create a healtch chekup for lb

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "${local.resource_name_prefix}-probes"
  port            = 80 #if i am running tomcat
  protocol = "Tcp"
  #request_path  = "/home/index.html"
  interval_in_seconds = 15 #every 15 second it will ping your application in port 80
  number_of_probes = 4 ##4 times it will ping within in 1 min if it dont get response stop sneding the traffi
}

#lets create an lb _rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "${local.resource_name_prefix}-lbrule"
  protocol                       = "Tcp"
  frontend_port                  = 80 #this is the load balancer port
  backend_port                   = 80 #iof yoour application is running on different change it here
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id = azurerm_lb_probe.lb_probe.id 
}

#lets asociate the backend pool 
resource "azurerm_network_interface_backend_address_pool_association" "lb_associate" {
    for_each = var.car
  network_interface_id    = azurerm_network_interface.webvm_nic[each.key].id
  ip_configuration_name   = azurerm_network_interface.webvm_nic[each.key].ip_configuration[0].name 
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}