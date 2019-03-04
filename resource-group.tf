# Definition file for the Resource group in Azure
resource "azurerm_resource_group" "mydockergroup" {
    name     = "${var.DOCKER_RESOURCE_GROUP}"
    location = "${var.AZURE_LOCATION}"

    tags {
        environment = "Docker Demo"
    }
}
