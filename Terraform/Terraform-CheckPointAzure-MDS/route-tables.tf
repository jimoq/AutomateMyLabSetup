resource "azurerm_route_table" "DMZ2RT" {
  name                = "DMZ2RT"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "internal"
    address_prefix = "10.1.0.0/20"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.1.1.10"
  }

  }
