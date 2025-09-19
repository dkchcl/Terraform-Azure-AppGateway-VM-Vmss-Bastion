module "rg" {
  source   = "../../Modules/azurerm_resource_group"
  rg_name  = "rg-prod-weu-001"
  location = "West Europe"
}

module "vnet" {
  depends_on    = [module.rg]
  source        = "../../Modules/azurerm_virtual_network"
  vnet_name     = "vnet-prod-weu-001"
  address_space = ["10.0.0.0/16"]
  rg_name       = "rg-prod-weu-001"
  location      = "West Europe"
}

module "subnet1" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "snet-prod-weu-001"
  vnet_name        = "vnet-prod-weu-001"
  address_prefixes = ["10.0.1.0/24"]
  rg_name          = "rg-prod-weu-001"
}

module "subnet2" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "snet-prod-appgw-002"
  vnet_name        = "vnet-prod-weu-001"
  address_prefixes = ["10.0.2.0/24"]
  rg_name          = "rg-prod-weu-001"
}

module "subnet3" {
  depends_on       = [module.vnet]
  source           = "../../Modules/azurerm_subnet"
  subnet_name      = "AzureBastionSubnet"
  vnet_name        = "vnet-prod-weu-001"
  address_prefixes = ["10.0.3.0/24"]
  rg_name          = "rg-prod-weu-001"
}

module "pip1" {
  depends_on        = [module.rg]
  source            = "../../Modules/azurerm_public_ip"
  pip_name          = "bastion-pip-prod-001"
  rg_name           = "rg-prod-weu-001"
  location          = "West Europe"
  allocation_method = "Static"
}

module "pip2" {
  depends_on        = [module.rg]
  source            = "../../Modules/azurerm_public_ip"
  pip_name          = "appgw-pip-prod-001"
  rg_name           = "rg-prod-weu-001"
  location          = "West Europe"
  allocation_method = "Static"
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_network_security_group"
  nsg_name   = "nsg-prod-weu-001"
  rg_name    = "rg-prod-weu-001"
  location   = "West Europe"
}

# module "bastion" {
#   depends_on            = [module.pip1, module.subnet3]
#   source                = "../../Modules/azurerm_bastion_host"
#   bastion_name          = "bastion-prod-weu-001"
#   rg_name               = "rg-prod-weu-001"
#   location              = "West Europe"
#   bsubnet_name          = "AzureBastionSubnet"
#   vnet_name             = "vnet-prod-weu-001"
#   pip_name              = "bastion-pip-prod-001"
#   ip_configuration_name = "bastion-ip-config"
# }

module "sub_nsg_assoc" {
  depends_on = [module.nsg, module.subnet2, module.vnet]
  source     = "../../Modules/azurerm_nic_sub_nsg_assoc"
  rg_name    = "rg-prod-weu-001"
  nsg_name    = "nsg-prod-weu-001"
  vnet_name   = "vnet-prod-weu-001"
  subnet_name = "snet-prod-appgw-002"
}

module "appgw" {
  depends_on                     = [module.pip2, module.sub_nsg_assoc]
  source                         = "../../Modules/azurerm_application_gateway"
  application_gateway_name       = "appgw-prod-weu-001"
  rg_name                        = "rg-prod-weu-001"
  location                       = "West Europe"
  gateway_ip_configuration_name  = "appgw-gateway-ip-config"
  frontend_ip_configuration_name = "appgw-frontend-ip-config"
  frontend_port_name             = "appgw-frontend-port"
  backend_address_pool_name      = "appgw-backend-pool"
  http_setting_name              = "appgw-backend-http-settings"
  listener_name                  = "appgw-http-listener"
  request_routing_rule_name      = "appgw-request-routing-rule"
  subnet_name                    = "snet-prod-appgw-002"
  vnet_name                      = "vnet-prod-weu-001"
  pip_name                       = "appgw-pip-prod-001"
}

module "vmss" {
  depends_on               = [module.nsg, module.subnet1, module.appgw]
  source                   = "../../Modules/azurerm_vmss"
  vmss_name                = "vmss-prod-appgw-001"
  rg_name                  = "rg-prod-weu-001"
  location                 = "West Europe"
  admin_username           = "adminuser"
  admin_password           = "Password1234!"
  vnet_name                = "vnet-prod-weu-001"
  subnet_name              = "snet-prod-weu-001"
  network_interface_name   = "vmss-nic-001"
  ip_configuration_name    = "vmss-internal"
  nsg_name                 = "nsg-prod-weu-001"
  application_gateway_name = "appgw-prod-weu-001"
}

module "autoscale" {
  depends_on     = [module.vmss]
  source         = "../../Modules/azurerm_vmss_monitor_autoscale_setting"
  rg_name        = "rg-prod-weu-001"
  location       = "West Europe"
  vmss_name      = "vmss-prod-appgw-001"
  vmss_autoscale = "vmss-autoscale-001"
}

