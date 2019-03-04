# Definition file for the VNET

resource "azurerm_virtual_network" "mydockernetwork" {
    name                = "${var.DOCKER_VNET_NAME}"
    address_space       = ["${var.DOCKER_VNET}"]
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

    tags {
        environment = "Docker Demo"
    }
}

