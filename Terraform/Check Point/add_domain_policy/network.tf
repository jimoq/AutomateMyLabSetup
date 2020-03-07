resource "checkpoint_management_network" "HR_LAN" {
  name = "HR LAN"
  subnet4 = "198.51.100.15"
  mask_length4 = 32
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}

resource "checkpoint_management_network" "Sales_LAN" {
  name = "Sales LAN"
  subnet4 = "198.51.100.16"
  mask_length4 = 32
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}

resource "checkpoint_management_network" "DMZ_LAN" {
  name = "DMZ_LAN"
  subnet4 = "198.51.100.17"
  mask_length4 = 32
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}

resource "checkpoint_management_network" "Branch_Office_LAN" {
  name = "Branch Office LAN"
  subnet4 = "198.51.100.18"
  mask_length4 = 32
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}

resource "checkpoint_management_network" "Data_Center_LAN" {
  name = "Data Center LAN"
  subnet4 = "198.51.100.19"
  mask_length4 = 32
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}
