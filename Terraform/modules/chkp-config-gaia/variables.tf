# This variable uses the module.new-gaia-instance.vm_dhcp_address
variable "gaia_ip" {
  type = string
  description = "The IP address of the Gaia machine where to execute GAIA API"
  #default = "httpbin.org/post"
}

variable "gaia_sid" {
  default = ""
}

# Set Gaia credentials
# these are set as enviromental variables i.e: "export TF_VAR_gaia_api_user=admin"
variable "gaia_api_user" {}
variable "gaia_api_password" {}

