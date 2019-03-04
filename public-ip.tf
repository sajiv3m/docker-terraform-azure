/*  Definition file for the 3 public IP addresses we need
    Allocation method must be Static, so the IP address is assigned immediately
    for Dynamic allocation method, IP address is only assigned when the NIC is attached to VM */
resource "azurerm_public_ip" "mydockerpublicip" {
    name                 = "dcrhostpublicip"
    location			 = "${var.AZURE_LOCATION}"
    allocation_method	 = "Static"
    resource_group_name  = "${azurerm_resource_group.mydockergroup.name}"
    domain_name_label    = "${var.DOCKER_UCP_FQDN}"

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_public_ip" "mylindcrworker" {
    name                 = "lindcrworkerpublicip"
    location			 = "${var.AZURE_LOCATION}"
    allocation_method	 = "Static"
    resource_group_name  = "${azurerm_resource_group.mydockergroup.name}"
    domain_name_label    = "${var.DOCKER_LINUXWORKER_FQDN}"

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_public_ip" "mywindcrworker" {
    name                 = "windcrworkerpublicip"
    location			 = "${var.AZURE_LOCATION}"
    allocation_method	 = "Static"
    resource_group_name  = "${azurerm_resource_group.mydockergroup.name}"
    domain_name_label    = "${var.DOCKER_WINDOWSWORKER_FQDN}"

    tags {
        environment = "Docker Demo"
    }
}
