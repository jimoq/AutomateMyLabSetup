terraform {
  required_providers {
    checkpoint = {
      #      source  = "terraform.local/local/checkpoint" // use this when to test a local provider
      source = "checkpointsw/checkpoint"
    }
  }
}

# Configure the Check Point Provider
# Smart-1 Cloud example
/*
  provider "checkpoint" {
  server        = "chkp-jimo-msp-n3o54r70.maas.checkpoint.com"
  api_key       = "LBKb4CvodM+SdtjRI8AmjA=="
  context       = "web_api"
  cloud_mgmt_id = "77da4fab-c457-4646-8e63-d67e55345af8"
  timeout       = "120"
}
*/

# Configure the Check Point Provider
# Local Management example
provider "checkpoint" {
  server = "192.168.233.40"
  #  api_key       = "xxxxx"  # Disable to use ennviromental variable CHECKPOINT_API_KEY
  username = "admin"
  #  password = "xxxxxx" # Disable to use ennviromental variable CHECKPOINT_PASSWORD
  #  domain   = "Domain Name" # Optional, if not specified, the default domain will be used
  context = "web_api"
  timeout = "120"
}


module "policy" {
  source = "./policy"

}

module "smsg" {
  source = "./servers-and-gateways"

}



// Trigger the publish resource every time there is a change on any of the configuration files in a specific module
// Expression to use to hash all files in directory that is used by the module
locals {
  publish_triggers_policy = [for filename in fileset(path.module, "policy/*.tf"): filesha256(filename)]
  publish_triggers_smsg = [for filename in fileset(path.module, "servers-and-gateways/*.tf"): filesha256(filename)]
}

// Triggers publish if any of the hashes of the files in the policy directory changed.
resource "checkpoint_management_publish" "publish" {
  depends_on = [module.policy]
  triggers   = local.publish_triggers_policy

  run_publish_on_destroy = true
}

// Triggers publish if any of the hashes of the files in the policy directory changed.
resource "checkpoint_management_publish" "publish_smsg" {
  depends_on = [module.smsg]
  triggers   = local.publish_triggers_smsg

  run_publish_on_destroy = true
}

// Triggers install policy if any of the hashes of the files in the policy directory changed and publish-policy resource is executed
resource "checkpoint_management_install_policy" "install_policy" {
  depends_on = [ checkpoint_management_publish.publish ]
  triggers   = local.publish_triggers_policy
  policy_package = "Standard"
  #targets    = [module.policy.checkpoint_management_simple_gateway.cpx-ro-cpsg[0]]
}