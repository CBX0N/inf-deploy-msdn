terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  use_oidc = true
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.gal-rg
  location = var.location
}

resource "azurerm_shared_image_gallery" "gal" {
  name                = replace(join("-", ["gal", local.name-suffix]), "-", "")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# resource "azurerm_shared_image" "app" {
#   name                = "windows-iis"
#   os_type             = "Windows"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   gallery_name        = azurerm_shared_image_gallery.gal.name

#   identifier {
#     offer     = "windows-server-2022-iis"
#     publisher = "cbxon"
#     sku       = "standard"
#   }
# }