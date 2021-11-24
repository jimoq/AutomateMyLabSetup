resource "azurerm_network_interface" "mds10external" {
    name                = "mds10external"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_ip_forwarding = "false"
	ip_configuration {
        name                          = "mds10externalConfiguration"
        subnet_id                     = azurerm_subnet.External_subnet.id
        private_ip_address_allocation = "Static"
		private_ip_address = "10.1.0.10"
        primary = true
		public_ip_address_id = azurerm_public_ip.mds10publicip.id
    }

}
