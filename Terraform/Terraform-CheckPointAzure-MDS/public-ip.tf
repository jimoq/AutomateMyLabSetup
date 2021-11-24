resource "azurerm_public_ip" "mds10publicip" {
    name                         = "MDS10PublicIP"
    location                     = azurerm_resource_group.rg.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method = "Static"
}
