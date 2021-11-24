#!/bin/bash
clish -c 'set user admin shell /bin/bash' -s
config_system -s 'mgmt_admin_radio=gaia_admin&mgmt_gui_clients_radio=any&install_mds_primary=true&install_mds_interface=eth0&download_info=true'
/opt/CPvsec-R81.10/bin/vsec on
while true; do
    status=`api status |grep 'API readiness test SUCCESSFUL. The server is up and ready to receive connections' |wc -l`
    echo "Checking if the API is ready"
    if [[ ! $status == 0 ]]; then
         break
    fi
       sleep 15
    done
echo "API ready " `date`
sleep 5
echo "Set R80 API to accept all ip addresses"
mgmt_cli -r true set api-settings accepted-api-calls-from "All IP addresses" --domain 'System Data'
echo "Add user api_user with password vpn123"
mgmt_cli -r true add administrator name "api_user" password "Cpwins123" must-change-password false authentication-method "INTERNAL_PASSWORD" multi-domain-profile "Multi-Domain Super User" --domain 'System Data'
echo "Restarting API Server"
api restart
