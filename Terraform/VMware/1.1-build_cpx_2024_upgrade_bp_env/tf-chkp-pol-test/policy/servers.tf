resource "checkpoint_management_checkpoint_host" "cpx-secsm" {
  name         = "cpx-secsm"
  ipv4_address = "192.168.233.41"
  color        = "dark sea green"

  os                = "Gaia"            # Example: Gaia, SecurePlatform, Windows, Linux
  version           = "R81.20"          # Example: R81.20, R81.10, R80.40, etc.
  hardware          = "CloudGuard IaaS" # Example: Open server, Smart-1, etc.
  one_time_password = "vpn123"          # One-time password for initial setup

  management_blades = {
    network_policy_management = true
    secondary                 = true
    logging_and_status        = true
  }
}

resource "checkpoint_management_checkpoint_host" "cpx-se" {
  name         = "cpx-se"
  ipv4_address = "192.168.233.42"
  color        = "crete blue"

  os                = "Gaia"            # Example: Gaia, SecurePlatform, Windows, Linux
  version           = "R81.20"          # Example: R81.20, R81.10, R80.40, etc.
  hardware          = "CloudGuard IaaS" # Example: Open server, Smart-1, etc.
  one_time_password = "vpn123"          # One-time password for initial setup

  management_blades = {
    logging_and_status      = true
    smart_event_server      = true
    smart_event_correlation = true
  }
}

resource "checkpoint_management_checkpoint_host" "cpx_ls_test" {
  name         = "cpx-ls-test"
  ipv4_address = "192.168.233.44"
  color        = "blue"

  os                = "Gaia"            # Example: Gaia, SecurePlatform, Windows, Linux
  version           = "R81.20"          # Example: R81.20, R81.10, R80.40, etc.
  hardware          = "CloudGuard IaaS" # Example: Open server, Smart-1, etc.
  one_time_password = "vpn123"          # One-time password for initial setup

  management_blades = {
    logging_and_status = true
  }
}

