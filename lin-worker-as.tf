# Definition for the Availability set of the Linux worker nodes
resource "azurerm_availability_set" "mylindcrworker" {
  name                = "lin-dcr-worker-as"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.mydockergroup.name}"
  platform_fault_domain_count = "2"
  platform_update_domain_count = "2"
  managed = "true"

  tags {
    environment = "Docker Demo"
  }
}