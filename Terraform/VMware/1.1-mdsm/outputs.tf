# prints deployed virtual machines IP
output "mds-a_eth0_ip_addresses" {
  value = vsphere_virtual_machine.ws-mds-a.default_ip_address
  }

output "mds-b_eth0_ip_addresses" {
  value = vsphere_virtual_machine.ws-mds-b.default_ip_address
}

output "mlm_eth0_ip_addresses" {
  value = vsphere_virtual_machine.ws-mlm.default_ip_address
}

