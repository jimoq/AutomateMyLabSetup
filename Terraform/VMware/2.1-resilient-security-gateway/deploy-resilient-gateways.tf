resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
  depends_on = [ module.vmware ]
  count = 1
  name                 = "ws-sg11${count.index + 1}"
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
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = module.vmware.remote_ovf_url
    disk_provisioning         = module.vmware.disk_provisioning
    ovf_network_map           = module.vmware.ovf_network_map
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    enable_hidden_properties = true
  }
  vapp {
    properties = {
      "CheckPoint.ftwSicKey" = "vpn123"
      "user_data" = "${base64encode(<<EOF
          #cloud-config
          hostname: ws-sg11${count.index + 1}
          runcmd:
            - chmod 0777 /var/log/tmp
            - rm -rf /var/tmp/*;rmdir /var/tmp;ln -s /var/log/tmp /var/tmp
          clish:
            - set user admin shell /bin/bash
#            - set user admin password password-hash ${var.chkp_passwd_hash} # Does not work..
          blink_config:
            gateway_cluster_member: no
            admin_password_regular: vpn123
            maintenance_password_regular: vpn123
            download_from_checkpoint_non_security: true
            download_info: true
            upload_info: false
            upload_crash_data: false
            ftw_sic_key: vpn123 
          network:
            version: 1
            config:
            - type: physical
              name: eth0
              subnets:
                - type: static
                  address: 192.168.233.11${count.index + 1}/24
                  gateway: 192.168.233.254
                  dns_nameservers: [192.168.233.233, 8.8.8.8]
            - type: physical
              name: eth1
              subnets:
                - type: static
                  address: 1.1.2.11${count.index + 1}/30
            - type: physical
              name: eth2
              mtu: 9000
              subnets:
                - type: static
                  address: 2.2.2.11${count.index + 1}/24
            - type: physical
              name: eth3
              mtu: 9000
              subnets:
                - type: static
                  address: 3.3.3.11${count.index + 1}/24
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
