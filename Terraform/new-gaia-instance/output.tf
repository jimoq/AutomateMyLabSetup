# prints all deployed virtual machines mapped to their IPs
output "virtual_machine_name_mapped_to_default_ip" {
  description = "The default IP address of each virtual machine deployed, indexed by name."

  value = zipmap(vsphere_virtual_machine.vm.*.name, vsphere_virtual_machine.vm.*.default_ip_address)
}

# 
output "vm_dhcp_address" {
  description = "The DHCP address that was assigned to this vm"
  value = vsphere_virtual_machine.vm.default_ip_address
}