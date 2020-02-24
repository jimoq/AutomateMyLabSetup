# Configure the Dome9 Provider
provider "dome9" {
  dome9_access_id     = var.dome9_access_id
  dome9_secret_key    = var.dome9_secret_key
}

# Setup new Azure Subscription
resource "dome9_cloudaccount_azure" "VisualStudio" {
  name            = "VisualStudio"
  operation_mode  = "Read"
  subscription_id = var.azure_sub
  tenant_id       = var.azure_tenant
  client_id       = var.azure_client_id
  client_password = var.azure_client_pass
}

resource "dome9_continuous_compliance_notification" "Ryan_ProjectBigfoot" {
  name           = "ryan at projectbigfoot"
  description    = "ACME_Email_1"
  alerts_console = true

  change_detection {
    email_sending_state                = "Enabled"
    email_per_finding_sending_state    = "Enabled"

    email_data {
      recipients = ["ryan@projectbigfoot.net"]
    }
     email_per_finding_data {
      recipients                 = ["ryan@projectbigfoot.net"]
      notification_output_format = "PlainText"
   }
  }
}

resource "dome9_continuous_compliance_notification" "Ryan_ProjectSasquatch" {
  name           = "ryan at projectsasquatch"
  description    = "ACME_Email_2"
  alerts_console = true
  scheduled_report {
    email_sending_state = "Enabled"
    schedule_data {
      cron_expression = "0 0 15 * * ?"
      type = "Detailed"
      recipients = ["ryan@projectsasquatch.net"]
    }
  }
  change_detection {
    email_sending_state                = "Enabled"
    email_per_finding_sending_state    = "Enabled"

    email_data {
      recipients = ["ryan@projectsasquatch.net"]
    }
    email_per_finding_data {
      recipients                 = ["ryan@projectsasquatch.net"]
      notification_output_format = "PlainText"
   }
  }
}

resource "dome9_continuous_compliance_policy" "Azure_ACME_Policy" {
  cloud_account_id    = dome9_cloudaccount_azure.VisualStudio.id
  external_account_id = dome9_cloudaccount_azure.VisualStudio.id
  bundle_id           = dome9_ruleset.newruleset.id
  cloud_account_type  = "Azure"
  notification_ids    = [dome9_continuous_compliance_notification.Ryan_ProjectBigfoot.id, dome9_continuous_compliance_notification.Ryan_ProjectSasquatch.id]
}

resource "dome9_ruleset" "newruleset" {
  name        = "Terraform_ACME_Azure_NSG_Rule"
  description = "Demo CPX Rule"
  cloud_vendor = "azure"
  language = "en"
  hide_in_compliance = false
  is_template = false
  rules {
    name = "ACME Azure NSG Rule"
    logic = "VirtualMachine where isPublic=true should not have nics with [ networkSecurityGroup.name='no-NSG-attached' and subnet.securityGroup.name='no-NSG-attached' ]"
    severity = "High"
    description = "Attach a Network Security Group to each VM or subnet containing a VM. If no Network Security Group is attached to either the Virtual Machine or the subnet, the VM is not protected and can be accessed from the internet."
    compliance_tag = "Network Security"
    priority = "high"
    is_default = false
    remediation = "Attach a Network Security Group to the Virtual Machine or to the Subnet containing the VM. It is recommended to attach a Security Group to all relevant elements in Azure"
  }
}

resource "dome9_iplist" "iplist_1" {
  name        = "ACME Example List #1"
  description = "List Example #1"
  items  {
        ip = "10.2.0.0/16"
        comment = "Net 10 dot 2"
          }
  items  {
        ip = "192.168.1.3/32"
        comment = "My IP"
          }
}

#resource "dome9_cloudaccount_aws" "AWS_CPX2020" {
#  name  = "AWS_ACME"
#
#  credentials  {
#    arn    = var.aws_arn 
#    secret = var.aws_secret 
#    type   = "RoleBased"
#  }
#
#  net_sec {
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "us_east_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "us_west_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "eu_west_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ap_southeast_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ap_northeast_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "us_west_2"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "sa_east_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ap_southeast_2"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "eu_central_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ap_northeast_2"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ap_south_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "us_east_2"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "ca_central_1"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "eu_west_2"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "eu_west_3"
#    }
#    regions {
#      new_group_behavior = "ReadOnly"
#      region             = "eu_north_1"
#    }
#  }
#}