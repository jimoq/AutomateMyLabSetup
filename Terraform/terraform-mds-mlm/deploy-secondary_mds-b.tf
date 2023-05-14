resource "vsphere_virtual_machine" "lseg-mds-b" {
  name                 = "lseg-mds-b"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_host.host.resource_pool_id
  folder               = var.vsphere_server_folder

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  
  num_cpus             = data.vsphere_ovf_vm_template.ovfMgmt.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovfMgmt.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovfMgmt.memory
  guest_id             = data.vsphere_ovf_vm_template.ovfMgmt.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovfMgmt.scsi_type
  
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovfMgmt.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovfMgmt.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovfMgmt.disk_provisioning
    ovf_network_map           = data.vsphere_ovf_vm_template.ovfMgmt.ovf_network_map
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    enable_hidden_properties = true
  }
  vapp {
    properties = {
      
      "admin_hash"     = "${var.chkp_otp_key}",
      "password_type" = "Plain",
      "ipaddr_v4" = "192.168.100.120",
      "clish_commands" = "${
                            "set timezone Europe / Stockholm"                                                                 }${
                            ";set user admin shell /bin/bash"                                                                 }${
                            ";set hostname lseg-mds-b"                                                                        }${
                            ";set interface eth0 ipv4-address 192.168.100.120 mask-length 24"                                 }${
                            ";set static-route default nexthop gateway address 192.168.100.1 on"                            }${
                            ";set ntp active on"                                                                              }${
                            ";set ntp server primary se.pool.ntp.org version 4"                                               }${
                            ";set dns mode default"                                                                           }${
                            ";set dns suffix local"                                                                           }${
                            ";set dns primary 8.8.8.8"                                                                        }${
                            ";config_system --config-string '"                                                                }${
                            "mgmt_admin_radio=gaia_admin"                                                                     }${
                            "&mgmt_gui_clients_radio=any"                                                                     }${
                            "&install_mds_secondary=true"                                                                     }${
                            "&install_mds_interface=eth0"                                                                     }${
                            "&ftw_sic_key=${var.chkp_otp_key}"                                                                  }${
                            "&download_info=true"                                                                             }${
                            "&reboot_if_required=true"                                                                        }${                          
                            "'"
                            }"
    }
  }
}