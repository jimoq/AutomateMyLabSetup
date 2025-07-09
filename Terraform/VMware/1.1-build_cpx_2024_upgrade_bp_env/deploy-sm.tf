resource "vsphere_virtual_machine" "cpx-sm" {
  depends_on       = [module.vmware]
  name             = "cpx-sm"
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  folder           = var.vsphere_folder_name

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  num_cpus             = module.vmware.num_cpus
  num_cores_per_socket = module.vmware.num_cores_per_socket
  memory               = module.vmware.memory
  guest_id             = module.vmware.guest_id
  scsi_type            = module.vmware.scsi_type

  dynamic "network_interface" {
    for_each = module.vmware.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  disk {
    label          = "disk0"
    size           = 500
    io_share_count = 1000
  }
  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = module.vmware.remote_ovf_url
    disk_provisioning         = module.vmware.disk_provisioning
    ovf_network_map           = module.vmware.ovf_network_map
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    enable_hidden_properties  = true
  }
  vapp {
    properties = {
      "user_data" = "${base64encode(<<EOF
          #cloud-config
          hostname: cpx-sm
          password: ${var.chkp_otp_key}
          config_system:
            domainname: lab.local
            timezone: Europe/Stockholm
            install_security_managment: true
            install_mgmt_primary: true
            mgmt_admin_radio: gaia_admin
            mgmt_gui_clients_radio: any
            download_info: true
            reboot_if_required : true
            maintenance_hash: grub.pbkdf2.sha512.10000.EED96942B7C4CD093DB77FD1C71CFB2DF901F2B8719FFAC15C2C1C8ACF5D8420A8059978CE3DFD5EE057071E1A30E5E34A1D380FA5D212E58E7C50AAFE26F0E0.F0824ED6973BB399CA79F2E743F41137E89DFC73D78B8B0F8D89F6D8F2D78B0AA75AF3939DD554403D32D08047293E263F11541B0816032754A9DB9784253509
#          runcmd:
#            - chmod 0777 /var/log/tmp
#            - rm -rf /var/tmp/*;rmdir /var/tmp;ln -s /var/log/tmp /var/tmp
          clish:
            - set user admin shell /bin/bash
          sshd_config:
            usedns: no
            passwordauthentication: yes
          network:
            version: 1
            config:
            - type: physical
              name: eth0
              subnets:
                - type: static
                  address: 192.168.233.40/24
                  gateway: 192.168.233.254
                  dns_nameservers: [192.168.233.233, 8.8.8.8]
      EOF
      )}"
    }
  }
  lifecycle {

    ignore_changes = [
      vapp[0],
      ovf_deploy[0]
    ]
  }
}