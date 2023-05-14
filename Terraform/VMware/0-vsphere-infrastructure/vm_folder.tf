// --- Creates a virtual machine folder named automation-poc in the default datacenter's VM hierarchy ---
resource "vsphere_folder" "folder" {
  path          = var.vsphere_folder_name
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}