# Add Rules to "Web Control" Layer

resource "checkpoint_management_access_rule" "DNS_server_Access" {
  layer = "Web Control"
  position = {top = "top"}
  name = "DNS server should have access to"
  action = "Accept"
  source = ["DNS Server"]
  destination = ["ExternalZone"]
  service = ["dns"]
  track = {
    type = "Log"
  }
}

resource "checkpoint_management_access_rule" "Block_abuse" {
  layer = "Web Control"
  position = {below = checkpoint_management_access_rule.DNS_server_Access.name}
  name = "Block abuse/ high risk applications"
  source = ["Corporate LANs", "Branch Office LAN"]
  destination = ["Internet"]
  service = ["Inappropriate Sites"]
  action = "drop"
#  user_check = {
#    interaction = "Blocked Message - Access Control"
#  }
  track = {
    type = "Log"
  }
}


#echo "add rules to 'Web Control Layer"
#"%varMgmt_cli%"  add access-rule layer "Web Control" name "HR can access to social network applications" action inform position bottom source "[\"HR\"]" destination "[\"Internet\"]" service.1 "Facebook" service.2 "Twitter" service.3 "LinkedIn" user-check.interaction "Access Approval" track log -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Web Control" name "All employees can access YouTube for work purposes" action ask position bottom source "[\"Corporate LANs\", \"Branch Office LAN\"]" destination "[\"Internet\"]" service.1 "YouTube" service.2 "Vimeo" user-check.interaction "Company Policy" track log -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Web Control" name "Block specific URLs" action drop position bottom destination "[\"Internet\"]" service.1 "Blocked URLs" track log -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Web Control" name "Block specific categories for all employees" action drop position bottom source "[\"Corporate LANs\", \"Branch Office LAN\"]" destination "[\"Internet\"]" service.1 "Social Networking" service.2 "Streaming Media Protocols" service.3 "P2P File Sharing" user-check.interaction "Blocked Message - Access Control" track log -s id.txt
#"%varMgmt_cli%"  delete access-rule rule-number 2 layer "Web Control" -s id.txt
#rem ##################################################################################
#
#
#rem ################### Add Rules to "Data Center Layer" Layer #################################
#echo "add rules to 'Data Center Layer' layer"
#"%varMgmt_cli%"  add access-rule layer "Data Center Layer" name "Mobile Access for Internal FS" action accept position top source "[\"Sales\"]" destination "[\"FTP_Int\"]" vpn "RemoteAccess" service.1 "ftp" data "[\"Document File\", \"Archive File\"]" track "detailed log" -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Data Center Layer" name "Branch office should have VPN access to servers  (ERP on ftp_22)" action accept position bottom source "[\"Branch Office LAN\"]" destination "[\"ERP Server\", \"Exchange\", \"FTP_Int\"]" vpn "Site2Site" service.1 "ftp" service.2 "smtp" service.3 "ftp" data "[\"Document File\", \"Media and Images\"]" track "detailed log" -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Data Center Layer" name "ERP server being accessed on FTP via port 22" action accept position bottom source "[\"Corporate LANs\"]" destination "[\"ERP Server\"]" service.1 "ftp" data "[\"Document File\"]" track "detailed log" -s id.txt 
#"%varMgmt_cli%"  add access-rule layer "Data Center Layer" name "Only Finance department has access to reports" action accept position bottom source "[\"Finance User\"]" destination "[\"ERP Server\"]" service.1 "Report Portal" track "detailed log" -s id.txt
#"%varMgmt_cli%"  add access-rule layer "Data Center Layer" name "Save DNS requests using our DNS" action accept position bottom source "[\"DMZZone\", \"InternalZone\"]" destination "[\"DNS Server\"]" service.1 "dns" track log -s id.txt
#rem #remove default clean up rule
#"%varMgmt_cli%"  delete access-rule rule-number 2 layer "Data Center Layer" -s id.txt
#rem ##################################################################################
#
#
#rem ################### Add Rules to "Guest Exception Layer" Layer #################################
#echo "add rules to 'Guest Exception Layer' layer"
#"%varMgmt_cli%"  add access-rule layer "Guest Exception Layer" name "Guests from Portal" action accept position top destination "[\"Internet\"]" service.1 "http" service.2 "https" track log action-settings.enable-identity-captive-portal true -s id.txt
#rem #remove default clean up rule
#"%varMgmt_cli%"  delete access-rule rule-number 2 layer "Guest Exception Layer" -s id.txt
#rem ##################################################################################