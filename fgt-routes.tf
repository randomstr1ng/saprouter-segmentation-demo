
resource "azurerm_route_table" "dmz" {
  name                = "DMZRouteTable"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  route = [ 
  {
    address_prefix = "0.0.0.0/0"
    name = "default"
    next_hop_in_ip_address = var.fgtiface2
    next_hop_type = "VirtualAppliance"
  },
  {
    address_prefix = "10.0.3.0/24"
    name = "internal-subnet"
    next_hop_in_ip_address = var.fgtiface2
    next_hop_type = "VirtualAppliance"
  },
  {
    address_prefix = "10.0.1.0/24"
    name = "external-subnet"
    next_hop_in_ip_address = var.fgtiface2
    next_hop_type = "VirtualAppliance"
    },
]
}

resource "azurerm_route_table" "internal" {
  name                = "INTERNALRouteTable"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  route = [ 
  {
    address_prefix = "0.0.0.0/0"
    name = "default"
    next_hop_in_ip_address = var.fgtiface3
    next_hop_type = "VirtualAppliance"
    },
    {
    address_prefix = "10.0.1.0/24"
    name = "external-subnet"
    next_hop_in_ip_address = var.fgtiface3
    next_hop_type = "VirtualAppliance"
    },
    {
    address_prefix = "10.0.2.0/24"
    name = "dmz-subnet"
    next_hop_in_ip_address = var.fgtiface3
    next_hop_type = "VirtualAppliance"
  },
  ]
}

resource "azurerm_route_table" "public" {
  name                = "PUBLICRouteTable"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  route = [ 
    {
    address_prefix = "10.0.3.0/24"
    name = "internal-subnet"
    next_hop_in_ip_address = var.fgtiface1
    next_hop_type = "VirtualAppliance"
  },
  {
    address_prefix = "10.0.2.0/24"
    name = "dmz-subnet"
    next_hop_in_ip_address = var.fgtiface1
    next_hop_type = "VirtualAppliance"
  },
  ]
}

resource "azurerm_subnet_route_table_association" "dmz-associate" {
  subnet_id      = azurerm_subnet.dmz_subnet.id
  route_table_id = azurerm_route_table.dmz.id
}

resource "azurerm_subnet_route_table_association" "internal-associate" {
  subnet_id      = azurerm_subnet.internal_subnet.id
  route_table_id = azurerm_route_table.internal.id
}

resource "azurerm_subnet_route_table_association" "public-associate" {
  subnet_id      = azurerm_subnet.public_subnet.id
  route_table_id = azurerm_route_table.public.id
}