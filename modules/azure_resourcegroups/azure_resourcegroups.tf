# DATA SOURCES

# Data source to access the configuration of the AzureRM provider
data "azurerm_client_config" "current" {

}

# Create resource group to hold all builds and resources
resource "azurerm_resource_group" "iac_rg" {
    name = var.azure_rg
    location = var.azure_location 
}

# Create virtual network for use with Key Vault
resource "azurerm_virtual_network" "iac_vnet" {
    name = var.azure_virtual_net
    location = var.azure_location
    resource_group_name = azurerm_resource_group.iac_rg.name
    address_space = ["10.0.0.0/16"]

}


resource "azurerm_subnet" "iac_vnet_subnet" {
    name = var.address_space_subnet_name
    resource_group_name = azurerm_resource_group.iac_rg.name 
    virtual_network_name = azurerm_virtual_network.iac_vnet.name
    address_prefixes = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.KeyVault",]
    enforce_private_link_endpoint_network_policies = true
}

// resource "azurerm_public_ip" "iac_pip" {
//   name                = "beau-iac-pip"
//   sku                 = "Standard"
//   location            = azurerm_resource_group.iac_rg.location
//   resource_group_name = azurerm_resource_group.iac_rg.name
//   allocation_method   = "Static"
// }

// resource "azurerm_lb" "example" {
//   name                = "example-lb"
//   sku                 = "Standard"
//   location            = azurerm_resource_group.iac_rg.location
//   resource_group_name = azurerm_resource_group.iac_rg.name

//   frontend_ip_configuration {
//     name                 = azurerm_public_ip.iac_pip.name
//     public_ip_address_id = azurerm_public_ip.iac_pip.id
//   }
// }


// resource "azurerm_private_link_service" "iac_azure_private_link_service" {
//     name = var.azure_private_link_service_name
//     resource_group_name = azurerm_resource_group.iac_rg.name
//     location = azurerm_resource_group.iac_rg.location

//     auto_approval_subscription_ids = [data.azurerm_client_config.current.subscription_id]
//     visibility_subscription_ids = [data.azurerm_client_config.current.subscription_id]

//     nat_ip_configuration {
//         name = "primary"
//         private_ip_address = "10.0.1.11"
//         private_ip_address_version = "IPv4"
//         subnet_id = azurerm_subnet.iac_vnet_subnet.id
//         primary = true
//     }

//       load_balancer_frontend_ip_configuration_ids = [azurerm_lb.example.frontend_ip_configuration.0.id,
//   ]
// }