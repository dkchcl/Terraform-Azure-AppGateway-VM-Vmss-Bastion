data "azurerm_application_gateway" "appgw" {
  name                = var.application_gateway_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}

data "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = var.rg_name
}