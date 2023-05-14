output "num_cpus" {
  value = data.vsphere_ovf_vm_template.ovfRemote.num_cpus
}

output "num_cores_per_socket" {
  value = data.vsphere_ovf_vm_template.ovfRemote.num_cores_per_socket
}

output "memory" {
  value = data.vsphere_ovf_vm_template.ovfRemote.memory
}

output "guest_id" {
  value = data.vsphere_ovf_vm_template.ovfRemote.guest_id
}

output "scsi_type" {
  value = data.vsphere_ovf_vm_template.ovfRemote.scsi_type
}

output "ovf_network_map" {
  value = data.vsphere_ovf_vm_template.ovfRemote.ovf_network_map
}

output "remote_ovf_url" {
  value = data.vsphere_ovf_vm_template.ovfRemote.remote_ovf_url
}

output "disk_provisioning" {
  value = data.vsphere_ovf_vm_template.ovfRemote.disk_provisioning
}
