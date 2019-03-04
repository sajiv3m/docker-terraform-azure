# Definition for first Windows worker node - windcrworker1

resource "azurerm_virtual_machine" "mywindcrworker1" {
    name                  = "windcrworker1"
    location              = "${var.AZURE_LOCATION}"
    resource_group_name   = "${azurerm_resource_group.mydockergroup.name}"
    network_interface_ids = ["${azurerm_network_interface.mywindcrworker1.id}"]
    vm_size               = "Standard_DS2_v2"

#   default OS disk size for the Windows 2016 image is 127G
    storage_os_disk {
        name              = "windcrworker1-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

#   This windows worker node will be part of the Windows availability set defined
    availability_set_id = "${azurerm_availability_set.mywindcrworker.id}"

    os_profile {
        computer_name  = "windcrworker1"
        admin_username = "${var.DOCKER_SERVER_USER}"
        admin_password = "${var.DOCKER_SERVER_PASSWORD}"
        custom_data    = "${file("./win-files/winrm.ps1")}"
        # this copies the winrm.ps1 file to C:\AzureData\CustomData.bin
    }
    
    os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

      # Auto-Login required to configure WinRM
      additional_unattend_config {
        pass         = "oobeSystem"
        component    = "Microsoft-Windows-Shell-Setup"
        setting_name = "AutoLogon"
        content      = "<AutoLogon><Password><Value>${var.DOCKER_SERVER_PASSWORD}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.DOCKER_SERVER_USER}</Username></AutoLogon>"
      }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
      additional_unattend_config {
        pass         = "oobeSystem"
        component    = "Microsoft-Windows-Shell-Setup"
        setting_name = "FirstLogonCommands"
        content      = "${file("./win-files/FirstLogonCommands.xml")}"
      }
    }

# Now that WinRM is configured, copy all required files using provisioner

  provisioner "file" {
      source = "win-files"
      destination = "C:\\terraform"
  } 

# Installing Docker EE v18.09.0 on the Windows worker node

  provisioner "remote-exec" {
    inline = [
      "cd C:\\terraform",
      "powershell.exe -sta -WindowStyle Hidden -ExecutionPolicy Unrestricted -file C:\\terraform\\install-win-docker-ee.ps1"
    ]
  }

/*Windows VM must be restarted after installing Docker EE
  forcing execution to sleep 5 minutes for the VM to finish restart */
  provisioner "local-exec" {
    command = "sleep 300"
  }

# Joining the server to UCP cluster as a worker node
  provisioner "remote-exec" {
    inline = [
      "cd C:\\terraform",
      "powershell.exe -sta -WindowStyle Hidden -ExecutionPolicy Unrestricted -file C:\\terraform\\configure-win-docker.ps1 ${azurerm_public_ip.mydockerpublicip.fqdn} ${var.DOCKER_ADMIN_USER} ${var.DOCKER_ADMIN_PASSWORD} ${var.DOCKER_UCP_PORT}"
    ]
  } 


  connection {
      type     = "winrm"
      user     = "${var.DOCKER_SERVER_USER}"
      password = "${var.DOCKER_SERVER_PASSWORD}"
      port     = 15985
      https    = false
      timeout  = "10m"
      host = "${azurerm_public_ip.mywindcrworker.fqdn}"
      # NOTE: if you're using a real certificate, rather than a self-signed one, you'll want this set to `false`/to remove this.
      # insecure = true
  }


  boot_diagnostics {
      enabled     = "true"
      storage_uri = "${azurerm_storage_account.dcrstorageaccount.primary_blob_endpoint}"
  }


  tags {
        environment = "Docker Demo"
  }
}
