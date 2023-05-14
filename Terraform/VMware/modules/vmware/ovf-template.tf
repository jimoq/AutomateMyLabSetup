data "vsphere_distributed_virtual_switch" "vds" {
  name          = var.dvs_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "mgmt-net" {
  name = var.mgmt_net
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "pg1001" {
  name                            = var.pg1001
  datacenter_id                   = data.vsphere_datacenter.datacenter.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
}

data "vsphere_network" "pg1002" {
  name                            = var.pg1002
  datacenter_id                   = data.vsphere_datacenter.datacenter.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
}

// --- Submit Check Point OVF/OVA to vSphere and extract its hardware settings to be used by vsphere_virtual_machine resource ---
data "vsphere_ovf_vm_template" "ovfRemote" {
  name              = "CPTemplate"
  disk_provisioning = "thin"
  resource_pool_id  = data.vsphere_host.host.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.host.id
  remote_ovf_url    = var.remote_ovf_url
  ovf_network_map = {
    "Network 1" : data.vsphere_network.mgmt-net.id
    "Network 2" : data.vsphere_network.pg1001.id
    "Network 3" : data.vsphere_network.pg1002.id
  }
}