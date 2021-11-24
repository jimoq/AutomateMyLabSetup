# Create virtual machine and Accept the agreement for the mgmt-byol 
resource "azurerm_marketplace_agreement" "checkpoint" {
  publisher = "checkpoint"
  offer     = "check-point-cg-r8110"
  plan      = "mgmt-byol"
}