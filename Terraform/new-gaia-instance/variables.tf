# Set VMware parameters
# these are set as enviromental variables i.e: "export TF_VAR_vsphere_server=cloud.local"
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_datacenter" {}

variable "vsphere_datastore" {
  description = "The datastore to to store the new VM"
  default = "datastore1"
}

variable "vsphere_host" {
  description = "The ESXi host to where the VM should be created"
  default = "cloud03.local"
}

variable "vsphere_network" {
  description = "VM net to connet the virtual machine to"
  default     = "VM Network"
}

variable "vsphere_virtual_machine_template" {
  description = "The VM template to clone from"
  default     = "cloud03_r81dot20"
}

variable "vsphere_virtual_machine_vm" {
  description = "The VM name to clone to"
  #default     = ""
}

variable "vsphere_server_folder" {
  description = "The vCenter folder to put the VM in"
  default     = "cplab"
}

variable "vsphere_virtual_cpus" {
  description = "Number of CPUs need to be at least 2"
  default     = "4"
}

variable "vsphere_virtual_memory" {
  description = "Memory needs to be at least 4 GB"
  default     = "8192"
}

variable "gaia_instance_target" {
  description = "Setting this IP for the new Gaia instance "
  #default     = ""
}

variable "gaia_instance_type" {
  description = "Setting Gaia instance type. Accepted values are: primary_mds, secondary_mds, mdls, primary_sms, secondary_sms, ls_se, smsg, sg"
  #default     = ""
}