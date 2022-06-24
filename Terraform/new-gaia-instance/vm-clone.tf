data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vsphere_virtual_machine_vm
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
 # vCenter Folder to place the VM in
 folder           = var.vsphere_server_folder

  num_cpus = var.vsphere_virtual_cpus
  memory   = var.vsphere_virtual_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0 

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

 
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
# Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible. Default false
#	linked_clone = true

  }
#  provisioner "local-exec" {
#  command = "ansible-playbook ../../Ansible/conf_gaia_instance_from_Terraform.yml -e \"target=var.gaia_instance_target vm_name=var.vsphere_virtual_machine_vm type=var.gaia_instance_type\""
#  }
}

#data "vsphere_virtual_machine" "sg89" {
#  name          = vsphere_virtual_machine.vm.name
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

output "virtual_machine_default_name_ips" {
  description = "The default IP address of each virtual machine deployed, indexed by name."

  value = zipmap(vsphere_virtual_machine.vm.*.name, vsphere_virtual_machine.vm.*.default_ip_address)
}

