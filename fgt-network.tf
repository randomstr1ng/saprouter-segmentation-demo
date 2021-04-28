resource "azurerm_network_interface" "fgtport1" {
  name                = "fgtport1"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fgtiface1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.FGTPublicIp.id
  }

  tags = {}
}

resource "azurerm_network_interface" "fgtport2" {
  name                = "fgtport2"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.dmz_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fgtiface2
  }

  tags = {}
}

resource "azurerm_network_interface" "fgtport3" {
  name                = "fgtport3"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.internal_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fgtiface3
  }

  tags = {}
}

resource "azurerm_network_security_group" "publicnetworknsg" {
  name                = "PublicNetworkSecurityGroup"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {}
}

resource "azurerm_network_security_group" "privatenetworknsg" {
  name                = "PrivateNetworkSecurityGroup"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {}
}

resource "azurerm_network_security_rule" "outgoing_public" {
  name                        = "egress"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.publicnetworknsg.name
}

resource "azurerm_network_security_rule" "outgoing_private" {
  name                        = "egress-private"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.privatenetworknsg.name
}

resource "azurerm_network_interface_security_group_association" "port1nsg" {
  depends_on                = [azurerm_network_interface.fgtport1]
  network_interface_id      = azurerm_network_interface.fgtport1.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  depends_on                = [azurerm_network_interface.fgtport2]
  network_interface_id      = azurerm_network_interface.fgtport2.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port3nsg" {
  depends_on                = [azurerm_network_interface.fgtport3]
  network_interface_id      = azurerm_network_interface.fgtport3.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}

resource "azurerm_public_ip" "FGTPublicIp" {
  name                = "FGTPublicIP"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"

  tags = {}
}