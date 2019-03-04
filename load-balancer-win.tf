# Definition file for Load balancer of the Windows worker nodes
resource "azurerm_lb" "mywindcrworker" {
  name                = "windcrworkerlb"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"

  frontend_ip_configuration {
    name                 = "windcrworker-frontend"
    public_ip_address_id = "${azurerm_public_ip.mywindcrworker.id}"
  }
}

# Definition for backend address pool for Windows worker nodes
resource "azurerm_lb_backend_address_pool" "mywindcrworker" {
  name                = "windcrworker-backend"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id     = "${azurerm_lb.mywindcrworker.id}"
}

# Definition for the Load balancer health probe for the Windows worker nodes
resource "azurerm_lb_probe" "mywindcrworker" {
  name                = "windcrworker-lb-probe"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id     = "${azurerm_lb.mywindcrworker.id}"
  port                = 3389
}

/*  Definitions for each TCP port that Load balancer is listening to (frontend) and corresponding TCP port on the backend servers
    definitions are mentioned separately for each port that we want to connect to 80, 443, 8080, 8083, 8070 
    for each port - the front end IP config, backend address pool and the health probe is also mentioned */
resource "azurerm_lb_rule" "mywindcrworkerlbrule80" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "windcrworkerlbrule80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "windcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mywindcrworker.id}"
}

resource "azurerm_lb_rule" "mywindcrworkerlbrule443" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "windcrworkerlbrule443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "windcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mywindcrworker.id}"
}

resource "azurerm_lb_rule" "mywindcrworkerlbrule8080" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "windcrworkerlbrule8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "windcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mywindcrworker.id}"
}

resource "azurerm_lb_rule" "mywindcrworkerlbrule8083" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "windcrworkerlbrule8083"
  protocol                       = "Tcp"
  frontend_port                  = 8083
  backend_port                   = 8083
  frontend_ip_configuration_name = "windcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mywindcrworker.id}"
}

resource "azurerm_lb_rule" "mywindcrworkerlbrule8070" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "windcrworkerlbrule8070"
  protocol                       = "Tcp"
  frontend_port                  = 8070
  backend_port                   = 8070
  frontend_ip_configuration_name = "windcrworker-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
  probe_id                       = "${azurerm_lb_probe.mywindcrworker.id}"
}

# Associating the backend_address_pool defined above to the Virtual NIC configuration of first node
resource "azurerm_network_interface_backend_address_pool_association" "mywindcrworker1" {
  network_interface_id    = "${azurerm_network_interface.mywindcrworker1.id}"
  ip_configuration_name   = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[0]}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
}

# Associating the backend_address_pool defined above to the Virtual NIC configuration of second node
resource "azurerm_network_interface_backend_address_pool_association" "mywindcrworker2" {
  network_interface_id    = "${azurerm_network_interface.mywindcrworker2.id}"
  ip_configuration_name   = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[1]}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mywindcrworker.id}"
}

/*  Definition for the NAT rules in Load balancer, so we have a unique front end port to connect to WinRM (5985) and RDP (3389) of each node
    Connection to 15985 on LB will enable connection to port 5985 of first node, and connection to 25985 will connect to port 5985 of second node */
resource "azurerm_lb_nat_rule" "mywindcrworker1-5985" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "winRMaccess-1"
  protocol                       = "Tcp"
  frontend_port                  = 15985
  backend_port                   = 5985
  frontend_ip_configuration_name = "windcrworker-frontend"
}

resource "azurerm_lb_nat_rule" "mywindcrworker2-5985" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "winRMaccess-2"
  protocol                       = "Tcp"
  frontend_port                  = 25985
  backend_port                   = 5985
  frontend_ip_configuration_name = "windcrworker-frontend"
}

resource "azurerm_lb_nat_rule" "mywindcrworker1-3389" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "RDPaccess-1"
  protocol                       = "Tcp"
  frontend_port                  = 13389
  backend_port                   = 3389
  frontend_ip_configuration_name = "windcrworker-frontend"
}

resource "azurerm_lb_nat_rule" "mywindcrworker2-3389" {
  resource_group_name            = "${azurerm_resource_group.mydockergroup.name}"
  loadbalancer_id                = "${azurerm_lb.mywindcrworker.id}"
  name                           = "RDPaccess-2"
  protocol                       = "Tcp"
  frontend_port                  = 23389
  backend_port                   = 3389
  frontend_ip_configuration_name = "windcrworker-frontend"
}


# Associating the NAT rules defined above to the Virtual NIC configuration of first node
resource "azurerm_network_interface_nat_rule_association" "mywindcrworker1-5985" {
  network_interface_id  = "${azurerm_network_interface.mywindcrworker1.id}"
  ip_configuration_name = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[0]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mywindcrworker1-5985.id}" 
}

resource "azurerm_network_interface_nat_rule_association" "mywindcrworker1-3389" {
  network_interface_id  = "${azurerm_network_interface.mywindcrworker1.id}"
  ip_configuration_name = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[0]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mywindcrworker1-3389.id}" 
}


# Associating the NAT rules defined above to the Virtual NIC configuration of second node
resource "azurerm_network_interface_nat_rule_association" "mywindcrworker2-5985" {
  network_interface_id  = "${azurerm_network_interface.mywindcrworker2.id}"
  ip_configuration_name = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[1]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mywindcrworker2-5985.id}" 
}

resource "azurerm_network_interface_nat_rule_association" "mywindcrworker2-3389" {
  network_interface_id  = "${azurerm_network_interface.mywindcrworker2.id}"
  ip_configuration_name = "${var.WINDOWS_WORKER_NIC_CONFIG_NAMES[1]}"
  nat_rule_id           = "${azurerm_lb_nat_rule.mywindcrworker2-3389.id}" 
}