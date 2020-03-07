resource "checkpoint_management_access_section" "Data_Center_Access" {
  name = "Data Center Access"
  position = {top = "top"}
  layer = "Network"
}

resource "checkpoint_management_access_section" "DMZ" {
  name = "DMZ"
  position = {top = "top"}
  layer = "Network"
}
