resource "vsphere_virtual_machine" "transfer-router" {
  depends_on = [ module.vmware ]
  count = 1
  name                 = "transfer-router${count.index + 1}"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_host.host.resource_pool_id
  folder               = var.vsphere_folder_name

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  
  num_cpus             = module.vmware.num_cpus
  num_cores_per_socket = module.vmware.num_cores_per_socket
  memory               = module.vmware.memory
  guest_id             = module.vmware.guest_id
  scsi_type            = module.vmware.scsi_type
  cpu_hot_add_enabled = true
  memory_hot_add_enabled = true
  
  dynamic "network_interface" {
    for_each = module.vmware.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  disk {
    label = "disk0"
    size  = 500
    io_share_count = 1000
  } 
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = "http://ursula.local/ovf/jaguar_opt_main-777-991001696-GW.ova"
    disk_provisioning         = module.vmware.disk_provisioning
    ovf_network_map           = module.vmware.ovf_network_map
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    enable_hidden_properties = true
  }
  vapp {
    properties = {
#      "CheckPoint.ftwSicKey" = "vpn123"
      "user_data" = "${base64encode(<<EOF
          #cloud-config
          hostname: transfer-router${count.index + 1}
          password: ${var.chkp_otp_key}
          runcmd:
            - ${"config_system.orig --config-string '"   }${
                "mgmt_admin_radio=gaia_admin&"      }${
                "mgmt_gui_clients_radio=any&"       }${
                "install_security_managment=false&" }${
                "install_mgmt_primary=false&"       }${
				        "install_security_gw=true&"         }${
				        "gateway_daip=false&"               }${
				        "install_ppak=true&"                }${
				        "gateway_cluster_member=true&"      }${
                "ftw_sic_key=${var.chkp_otp_key}&"  }${
                "ipstat_v4=manually&"               }${
                "ipstat_v6=manually&"               }${
                "download_info=true&"               }${
                "reboot_if_required=true&"          }${
                "maintenance_hash=grub.pbkdf2.sha512.10000.EED96942B7C4CD093DB77FD1C71CFB2DF901F2B8719FFAC15C2C1C8ACF5D8420A8059978CE3DFD5EE057071E1A30E5E34A1D380FA5D212E58E7C50AAFE26F0E0.F0824ED6973BB399CA79F2E743F41137E89DFC73D78B8B0F8D89F6D8F2D78B0AA75AF3939DD554403D32D08047293E263F11541B0816032754A9DB9784253509" }${
                "'"
               }
            - clish -s -c 'set interface eth2.200 ipv6-address 2a04:6447:900:200::10 mask-length 64'
            - clish -s -c 'set interface eth2.300 ipv6-address 2a04:6447:900:300::10 mask-length 64'
            - sysctl -w net.ipv4.ip_forward=1
          clish:
            - set user admin shell /bin/bash
            - set timezone Europe / Stockholm
#            - delete interface eth2.200 ipv4-address
#            - delete interface eth2.300 ipv4-address
#          blink_config:
          network:
            version: 1
            config:
            - type: physical
              name: eth0
              subnets:
                - type: static
                  address: 192.168.233.50/24
                  gateway: 192.168.233.254
#                  dns_nameservers: [192.168.233.233, 8.8.8.8]
            - type: physical
              name: eth2
            - type: vlan
              name:      eth2.200
              vlan_link: eth2
              vlan_id:   200
            - type: vlan
              name:      eth2.300
              vlan_link: eth2
              vlan_id:   300
      EOF
      )}" 
    }
  }
  lifecycle {

    ignore_changes = [
      vapp[0]
    ]
  }
}
