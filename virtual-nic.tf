# Definition file for the NIC cards of all 5 hosts
resource "azurerm_network_interface" "mydockernic" {
    name                = "myNIC"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
    network_security_group_id = "${azurerm_network_security_group.mydockernsg.id}"

    ip_configuration {
        name                          = "dockervm-nic-config"
        subnet_id                     = "${azurerm_subnet.mydockersubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.mydockerpublicip.id}"
    }

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_network_interface" "mylindcrworker1" {
    name                = "lindcrworkernic1"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

    ip_configuration {
        name                          = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[0]}"
        subnet_id                     = "${azurerm_subnet.mydockersubnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_network_interface" "mylindcrworker2" {
    name                = "lindcrworkernic2"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

    ip_configuration {
        name                          = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[1]}"
        subnet_id                     = "${azurerm_subnet.mydockersubnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_network_interface" "mywindcrworker1" {
    name                = "windcrworkernic1"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

    ip_configuration {
        name                          = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[0]}"
        subnet_id                     = "${azurerm_subnet.mydockersubnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags {
        environment = "Docker Demo"
    }
}

resource "azurerm_network_interface" "mywindcrworker2" {
    name                = "windcrworkernic2"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

    ip_configuration {
        name                          = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[1]}"
        subnet_id                     = "${azurerm_subnet.mydockersubnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags {
        environment = "Docker Demo"
    }
}