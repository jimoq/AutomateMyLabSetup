provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_dc
}

data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "mgmt-net" {
  name = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_ovf_vm_template" "ovfMgmt" {
  name              = "CPGateway01"
  disk_provisioning = "thin"
  resource_pool_id  = data.vsphere_host.host.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.host.id
  remote_ovf_url    = "http://ursula.local/ovf/Check_Point_R81.10_Cloudguard_Security_Management_VE.ova"
#  remote_ovf_url    = "http://192.168.100.53/Check_Point_R81.10_Cloudguard_Security_Gateway_VE.ova"
  ovf_network_map = {
    "Network 1" : data.vsphere_network.mgmt-net.id
  }
}

resource "vsphere_virtual_machine" "lseg-mds-a" {
  name                 = "lseg-mds-a"
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
      "ipaddr_v4" = "192.168.100.110",
      "clish_commands" = "${
                            "set timezone Europe / Stockholm"                                                                 }${
                            ";set user admin shell /bin/bash"                                                                 }${
                            ";set hostname lseg-mds-a"                                                                        }${
                            ";set interface eth0 ipv4-address 192.168.100.110 mask-length 24"                                 }${
                            ";set static-route default nexthop gateway address 192.168.100.1 on"                            }${
                            ";set ntp active on"                                                                              }${
                            ";set ntp server primary se.pool.ntp.org version 4"                                               }${
                            ";set dns mode default"                                                                           }${
                            ";set dns suffix local"                                                                           }${
                            ";set dns primary 8.8.8.8"                                                                        }${
                            ";config_system --config-string '"                                                                }${
                            "mgmt_admin_radio=gaia_admin"                                                                     }${
                            "&mgmt_gui_clients_radio=any"                                                                     }${
                            "&install_mds_primary=true"                                                                       }${
                            "&install_mds_interface=eth0"                                                                     }${
                            "&download_info=true"                                                                             }${
                            "&reboot_if_required=true"                                                                        }${                          
                            "'"
                            }"
    }
  }
}

#Examaple from Khalid
#  vapp {
#    properties = {
#      "hostname"   = "GW_R81_10",
#      # Options: ["Hashed","Plain"]
#      "password_type" = "Plain",
#      "admin_hash" = "Cpwins!1",
#      "ntp_primary"   = "pool.ntp.org",
#      "primary"       = "10.0.2.171",
#      "secondary"     = "8.8.8.8"
#      # this is misspelled and it will fail, it should be tertiary
#      #"tretiatry"     = "1.1.1.1"
#      # Options: string["Standalone","Security Gateway","Security Management"]
#      "solution_type"   = "Security Gateway",
#      "run_ftw"         = "Yes",
#      "ftw_sic_key"     = "vpn123",
#      "default_gw_v4"   = "203.0.113.1",
#      "ipaddr_v4"       = "203.0.113.111",
#      "masklen_v4"      = "24",
#      "eth1_ipaddr_v4"  = "10.0.1.111",
#      "eth1_masklen_v4" = "24",
#      # vApp has a bug where the subnet mask for eth2 cannot be configured "missing". It can be configured but use the commands to configure the interface
#      "eth2_ipaddr_v4"  = "10.0.2.111",
#      # "eth2_masklen_v4" = "24",    Missing in the vApp      
#      #  Options ["1","2","3","4"]
#      "ntp_primary_version"       = "4",
#      "is_gateway_cluster_member" = "No",
#      # bug. Won't work since the script on the CP VM uses the wrong commands 'set dns timezone' instead of 'set timezone' 
#      #"timezone"                  = "America/New_York",
#      # add more configurations to FTW. Read sk69701 fro more details.
#      "additional_configuration"  = "domainname=alshawwaf.ca",
#      # list of commands separated by a semicolon. expert password is Cpwins!1. Use the commands to set the interfaces since this vApp only allows up to eth2 only. The Expert password configurations below won't work. seem to suffer from sk176703
#      "clish_commands"            = "add interface lo loopback 10.0.0.1/32 ;set user admin shell /bin/bash ;set expert-password-hash \\$6\\$rounds=10000\\$oknNESG1\\$SLC.0EaQVO.hD/HeK.iMdv7AuHKlyzAqtvfNxE35umna4zsgWy3atl7Fzl8em9zJR7LFuRgf4X.YPzdAX.U9S1"
#      "default_values" = "admin_mgmt_name=admin&download_info=true&upload_info=false&iface=eth0&ipstat_v4=manually&ipstat_v6=false"
#
#    }
#  }
#}