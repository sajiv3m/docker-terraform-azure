# Definition file to print the Name and IP address of Docker UCP host and Linux & Windows worker nodes
output "Docker-ucp-host-name" {
  value = "${azurerm_public_ip.mydockerpublicip.fqdn}"
}

output "docker-ucp-host-ip" {
  value = "${azurerm_public_ip.mydockerpublicip.ip_address}"
}

output "linux-worker-lb-host-name" {
  value = "${azurerm_public_ip.mylindcrworker.fqdn}"
}

output "linux-worker-lb-host-ip" {
  value = "${azurerm_public_ip.mylindcrworker.ip_address}"
}

output "windows-worker-lb-host-name" {
  value = "${azurerm_public_ip.mywindcrworker.fqdn}"
}

output "windows-worker-lb-host-ip" {
  value = "${azurerm_public_ip.mywindcrworker.ip_address}"
}