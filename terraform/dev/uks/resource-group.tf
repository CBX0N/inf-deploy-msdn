resource "azurerm_resource_group" "vm-rg" {
  name     = local.vm-rg
  location = var.location
}
resource "azurerm_resource_group" "net-rg" {
  name     = local.net-rg
  location = var.location
}