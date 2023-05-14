resource "vsphere_virtual_machine" "poc-mlm" {
  depends_on           = [ module.vmware ]
  name                 = "poc-mlm"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_host.host.resource_pool_id
  folder               = var.vsphere_folder_name

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5
  
  num_cpus             =  module.vmware.num_cpus
  num_cores_per_socket =  module.vmware.num_cores_per_socket
  memory               =  module.vmware.memory
  guest_id             =  module.vmware.guest_id
  scsi_type            =  module.vmware.scsi_type
  
  dynamic "network_interface" {
    for_each =  module.vmware.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            =  module.vmware.remote_ovf_url
    disk_provisioning         =  module.vmware.disk_provisioning
    ovf_network_map           =  module.vmware.ovf_network_map
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    enable_hidden_properties = true
  }
  vapp {
    properties = {
      
      "hostname" = "poc-mlm",
      "mgmt_admin_passwd" = "${var.chkp_otp_key}",
# Everything below is optional.
      "CheckPoint.adminHash" = "${var.chkp_otp_key}",
      "eth0.ipaddress" = "192.168.100.130",
      "eth0.subnetmask" = "24",
      "eth0.gatewayaddress" = "192.168.100.1",
      "primary" = "172.23.38.5",
      "user_data" = "${base64encode(<<EOF
echo "cloud-init start" `date`
clish -s -c "set ntp server primary 192.168.100.101 version 3"
clish -s -c "delete ntp server ntp2.checkpoint.com"
clish -s -c "set ntp active on"
clish -s -c "set timezone Etc / GMT+3"
clish -s -c "set user admin shell /bin/bash"
clish -s -c "set dns mode default"
clish -s -c "set dns suffix local"
clish -s -c "add user ansibleuser uid 0 homedir /home/ansibleuser"
clish -s -c "set user ansibleuser password-hash '${var.chkp_passwd_hash}'"
clish -s -c "add rba user ansibleuser roles adminRole"
clish -s -c "set user ansibleuser shell /bin/bash"
clish -s -c "set timezone Etc / GMT+3"
gaia_api access -u ansibleuser -e true
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
config_system --config-string 'mgmt_admin_radio=gaia_admin&mgmt_gui_clients_radio=any&install_mlm=true&install_mds_interface=eth0&ftw_sic_key=${var.chkp_otp_key}&download_info=true&reboot_if_required=true&maintenance_hash=grub.pbkdf2.sha512.10000.EED96942B7C4CD093DB77FD1C71CFB2DF901F2B8719FFAC15C2C1C8ACF5D8420A8059978CE3DFD5EE057071E1A30E5E34A1D380FA5D212E58E7C50AAFE26F0E0.F0824ED6973BB399CA79F2E743F41137E89DFC73D78B8B0F8D89F6D8F2D78B0AA75AF3939DD554403D32D08047293E263F11541B0816032754A9DB9784253509'
sleep 5
while true; do
    status=`api status |grep 'Check Point Security Management Server is running and ready' |wc -l`
    echo "Checking if the CPM is ready"
    if [[ ! $status == 0 ]]; then
         break
    fi
       sleep 15
    done
echo "CPM ready " `date`
sleep 5
# Upload and copy API hotfix files
curl_cli -o  r81.20-api-fix.tgz http://192.168.100.53/r81.20-api-fix.tgz
source /etc/profile; mdsstop
tar -xvzf r81.20-api-fix.tgz --directory /opt/CPsuite-R81.20/fw1/cpm-server/
source /etc/profile; mdsstart
echo "cloud-init end" `date`
      EOF
      )}"

#### parameters for R81.10 images
#      "admin_hash"     = "${var.chkp_otp_key}",
#      "password_type" = "Plain",
#      "ipaddr_v4" = "192.168.100.130",
#      "clish_commands" = "${
#                            "set timezone Europe / Stockholm"                                                                 }${
#                            ";set user admin shell /bin/bash"                                                                 }${
#                            ";set hostname lesg-mlm"                                                                          }${
#                            ";set interface eth0 ipv4-address 192.168.100.130 mask-length 24"                                 }${
#                            ";set static-route default nexthop gateway address 192.168.100.1 on"                            }${
#                            ";set ntp active on"                                                                              }${
#                            ";set ntp server primary se.pool.ntp.org version 4"                                               }${
#                            ";set dns mode default"                                                                           }${
#                            ";set dns suffix local"                                                                           }${
#                            ";set dns primary 172.23.39.5"                                                                        }${
#                            ";config_system --config-string '"                                                                }${
#                            "mgmt_admin_radio=gaia_admin"                                                                     }${
#                            "&mgmt_gui_clients_radio=any"                                                                     }${
#                            "&install_mds_secondary=true"                                                                     }${
#                            "&install_mds_interface=eth0"                                                                     }${
#                            "&ftw_sic_key=${var.chkp_otp_key}"                                                                }${
#                            "&download_info=true"                                                                             }${
#                            "&reboot_if_required=true"                                                                        }${                          
#                            "'"
#                            }"
    }
  }
}
