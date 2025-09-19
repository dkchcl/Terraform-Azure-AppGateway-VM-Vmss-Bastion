resource "azurerm_subnet_network_security_group_association" "sub_nsg_assoc" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}






