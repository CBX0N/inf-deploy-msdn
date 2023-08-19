resource "azurerm_virtual_network" "vNet" {
  name                = join("-", ["vnet", local.name-suffix])
  location            = var.location
  resource_group_name = azurerm_resource_group.net-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet" {
  name                 = "vm-snet"
  resource_group_name  = azurerm_resource_group.net-rg.name
  virtual_network_name = azurerm_virtual_network.vNet.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on           = [azurerm_virtual_network.vNet]
}

resource "azurerm_public_ip" "pip" {
  name                = join("-", ["pip", local.vm-name])
  allocation_method   = "Dynamic"
  location            = var.location
  sku                 = "Basic"
  resource_group_name = azurerm_resource_group.net-rg.name
}

resource "azurerm_network_interface" "nic" {
  name                = join("-", ["nic", local.vm-name])
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  ip_configuration {
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  depends_on = [azurerm_subnet.snet]
}