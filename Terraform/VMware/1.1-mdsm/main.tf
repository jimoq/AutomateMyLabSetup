terraform {
  # Define reuired terraform version
  required_version = ">= 0.14.3"
  # Define required providers
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.2.0"
    }
  }
}

// --- Configure the vsphere Provider ---
provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

// --- Configure datacenter, datastore, host ---
data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

module "vmware" {
  source = "../modules/vmware"

  vsphere_user = var.vsphere_user
  vsphere_password = var.vsphere_password
  vsphere_server = var.vsphere_server
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_datastore = var.vsphere_datastore
  vsphere_host = var.vsphere_host
  mgmt_net = var.mgmt_net
  remote_ovf_url = "${var.remote_ovf_url}/R81.20-mgmt-ivory_main-take-569-991001290-CloudGuard-Network.ovf"
}