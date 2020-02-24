data "vsphere_datacenter" "dc" {
  name = "Darkness"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "cloud03.local"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "gaia_r80.40"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terra-sg89"
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
 # vCenter Folder to place the VM in
 folder           = "cplab"

  num_cpus = 4
  memory   = 8192
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

 
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
# Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible. Default
#	linked_clone = true

  }
  provisioner "local-exec" {
  command = "ansible-playbook configure_gaia.yml"
  }
}

data "vsphere_virtual_machine" "sg89" {
  name          = vsphere_virtual_machine.vm.name
  datacenter_id = data.vsphere_datacenter.dc.id
}

output "virtual_machine_default_name_ips" {
  description = "The default IP address of each virtual machine deployed, indexed by name."

  value = zipmap(vsphere_virtual_machine.vm.*.name, vsphere_virtual_machine.vm.*.default_ip_address)
}

