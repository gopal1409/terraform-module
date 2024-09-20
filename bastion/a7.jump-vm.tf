resource "azurerm_linux_virtual_machine" "jump_linux_vm" {
  
  name                = "${local.resource_name_prefix}-jumphost"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.jumpvm_nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh/terraform-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
 
}