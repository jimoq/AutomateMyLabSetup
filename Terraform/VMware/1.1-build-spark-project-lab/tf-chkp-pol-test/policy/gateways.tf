#data "local_file" "maasip" {
#  filename   = "maas_ip.txt"
#}
#
#resource "checkpoint_management_simple_gateway" "example" {
#  name = "gw1"
#  ipv4_address = "192.0.2.1"
#}

resource "checkpoint_management_simple_gateway" "rugg-ro-cpsg" {
  count = 2
  name = "rugg-ro-sg7${count.index + 1}"
  ipv4_address = "192.168.233.7${count.index + 1}"
  one_time_password = "vpn123"
  comments = "Terraformed gateway 7${count.index + 1}"
  anti_bot = "true"
  anti_virus = "true"
  application_control = "true"
  url_filtering = "true"
 firewall = "true"
  ips = "true"
  threat_emulation = "false"
  threat_extraction = "false"
  vpn = "true"
  interfaces {
    name = "eth0"
      ipv4_address = "192.168.233.7${count.index + 1}"
      ipv4_network_mask = "255.255.255.0"
      anti_spoofing = "true"
      topology = "External"
  }
  interfaces {
      name = "eth1"
      ipv4_address = "1.1.2.7${count.index + 1}"
      ipv4_network_mask = "255.255.255.0"
      anti_spoofing = "true"
      topology = "Internal"
      topology_settings = {
        ip_address_behind_this_interface = "network defined by the interface ip and net mask"
        }
  }
  interfaces {
      name = "eth2"
      ipv4_address = "2.2.2.7${count.index + 1}"
      ipv4_network_mask = "255.255.255.0"
      anti_spoofing = "true"
      topology = "Internal"
      topology_settings = {
        ip_address_behind_this_interface = "network defined by the interface ip and net mask"
        }
  }
  interfaces {
      name = "eth3"
      ipv4_address = "3.3.3.7${count.index + 1}"
      ipv4_network_mask = "255.255.255.0"
      anti_spoofing = "true"
      topology = "Internal"
      topology_settings = {
        ip_address_behind_this_interface = "network defined by the interface ip and net mask"
        }
      }
  lifecycle {
  ## Lifcyle block needs to be fixed, is currnetly ignoring all atributes and will never propose updates to the object
#    ignore_changes = all
  }
}

#resource "checkpoint_management_command_get_interfaces" "get_interfaces" {
#  target_name = var.cp_gw_name  
#  depends_on = [ checkpoint_management_simple_gateway.cpsg ]
#}