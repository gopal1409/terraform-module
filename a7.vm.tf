resource "azurerm_linux_virtual_machine" "web_linux_vm" {
    for_each = var.car
  name                = "${local.resource_name_prefix}-webvm-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.webvm_nic[each.key].id,
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
  custom_data = filebase64("${path.module}/app/app.sh")
  tags = local.common_tags
  lifecycle {
    ignore_changes = [ 
      tags
     ]
  }
}