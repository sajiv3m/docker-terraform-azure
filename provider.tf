# Definition file for the provider - Microsoft Azure

# This file has the connection details for the specific Microsoft Azure tenant and subscription
provider "azurerm" { 
    subscription_id = "${var.AZURE_SUBSCRIPTION_ID}"
    client_id = "${var.AZURE_CLIENT_ID}"
    client_secret = "${var.AZURE_CLIENT_SECRET}"
    tenant_id = "${var.AZURE_TENANT_ID}"
}
