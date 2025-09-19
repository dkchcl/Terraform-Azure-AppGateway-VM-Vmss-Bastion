variable "rg_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}


variable "vmss_name" {
  description = "The name of the virtual machine scale set"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machines"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machines"
  type        = string
}

variable "ip_configuration_name" {
  
}

variable "network_interface_name" {
  
}

variable "application_gateway_name" {
  description = "The name of the application gateway"
  type        = string 
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}



