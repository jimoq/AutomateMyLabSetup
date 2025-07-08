terraform {
  required_providers {
    checkpoint = {
      source  = "CheckPointSW/checkpoint"
      version = "2.9.0"
    }
  }
}


/*
terraform {
  required_providers {
    example = {
      source  = "terraform.local/local/example"
      version = "1.0.0"
      # Other parameters...
    }
  }
}
*/

# Configure Check Point Provider for Management API
provider "checkpoint" {
  server   = "192.168.233.40"
  username = "admin"
  password = "zubur1"
  context  = "web_api"
  #  session_name = "gw Terraform Session"
}

/*resource "checkpoint_management_simple_gateway" "gw1234" {
  name         = "gw1234"
  ipv4_address = "10.0.0.113"
  color = "sea green"
  #  one_time_password = "vpn123"
  enable_https_inspection = false
  https_inspection {
    bypass_on_failure {
      override_profile = false
      value            = false
    }
    deny_expired_server_cert {
      override_profile = false
      value            = false
    }
    deny_revoked_server_cert {
      override_profile = false
      value            = false
    }
    deny_untrusted_server_cert {
      override_profile = false
      value            = false
    }
    site_categorization_allow_mode {
      override_profile = false
    }
  }
}*/

resource "checkpoint_management_simple_gateway" "gw12346" {
  name         = "gw12346"
  ipv4_address = "10.0.0.116"
  color = "sea green"
}

resource "checkpoint_management_publish" "publish" {
  depends_on             = [checkpoint_management_simple_gateway.gw12346]
  run_publish_on_destroy = true
}