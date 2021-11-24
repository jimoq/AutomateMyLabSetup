resource "azurerm_virtual_machine" "chkpmds" {
    name                  = "mds10"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.mds10external.id]
    primary_network_interface_id = azurerm_network_interface.mds10external.id
    vm_size               = "Standard_D4s_v3"
    
    depends_on = [azurerm_marketplace_agreement.checkpoint]

    storage_os_disk {
        name              = "mds10Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "checkpoint"
        offer     = "check-point-cg-r8110"
        sku       = "mgmt-byol"
        version   = "latest"
    }

    plan {
        name = "mgmt-byol"
        publisher = "checkpoint"
        product = "check-point-cg-r8110"
        }
    os_profile {
        computer_name  = "mds10"
        admin_username = "azureuser"
        admin_password = "Cpwins1!!"
        custom_data = file("customdata.sh") 
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

}
