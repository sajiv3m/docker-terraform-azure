# Definition file for Load balancer of the Linux worker nodes

resource "azurerm_lb" "mylindcrworker" {
  name                = "lindcrworkerlb"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

  frontend_ip_configuration {
    name                 = "lindcrworker-frontend"
    public_ip_address_id = "${azurerm_public_ip.mylindcrworker.id}"
  }
}

# Definition for backend address pool for Linux worker nodes
resource "azurerm_lb_backend_address_pool" "mylindcrworker" {
  name                = "lindcrworker-backend"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id     = "${azurerm_lb.mylindcrworker.id}"  
}

# Definition for the Load balancer health probe for the Linux worker nodes
resource "azurerm_lb_probe" "mylindcrworker" {
  name                = "lindcrworker-lb-probe"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id     = "${azurerm_lb.mylindcrworker.id}"
  port                = 22
}

/*  Definitions for each TCP port that Load balancer is listening to (frontend) and corresponding TCP port on the backend servers
    definitions are mentioned separately for each port that we want to connect to 80, 443, 8080, 8083, 8070 
    for each port - the front end IP config, backend address pool and the health probe is also mentioned */

resource "azurerm_lb_rule" "mylindcrworkerlbrule80" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "lindcrworkerlbrule80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lindcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mylindcrworker.id}"
}

resource "azurerm_lb_rule" "mylindcrworkerlbrule443" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "lindcrworkerlbrule443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "lindcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mylindcrworker.id}"
}

resource "azurerm_lb_rule" "mylindcrworkerlbrule8080" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "lindcrworkerlbrule8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "lindcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mylindcrworker.id}"
}

resource "azurerm_lb_rule" "mylindcrworkerlbrule8083" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "lindcrworkerlbrule8083"
  protocol                       = "Tcp"
  frontend_port                  = 8083
  backend_port                   = 8083
  frontend_ip_configuration_name = "lindcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mylindcrworker.id}"
}

resource "azurerm_lb_rule" "mylindcrworkerlbrule8070" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "lindcrworkerlbrule8070"
  protocol                       = "Tcp"
  frontend_port                  = 8070
  backend_port                   = 8070
  frontend_ip_configuration_name = "lindcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mylindcrworker.id}"
}


# Associating the backend_address_pool defined above to the Virtual NIC configuration of first node
resource "azurerm_network_interface_backend_address_pool_association" "mylindcrworker1" {
  network_interface_id    = "${azurerm_network_interface.mylindcrworker1.id}"
  ip_configuration_name   = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[0]}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
}

# Associating the backend_address_pool defined above to the Virtual NIC configuration of second node

resource "azurerm_network_interface_backend_address_pool_association" "mylindcrworker2" {
  network_interface_id    = "${azurerm_network_interface.mylindcrworker2.id}"
  ip_configuration_name   = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[1]}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mylindcrworker.id}"
}

/*  Definition for the NAT rules in Load balancer, so we have a unique front end port to connect to SSH of each node
    Connection to 4221 on LB will enable connection to port 22 of first node, and connection to 4222 will connect to port 22 of second node */
resource "azurerm_lb_nat_rule" "mylindcrworker1" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "SSHaccess-1"
  protocol                       = "Tcp"
  frontend_port                  = 4221
  backend_port                   = 22
  frontend_ip_configuration_name = "lindcrworker-frontend"
}

resource "azurerm_lb_nat_rule" "mylindcrworker2" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mylindcrworker.id}"
  name                           = "SSHaccess-2"
  protocol                       = "Tcp"
  frontend_port                  = 4222
  backend_port                   = 22
  frontend_ip_configuration_name = "lindcrworker-frontend"
}

# Associating the NAT rule defined above to the Virtual NIC configuration of first node
resource "azurerm_network_interface_nat_rule_association" "mylindcrworker1" {
  network_interface_id  = "${azurerm_network_interface.mylindcrworker1.id}"
  ip_configuration_name = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[0]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mylindcrworker1.id}" 
}

# Associating the NAT rule defined above to the Virtual NIC configuration of second node
resource "azurerm_network_interface_nat_rule_association" "mylindcrworker2" {
  network_interface_id  = "${azurerm_network_interface.mylindcrworker2.id}"
  ip_configuration_name = "${var.LINUX_WORKER_NIC_CONFIG_NAMES[1]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mylindcrworker2.id}" 
}