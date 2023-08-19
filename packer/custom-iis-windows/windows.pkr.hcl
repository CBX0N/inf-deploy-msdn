packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

source "azure-arm" "base" {
  location                 = "uksouth"
  vm_size                  = "Standard_D2as_v4"
  temp_resource_group_name = "iis-packer-rg"
  temp_compute_name        = "iis-packer-vm"
  temp_nic_name            = "iis-packer-nic"

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-Datacenter"

  communicator   = "winrm"
  winrm_use_ssl  = "true"
  winrm_insecure = "true"
  winrm_timeout  = "5m"
  winrm_username = "azureadmin123"
  winrm_password = "password2023Ass"

  shared_image_gallery_destination {
    resource_group = "rg-gal-cbx-uks-dev-001"
    image_name     = "windows-iis"
    gallery_name   = "galcbxuksdev001"
    image_version  = "0.0.4"
  }
  use_azure_cli_auth = "true"
}

build {
  name = "build"
  sources = ["source.azure-arm.base"]
  provisioner "powershell" {
  inline = ["Add-WindowsFeature Web-Server"]
  }
  provisioner "powershell" {
    script = "./packer/setup.ps1"
  }
  provisioner "powershell" {
    inline = [
      "",
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", 
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", 
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit", 
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
      ]
  }
}