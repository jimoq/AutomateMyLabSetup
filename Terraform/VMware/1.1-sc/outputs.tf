# prints deployed virtual machines IP
output "sc_eth0_ip_addresses" {
  value = vsphere_virtual_machine.ws-sc.default_ip_address
  }