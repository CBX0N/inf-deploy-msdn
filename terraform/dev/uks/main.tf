terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {

    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = true
    }

  }
}

resource "random_password" "azure-password" {
  min_numeric      = 1
  min_lower        = 1
  min_special      = 1
  min_upper        = 1
  override_special = "-"
  length           = 10
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = local.vm-name
  computer_name         = "iisvmcbxdev001"
  resource_group_name   = azurerm_resource_group.vm-rg.name
  location              = azurerm_resource_group.vm-rg.location
  size                  = "Standard_D2as_v4"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  admin_username = "azureuser"
  admin_password = random_password.azure-password.result

  depends_on = [azurerm_network_interface.nic, random_password.azure-password, azurerm_resource_group.vm-rg]
}