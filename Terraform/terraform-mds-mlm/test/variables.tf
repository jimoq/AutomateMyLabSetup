variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "vsphere_dc" {
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

variable "vsphere_resource_pool" {
  type = string
  default = "defaultPool"
}

variable "vsphere_server_folder" {
  description = "The vCenter folder to put the VM in"
  default     = "LSEG-POV"
}


###### Check point config variables
variable "chkp_otp_key" {
  description = "The one time SIC key"
  default     = "Cpwins2022!!"
}