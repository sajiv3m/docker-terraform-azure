# Definition file for the subnet to which all hosts are connected to

resource "azurerm_subnet" "mydockersubnet" {
    name                 = "${var.DOCKER_SUBNET_NAME}"
    resource_group_name  = "${azurerm_resource_group.mydockergroup.name}"
    virtual_network_name = "${azurerm_virtual_network.mydockernetwork.name}"
    address_prefix       = "${var.DOCKER_SUBNET}"
}

# The Network security group (NSG) / Firewall rules are applied to the subnet
resource "azurerm_subnet_network_security_group_association" mydockersubnet {
    subnet_id                 = "${azurerm_subnet.mydockersubnet.id}"
    network_security_group_id = "${azurerm_network_security_group.mydockernsg.id}"
}
