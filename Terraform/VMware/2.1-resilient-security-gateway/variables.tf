variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
  default = "DC_POC_Lab"
}

variable "vsphere_datastore" {
  type = string
  default = "datastore1"
}

variable "vsphere_host" {
  type = string
  default = "172.23.23.44"
}

variable "mgmt_net" {
  description = "The virtual network for Check Point management traffic"
  default     = "Internal_1"
}

variable "remote_ovf_url" {
  type = string
  default = "http://ursula.local/ovf" 
}

variable "vsphere_folder_name" {
  type = string
  default = "automation-poc"
}

variable "chkp_passwd_hash" {
  type = string
}

variable "chkp_otp_key" {
  type = string
}

variable "chkp_admin_password_plain" {
  type = string
}