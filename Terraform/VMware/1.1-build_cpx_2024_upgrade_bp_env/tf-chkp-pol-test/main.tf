terraform {
  required_providers {
    checkpoint = {
      source  = "terraform.local/local/checkpoint"
      version = "5.0.0"
    }
  }
}

# Configure the Check Point Provider
provider "checkpoint" {
  server        = "chkp-jimo-msp-n3o54r70.maas.checkpoint.com"
  api_key       = "LBKb4CvodM+SdtjRI8AmjA=="
  context       = "web_api"
  cloud_mgmt_id = "77da4fab-c457-4646-8e63-d67e55345af8"
  timeout       = "120"
}

module "policy" {
  #  depends_on = [ azurerm_virtual_machine.cp-gw ]
  source = "./policy"

  #  cp_gw_name = azurerm_virtual_machine.cp-gw.name
  #  cp_gw_name = "TF-SE-Demo-cp-gw"
  #  sic_key  = var.sic_key 
  #  gw-external-private-ip = var.gw-external-private-ip
  #  gw-internal-private-ip = var.gw-internal-private-ip
}

// Example - Trigger the publish resource every time there is a change on any of the configuration files in a specific module
// Expression to use to hash all files in directory policy that is used by the policy module
locals {
  publish_triggers = [for filename in fileset(path.module, "policy/*.tf") : filesha256(filename)]
}

// Triggers publish if any of the hashes of the files in the policy directory changed.
resource "checkpoint_management_publish" "publish" {
  depends_on = [module.policy]
  triggers   = local.publish_triggers
}