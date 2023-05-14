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
  default = "X.X.X.X"
}

variable "dvs_name" {
  description = "The distributed virtal switch name used to assign the port groups to"
  default = "dvs-automation-poc"
}

variable "mgmt_net" {
  description = "The virtual network for Check Point management traffic"
  default     = "Internal_1"
}


variable "pg1000" {
  description = "Assigned to Check Point Gaia VM eth0 network"
  default     = "pg-mgmt-1000"
}

variable "pg1001" {
  description = "Assigned to Check Point Gaia VM eth1 network"
  default = "pg-isolated-1001"
}

variable "pg1002" {
  description = "Assigned to Check Point Gaia VM eth2 network"
  default = "pg-isolated-1002"
}

variable "remote_ovf_url" {
  type = string
  default = "http://x.x.x.x" 
}