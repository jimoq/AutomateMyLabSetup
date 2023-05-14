// --- Create a distributed virtual switch with three VLANS for the Check Point VMs ---
resource "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.dvs_name
  datacenter_id = data.vsphere_datacenter.datacenter.id

  host {
    host_system_id = data.vsphere_host.host.id
  }
}

resource "vsphere_distributed_port_group" "pg1000" {
  name                            = var.pg1000
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.dvs.id
  vlan_id = 1000
}
resource "vsphere_distributed_port_group" "pg1001" {
  name                            = var.pg1001
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.dvs.id
  vlan_id = 1001
}
resource "vsphere_distributed_port_group" "pg1002" {
  name                            = var.pg1002
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.dvs.id
  vlan_id = 1002
}

