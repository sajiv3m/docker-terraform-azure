# Definition file for the Storage account

resource "azurerm_storage_account" "dcrstorageaccount" {
    name                = "${var.DOCKER_STORAGE_ACCOUNT}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
    location            = "${var.AZURE_LOCATION}"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags {
        environment = "Docker Demo"
    }
}