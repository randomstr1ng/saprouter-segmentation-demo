resource "azurerm_virtual_machine" "fgtvm" {
  name                         = "fgtvm"
  location                     = var.region
  resource_group_name          = azurerm_resource_group.resource_group.name
  network_interface_ids        = [azurerm_network_interface.fgtport1.id, azurerm_network_interface.fgtport2.id, azurerm_network_interface.fgtport3.id]
  primary_network_interface_id = azurerm_network_interface.fgtport1.id
  vm_size                      = var.size
  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.fgtsku
    version   = var.fgtversion
  }

  plan {
    name      = var.fgtsku
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgtvm"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}
}

data "template_file" "fgtvm" {
  template = file(var.bootstrap-fgtvm)
  vars = {
    license_file    = var.license
    resource_group  = azurerm_resource_group.resource_group.name
    subscription_id = var.subscription_id
    # client_secret   = var.client_secret
    # client_id       = var.client_id
    # tenant_id       = var.tenant_id
    flexvm_token    = var.flexvm_token
  }
}