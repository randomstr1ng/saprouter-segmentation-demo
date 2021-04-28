resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${var.suffix}"
    address_space       = ["10.0.0.0/16"]
    location            = var.region
    resource_group_name = azurerm_resource_group.resource_group.name

    tags = {}
}

resource "azurerm_subnet" "public_subnet" {
    name                 = "subnet-public"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "dmz_subnet" {
    name                 = "subnet-dmz"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "internal_subnet" {
    name                 = "subnet-internal"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "attacker_publicip" {
    name                         = "PublicIP-attacker-vm"
    location                     = var.region
    resource_group_name          = azurerm_resource_group.resource_group.name
    allocation_method            = "Static"

    tags = {}
}

# attacker-vm networking
resource "azurerm_network_interface" "attackervm_nic" {
    name                      = "nic-attacker-vm"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.resource_group.name

    ip_configuration {
        name                          = "var.azurerm_network_interface.vm_nic_card.name-configuration"
        subnet_id                     = azurerm_subnet.public_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.attacker_publicip.id
    }

    tags = {}
}

# saprouter-vm networking
resource "azurerm_network_interface" "saprouter_nic" {
    name                      = "nic-saprouter-vm"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.resource_group.name

    ip_configuration {
        name                          = "var.azurerm_network_interface.vm_nic_card.name-configuration"
        subnet_id                     = azurerm_subnet.dmz_subnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {}
}
# target-vm networking
resource "azurerm_network_interface" "target_nic" {
    name                      = "nic-target-vm"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.resource_group.name

    ip_configuration {
        name                          = "var.azurerm_network_interface.vm_nic_card.name-configuration"
        subnet_id                     = azurerm_subnet.internal_subnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {}
}

# NSG
resource "azurerm_network_security_group" "server_nsg" {
    name                = "nsg-${var.suffix}"
    location            = var.region
    resource_group_name = azurerm_resource_group.resource_group.name
    
    security_rule {
        name                       = "All-IN"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "All-OUT"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {}
}

resource "azurerm_network_interface_security_group_association" "connect_nsg_attackervm" {
    network_interface_id      = azurerm_network_interface.attackervm_nic.id
    network_security_group_id = azurerm_network_security_group.server_nsg.id
}
resource "azurerm_network_interface_security_group_association" "connect_nsg_saprouter" {
    network_interface_id      = azurerm_network_interface.saprouter_nic.id
    network_security_group_id = azurerm_network_security_group.server_nsg.id
}
resource "azurerm_network_interface_security_group_association" "connect_nsg_target" {
    network_interface_id      = azurerm_network_interface.target_nic.id
    network_security_group_id = azurerm_network_security_group.server_nsg.id
}