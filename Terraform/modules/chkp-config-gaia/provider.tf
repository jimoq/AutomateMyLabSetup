terraform {
  required_providers {
    restapi = {
      source = "Mastercard/restapi"
#      version = "1.17.0"
    }
  }
}

provider "restapi" {
  # Configuration options
  uri      = "https://192.168.233.199/gaia_api"
  insecure = true
  write_returns_object = true
  debug = true

  headers = {
    "X-chkp-sid" = "test"
    "Content-Type" = "application/json"
  }

  create_method  = "POST"
  update_method  = "POST"
  destroy_method = "POST"
  read_method    = "POST"

}