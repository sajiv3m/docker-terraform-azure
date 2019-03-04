/*  Definition file for the firewall rules / NSG applicable for all hosts in the cluster
    Lower the priority number, higher the priority of the rule */

resource "azurerm_network_security_group" "mydockernsg" {
    name                = "${var.DOCKER_NSG_NAME}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

/*  To allow SSH, RDP, WinRM, Docker UCP, DTR, Kubernetes ports from my PC IP address only
    Find the PCs Internet IP address by visiting https://whatismyip.com and mention this in the variable file */

    security_rule {
        name                       = "DockerApp-ssh"
        priority                   = 900
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = "${var.ALLOWED_PORTS}"
        source_address_prefix      = "${var.MY_PUBLIC_IP}"
        destination_address_prefix = "*"
    }

#   Docker UCP, DTR ports to be accessible from anywhere on Internet

    security_rule {
        name                       = "DockerApp"
        priority                   = 910
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["80", "443", "8070-8090"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

#   From the hosts on same subnet all TCP ports are allowed

    security_rule {
        name                       = "DockerTCP"
        priority                   = 920
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "${var.DOCKER_SUBNET}"
        destination_address_prefix = "*"
    }

#   From the hosts on same subnet all UDP ports are allowed

    security_rule {
        name                       = "DockerUDP"
        priority                   = 930
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "${var.DOCKER_SUBNET}"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Docker Demo"
    }
}

