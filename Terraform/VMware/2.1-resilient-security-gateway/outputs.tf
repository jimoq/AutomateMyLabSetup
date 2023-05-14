output "gateway_eth0_ip_addresses" {
  value = vsphere_virtual_machine.vmFromRemoteOvf[*].vapp[0].properties.ipaddr_v4
}

output "gateway_eth1_ip_addresses" {
  value = vsphere_virtual_machine.vmFromRemoteOvf[*].vapp[0].properties.eth1_ipaddr_v4
}

