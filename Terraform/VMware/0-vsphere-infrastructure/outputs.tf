output "sphere_distributed_virtual_switch_name" {
  value = vsphere_distributed_virtual_switch.dvs.name  
}

output "vsphere_distributed_port_group_pg1000" {
  value = vsphere_distributed_port_group.pg1000.name
}

output "vsphere_distributed_port_group_pg1001" {
  value = vsphere_distributed_port_group.pg1001.name
}

output "vsphere_distributed_port_group_pg1002" {
  value = vsphere_distributed_port_group.pg1002.name
}

output "vsphere_folder_name" {
  value = var.vsphere_folder_name  
}