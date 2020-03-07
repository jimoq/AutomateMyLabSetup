resource "checkpoint_management_host" "DNS_Server" {
  name = "DNS Server"
  ipv4_address = "198.51.100.9"
  color = "red"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "ERP_Server" {
  name = "ERP Server"
  ipv4_address = "198.51.100.10"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "Exchange" {
  name = "Exchange"
  ipv4_address = "198.51.100.11"
  color = "light green"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "FTP_Int" {
  name = "FTP_Int"
  ipv4_address = "198.51.100.12"
  color = "light green"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "Web_Server" {
  name = "Web Server"
  ipv4_address = "198.51.100.13"
  color = "red"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "MTA" {
  name = "MTA"
  ipv4_address = "198.51.100.14"
  color = "red"
  nat_settings = {
    auto_rule = false
    }
}

