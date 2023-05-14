// --- vSphere settings ---
#vsphere_user = ""
#vsphere_password = ""
#vsphere_server = ""
#vsphere_datacenter = ""
#vsphere_datastore = ""
#vsphere_host = ""
#mgmt_net = Internal_1
#remote_ovf_url = "http://X.X.X.X"
vsphere_folder_name = "automation-poc"

# This password hash is for vpn123 - please do not use this for production
chkp_passwd_hash =  "\\$6\\$UAxWXDhef2zm8mqt\\$gvnwQIF1dkw8J9JUvmyYXUeAt2LSl4V62JKNFilEK0YQGo4ACOTry4QLWjE9nMQOPCKs42ZleldciXgCdnjCd1"

# Default SIC key - please also replace this with your key
chkp_otp_key = "vpn123"

# Default admin password - plain text option. To use a hash - paste the hash value here and change the value in deploy-resilient-gateways.tf for password-type to Hash
chkp_admin_password_plain = "vpn123"