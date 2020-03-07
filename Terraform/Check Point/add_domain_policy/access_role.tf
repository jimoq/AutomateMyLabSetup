resource "checkpoint_management_access_role" "Admins" {
  name = "Admins"
  color = "blue"
}

resource "checkpoint_management_access_role" "Finance_User" {
  name = "Finance User"
  color = "blue"
}

resource "checkpoint_management_access_role" "HR" {
  name = "HR"
  color = "blue"
}

resource "checkpoint_management_access_role" "IT_Department" {
  name = "IT Department"
  color = "blue"
}

resource "checkpoint_management_access_role" "Corporate_Remote_Access_Users" {
  name = "Corporate Remote Access Users"
  remote_access_clients = "Corporate VPN Client"
  color = "red"
}