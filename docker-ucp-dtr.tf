# Definition for the main docker VM which hosts UCP, DTR components
resource "azurerm_virtual_machine" "mydockervm" {
    name                  = "dockervm"
    location              = "${var.AZURE_LOCATION}"
    resource_group_name   = "${azurerm_resource_group.mydockergroup.name}"
    network_interface_ids = ["${azurerm_network_interface.mydockernic.id}"]
    vm_size               = "Standard_DS3_v2"

#    default os-disk size is 10G, which is not enough hence mentioned as 40G
    storage_os_disk {
        name              = "dockervm-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
        disk_size_gb      = "40"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dockervm"
        admin_username = "${var.DOCKER_SERVER_USER}"
    }

#   key pair must be created using ssh-keygen -m PEM -f docker-key
#   before running terraform apply
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/docker-user/.ssh/authorized_keys"
            key_data = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
        }
    }

#   copy scripts and files for linux hosts from lin-files folder to /tmp on target VM
    provisioner "file" {
        source = "lin-files"
        destination = "/tmp"
    } 

/*  azure.json must be updated with the correct values before terraform apply
    azure.json will be copied to /etc folder of the Docker UCP host, which must be a linux VM */

/*  Installing Docker Enterprise on the UCP host
    Key parameters are Docker Licence URL, Docker EE version, Docker EE Release, Docker user for the host */
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/lin-files/install*.sh",
        "sudo mkdir /etc/kubernetes",
        "sudo cp /tmp/lin-files/azure.json /etc/kubernetes",
        "/tmp/lin-files/install_docker_ee.sh \"${var.DOCKER_EE_URL}\" \"${var.DOCKER_EE_VERSION}\" \"${var.DOCKER_EE_RELEASE}\" \"${var.DOCKER_SERVER_USER}\""
        ]
    }

    provisioner "remote-exec" {
        inline = [
#   Installing Docker UCP with parameters - UCP version, FQDN of UCP host, Docker ADMIN, Docker Admin password, private IP of UCP host, SSL port to use for UCP host, Vnet address prefix
        "echo Installing Docker UCP on ${azurerm_public_ip.mydockerpublicip.fqdn}",
        "/tmp/lin-files/install_docker_ucp.sh \"${var.DOCKER_UCP_VERSION}\" \"${azurerm_public_ip.mydockerpublicip.fqdn}\" \"${var.DOCKER_ADMIN_USER}\" \"${var.DOCKER_ADMIN_PASSWORD}\" \"${azurerm_network_interface.mydockernic.private_ip_address}\" \"${var.DOCKER_UCP_PORT}\" \"${azurerm_subnet.mydockersubnet.address_prefix}\"",
/*  Installing DTR with parameters - FQDN of UCP and DTR host, Docker ADMIN, Docker Admin password, SSL port used for UCP host
    DTR is being installed on the same host as UCP. */
        "echo Installing Docker Trusted Registry on ${azurerm_public_ip.mydockerpublicip.fqdn}",
        "/tmp/lin-files/install_docker_dtr.sh \"${azurerm_public_ip.mydockerpublicip.fqdn}\" \"${var.DOCKER_ADMIN_USER}\" \"${var.DOCKER_ADMIN_PASSWORD}\" \"${var.DOCKER_UCP_PORT}\"",
/*  Installing CloudStor plugin, so containers can use Cloud storage for data volumes
    key parameters are Storage account name and the Storage access key for the account */
        "echo Installing CloudStor Docker storage plugin on ${azurerm_public_ip.mydockerpublicip.fqdn}",
        "/tmp/lin-files/install_docker_storage_plugin.sh \"${var.DOCKER_STORAGE_ACCOUNT}\" \"${azurerm_storage_account.dcrstorageaccount.primary_access_key}\""
        ]
    }

#   Connection details for all the remote-exec and remote file copy (provisioner - file) mentioned above
    connection {
        user = "${var.DOCKER_SERVER_USER}"
        private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

#   Place to store the boot diagnostics of the VM
    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.dcrstorageaccount.primary_blob_endpoint}"
    }

/*  Orchestrator tag with the Kubernetes version is mandatory
    Kubernetes version for each Docker UCP release may be different. Check this in UCP release notes */
    tags {
        environment = "Docker Demo"
        Orchestrator = "Kubernetes:${var.KUBERNETES_VERSION}"
    }
}
