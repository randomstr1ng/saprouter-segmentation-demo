resource "azurerm_linux_virtual_machine" "linux_server_attacker" {
    depends_on            = [azurerm_virtual_machine.fgtvm]
    name                  = "vm-attacker"
    location              = var.region
    resource_group_name   = azurerm_resource_group.resource_group.name
    network_interface_ids = [azurerm_network_interface.attackervm_nic.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "OSDisk-vm-attacker"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name  = "vm-attacker"
    admin_username = "${var.suffix}-admin"
    disable_password_authentication = true
    custom_data    = base64encode(data.template_file.attacker-vm.rendered)

    admin_ssh_key {
        username       = "${var.suffix}-admin"
        public_key     = tls_private_key.ssh_key.public_key_openssh
    }
    tags = {}
}

resource "time_sleep" "delay_60s" {
  depends_on = [azurerm_virtual_machine.fgtvm]

  create_duration = "60s"
}

resource "azurerm_linux_virtual_machine" "linux_server_saprouter" {
    depends_on            = [time_sleep.delay_60s]
    name                  = "vm-saprouter"
    location              = var.region
    resource_group_name   = azurerm_resource_group.resource_group.name
    network_interface_ids = [azurerm_network_interface.saprouter_nic.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "OSDisk-vm-saprouter"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name  = "vm-saprouter"
    admin_username = "azureuser"
    admin_password = "Sojdlg123aljg"
    disable_password_authentication = false
    custom_data    = base64encode(data.template_file.saprouter-vm.rendered)

    tags = {}
}

resource "azurerm_linux_virtual_machine" "linux_server_target" {
    depends_on            = [azurerm_virtual_machine.fgtvm]
    name                  = "vm-target"
    location              = var.region
    resource_group_name   = azurerm_resource_group.resource_group.name
    network_interface_ids = [azurerm_network_interface.target_nic.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "OSDisk-vm-target"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name  = "vm-target"
    admin_username = "azureuser"
    admin_password = "Sojdlg123aljg"
    disable_password_authentication = false
        
    tags = {}
}