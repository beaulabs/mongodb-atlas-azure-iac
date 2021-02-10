output "resourcegroup_location" {
  description = "The location of the resource group"
  value = azurerm_resource_group.iac_rg.location
}

output "resourcegroup_name" {
  description = "The name of the resource group"
  value = azurerm_resource_group.iac_rg.name
}

output "virtual_network_subnet_ids" {
  description = "The virtual network subnet ids"
  value = azurerm_subnet.iac_vnet_subnet.id
}


