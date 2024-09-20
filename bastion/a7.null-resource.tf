resource "null_resource" "copy-ssh" {
    depends_on = [ azurerm_linux_virtual_machine.jump_linux_vm ]
    #depending on a resource till that resource is not created my this resource block will not execute
  connection {
    type = "ssh" #RDP
    host = azurerm_linux_virtual_machine.jump_linux_vm.public_ip_address
    user =  azurerm_linux_virtual_machine.jump_linux_vm.admin_username
    private_key = file("${path.module}/ssh/terraform-azure.pem")
  }

  provisioner "file" {
    source = "ssh/terraform-azure.pem" #python app.py mysql.dump
    destination = "/tmp/terraform-azure.pem"
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo chmod 400 /tmp/terraform-azure.pem" #python app.py 
     ]
  }
}