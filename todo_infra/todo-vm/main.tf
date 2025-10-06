resource "azurerm_network_interface" "nic"{
    name = var.nic_name
  resource_group_name = var.rg_name
  location = var.location

  ip_configuration {
    name = "internal"
    subnet_id = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pip_todo.id
  }
}
resource "azurerm_linux_virtual_machine" "todo_vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

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
  custom_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              echo "Hello from Terraform + Nginx!" | sudo tee /var/www/html/index.html
              EOF
  )
}