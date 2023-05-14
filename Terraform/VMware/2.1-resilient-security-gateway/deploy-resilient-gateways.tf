resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
  depends_on = [ module.vmware ]
  count = 3
  name                 = "AutomationTest${count.index + 1}"
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
      "admin_hash"     = "${var.chkp_admin_password_plain}",
      "password_type" = "Plain",
      "ntp_primary" = "192.168.100.101",
      "primary" = "172.23.39.5",
      "solution_type" = "Security Gateway",
      "run_ftw" = "Yes",
      "ftw_sic_key" = "${var.chkp_otp_key}",
      "hostname" = "testgateway${count.index + 1}",
      "default_gw_v4" = "192.168.100.1",
      "ipaddr_v4" = "192.168.100.1${count.index + 1}",
      "masklen_v4" = "24"
      "eth1_ipaddr_v4" = "50.50.50.1${count.index + 1}",
      "eth1_masklen_v4" = "24",
      "ntp_primary_version" = "3",
      "is_gateway_cluster_member" = "Yes"
      "clish_commands" = "set interface eth2 ipv4-address 60.60.60.1${count.index + 1} mask-length 24; set interface eth2 state on; add user ansibleuser uid 0 homedir /home/ansibleuser; set user ansibleuser password-hash '${var.chkp_passwd_hash}'; add rba user ansibleuser roles adminRole; set user ansibleuser shell /bin/bash; set timezone Etc / GMT+3"
    }
  }
  lifecycle {

    ignore_changes = [
      vapp[0]
    ]
  }
}
