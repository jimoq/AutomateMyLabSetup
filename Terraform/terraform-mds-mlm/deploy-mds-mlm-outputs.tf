# prints all deployed management virtual machines default IP
output "lseg-mds-a_eth0_ip_addresses" {
  description = "The DHCP address that was assigned to this vm"
  value = vsphere_virtual_machine.lseg-mds-a.vapp[0].properties.ipaddr_v4
}

output "lseg-mds-b_eth0_ip_addresses" {
  description = "The DHCP address that was assigned to this vm"
  value = vsphere_virtual_machine.lseg-mds-b.vapp[0].properties.ipaddr_v4
}

output "lseg-mlm_eth0_ip_addresses" {
  description = "The DHCP address that was assigned to this vm"
  value = vsphere_virtual_machine.lseg-mlm.vapp[0].properties.ipaddr_v4
}