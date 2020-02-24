The azure provider requires Azure CLI:
https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html

install instructions can be found here:
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
Install with one command
Microsoft offer and maintain a script which runs all of the installation commands in one step. Run it by using curl and pipe directly to bash, or download the script to a file and inspect it before running.
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

Update
Use apt-get upgrade to update the CLI package.
sudo apt-get update && sudo apt-get install --only-upgrade -y azure-cli

Azure cli authentication
Firstly, login to the Azure CLI using
login -u myapi_user@myaccount.onmicrosoft.com -p mypassword

Once logged in - it's possible to list the Subscriptions associated with the account via:
az account list

Should you have more than one Subscription, you can specify the Subscription to use via the following command:
az account set --subscription="SUBSCRIPTION_ID"

