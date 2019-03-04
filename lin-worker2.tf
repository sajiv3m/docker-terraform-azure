# Definition for second Linux worker node - lindcrworker2

resource "azurerm_virtual_machine" "mylindcrworker2" {
    name                  = "lindcrworker2"
#   This name and VM hostname,mentioned as computer_name below,should be same
    location              = "${var.AZURE_LOCATION}"
    resource_group_name   = "${azurerm_resource_group.mydockergroup.name}"
    network_interface_ids = ["${azurerm_network_interface.mylindcrworker2.id}"]
    vm_size               = "Standard_DS2_v2"

#   default os-disk size is 10G, which is not enough hence mentioned as 40G
    storage_os_disk {
        name              = "lindcrworker2-osdisk"
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
        computer_name  = "lindcrworker2"
        admin_username = "docker-user"
    }

#   This linux worker node will be part of the Linux availability set defined
    availability_set_id = "${azurerm_availability_set.mylindcrworker.id}"
    
#   Using the same key pair files created for UCP host
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

/*  Installing Docker Enterprise on the Linux worker node
    Key parameters are Docker Licence URL, Docker EE version, Docker EE Release, Docker user for the host */
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/lin-files/install_*.sh",
        "sudo mkdir /etc/kubernetes",
        "sudo cp /tmp/lin-files/azure.json /etc/kubernetes",
        "/tmp/lin-files/install_docker_ee.sh \"${var.DOCKER_EE_URL}\" \"${var.DOCKER_EE_VERSION}\" \"${var.DOCKER_EE_RELEASE}\" \"${var.DOCKER_SERVER_USER}\""
        ]
    }

/*  Must login second time separately to ensure docker groupID change is in effect
    for the reason mentioned above, second block of remote-exec used */

    provisioner "remote-exec" {
        inline = [
#   Joining the Linux host to the UCP cluster as a Worker node
        "echo Joining to the Docker UCP cluster as a Worker node",
        "/tmp/lin-files/install_docker_worker_node.sh \"${azurerm_public_ip.mydockerpublicip.fqdn}\" \"${var.DOCKER_ADMIN_USER}\" \"${var.DOCKER_ADMIN_PASSWORD}\" \"${var.DOCKER_UCP_PORT}\"",
/*  Installing CloudStor plugin, so containers can use Cloud storage for data volumes
    key parameters are Storage account name and the Storage access key for the account */
        "/tmp/lin-files/install_docker_storage_plugin.sh \"${var.DOCKER_STORAGE_ACCOUNT}\" \"${azurerm_storage_account.dcrstorageaccount.primary_access_key}\""
        ]
    }
    
/*  Following is the connection info for all the remote-exec and remote file copy (provisioner - file) mentioned above
    Host is the Load balancer FQDN configured for the Linux availability set
    Port is the front end port for this load balancer IP, which is NATed to the SSH port -22
    Refer Load balancer definition for more details */
    connection {
        user = "${var.DOCKER_SERVER_USER}"
        private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
        host = "${azurerm_public_ip.mylindcrworker.fqdn}"
        port = "4222"
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
